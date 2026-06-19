import asyncHandler from "express-async-handler";
import { sequelize, Card, List, BoardMember } from "../models/index.js";

export const createCard = asyncHandler(async (req, res) => {
  const { title, description, priority, dueDate } = req.body;
  const list = await List.findOne({
    where: { id: req.params.listId, boardId: req.params.boardId },
  });
  if (!list) {
    res.status(404);
    throw new Error("List not found");
  }
  const maxPosition = await Card.max("position", { where: { listId: list.id } });
  const card = await Card.create({
    listId: list.id,
    boardId: req.params.boardId,
    title,
    description,
    priority,
    dueDate,
    position: Number.isFinite(maxPosition) ? maxPosition + 1 : 0,
  });
  res.status(201).json(card);
});

export const updateCard = asyncHandler(async (req, res) => {
  const card = await Card.findOne({
    where: { id: req.params.cardId, boardId: req.params.boardId },
  });
  if (!card) {
    res.status(404);
    throw new Error("Card not found");
  }
  const { title, description, priority, dueDate } = req.body;
  if (title !== undefined) card.title = title;
  if (description !== undefined) card.description = description;
  if (priority !== undefined) card.priority = priority;
  if (dueDate !== undefined) card.dueDate = dueDate;
  await card.save();
  res.json(card);
});

export const deleteCard = asyncHandler(async (req, res) => {
  const card = await Card.findOne({
    where: { id: req.params.cardId, boardId: req.params.boardId },
  });
  if (!card) {
    res.status(404);
    throw new Error("Card not found");
  }
  await card.destroy();
  res.json({ message: "Card removed" });
});

export const assignCard = asyncHandler(async (req, res) => {
  const card = await Card.findOne({
    where: { id: req.params.cardId, boardId: req.params.boardId },
  });
  if (!card) {
    res.status(404);
    throw new Error("Card not found");
  }
  const { assigneeId } = req.body;
  if (assigneeId !== null) {
    const membership = await BoardMember.findOne({
      where: { boardId: req.params.boardId, userId: assigneeId },
    });
    if (!membership) {
      res.status(400);
      throw new Error("Assignee must be a current board member");
    }
  }
  card.assigneeId = assigneeId;
  await card.save();
  res.json(card);
});

export const moveCard = asyncHandler(async (req, res) => {
  const { cardId, sourceListId, targetListId, orderedCardIdsInTargetList } = req.body;
  if (!Array.isArray(orderedCardIdsInTargetList)) {
    res.status(400);
    throw new Error("orderedCardIdsInTargetList must be an array");
  }

  await sequelize.transaction(async (t) => {
    const card = await Card.findOne({
      where: { id: cardId, boardId: req.params.boardId },
      transaction: t,
    });
    if (!card) {
      res.status(404);
      throw new Error("Card not found");
    }
    if (String(card.listId) !== String(targetListId)) {
      card.listId = targetListId;
      await card.save({ transaction: t });
    }

    await Promise.all(
      orderedCardIdsInTargetList.map((id, index) =>
        Card.update(
          { position: index },
          { where: { id, boardId: req.params.boardId }, transaction: t }
        )
      )
    );

    if (sourceListId && String(sourceListId) !== String(targetListId)) {
      const remaining = await Card.findAll({
        where: { listId: sourceListId, boardId: req.params.boardId },
        order: [["position", "ASC"]],
        transaction: t,
      });
      await Promise.all(
        remaining.map((c, index) =>
          c.update({ position: index }, { transaction: t })
        )
      );
    }
  });

  const card = await Card.findByPk(cardId);
  res.json(card);
});
