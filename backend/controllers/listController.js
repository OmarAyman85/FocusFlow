import asyncHandler from "express-async-handler";
import { sequelize, List } from "../models/index.js";

export const createList = asyncHandler(async (req, res) => {
  const { name } = req.body;
  const maxPosition = await List.max("position", {
    where: { boardId: req.params.boardId },
  });
  const list = await List.create({
    boardId: req.params.boardId,
    name,
    position: Number.isFinite(maxPosition) ? maxPosition + 1 : 0,
  });
  res.status(201).json(list);
});

export const updateList = asyncHandler(async (req, res) => {
  const list = await List.findOne({
    where: { id: req.params.listId, boardId: req.params.boardId },
  });
  if (!list) {
    res.status(404);
    throw new Error("List not found");
  }
  if (req.body.name !== undefined) list.name = req.body.name;
  await list.save();
  res.json(list);
});

export const deleteList = asyncHandler(async (req, res) => {
  const list = await List.findOne({
    where: { id: req.params.listId, boardId: req.params.boardId },
  });
  if (!list) {
    res.status(404);
    throw new Error("List not found");
  }
  await list.destroy();
  res.json({ message: "List removed" });
});

export const reorderLists = asyncHandler(async (req, res) => {
  const { orderedListIds } = req.body;
  if (!Array.isArray(orderedListIds) || orderedListIds.length === 0) {
    res.status(400);
    throw new Error("orderedListIds must be a non-empty array");
  }

  await sequelize.transaction(async (t) => {
    await Promise.all(
      orderedListIds.map((listId, index) =>
        List.update(
          { position: index },
          { where: { id: listId, boardId: req.params.boardId }, transaction: t }
        )
      )
    );
  });

  const lists = await List.findAll({
    where: { boardId: req.params.boardId },
    order: [["position", "ASC"]],
  });
  res.json(lists);
});
