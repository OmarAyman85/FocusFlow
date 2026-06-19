import asyncHandler from "express-async-handler";
import { Op } from "sequelize";
import { sequelize, Board, BoardMember, List, Card, User } from "../models/index.js";

const memberAttributes = ["id", "name", "email", "profileImage"];

const loadFullBoard = (boardId) =>
  Board.findByPk(boardId, {
    include: [
      { model: User, as: "owner", attributes: memberAttributes },
      {
        model: List,
        as: "lists",
        separate: true,
        order: [["position", "ASC"]],
        include: [
          {
            model: Card,
            as: "cards",
            separate: true,
            order: [["position", "ASC"]],
            include: [{ model: User, as: "assignee", attributes: memberAttributes }],
          },
        ],
      },
      {
        model: BoardMember,
        as: "memberships",
        include: [{ model: User, as: "user", attributes: memberAttributes }],
      },
    ],
  });

export const getMyBoards = asyncHandler(async (req, res) => {
  const boards = await Board.findAll({
    where: { ownerId: req.user.id },
    order: [["updatedAt", "DESC"]],
  });
  res.json(boards);
});

export const getSharedBoards = asyncHandler(async (req, res) => {
  const memberships = await BoardMember.findAll({
    where: { userId: req.user.id, role: { [Op.ne]: "owner" } },
    include: [{ model: Board, attributes: ["id", "name", "description", "visibility", "ownerId"] }],
  });
  res.json(memberships.map((m) => ({ ...m.Board.toJSON(), myRole: m.role })));
});

export const getPublicBoards = asyncHandler(async (req, res) => {
  const boards = await Board.findAll({
    where: { visibility: "public" },
    include: [{ model: User, as: "owner", attributes: memberAttributes }],
    order: [["updatedAt", "DESC"]],
    limit: 50,
  });
  res.json(boards);
});

export const createBoard = asyncHandler(async (req, res) => {
  const { name, description, visibility } = req.body;
  const board = await sequelize.transaction(async (t) => {
    const created = await Board.create(
      { name, description, visibility: visibility === "public" ? "public" : "private", ownerId: req.user.id },
      { transaction: t }
    );
    await BoardMember.create(
      { boardId: created.id, userId: req.user.id, role: "owner" },
      { transaction: t }
    );
    return created;
  });
  res.status(201).json(board);
});

export const getBoard = asyncHandler(async (req, res) => {
  const board = await loadFullBoard(req.params.boardId);
  if (!board) {
    res.status(404);
    throw new Error("Board not found");
  }

  if (board.visibility === "private") {
    if (!req.user) {
      res.status(401);
      throw new Error("Login required to view this board");
    }
    const membership = await BoardMember.findOne({
      where: { boardId: board.id, userId: req.user.id },
    });
    if (!membership) {
      res.status(403);
      throw new Error("You are not a member of this board");
    }
  }

  res.json(board);
});

export const updateBoard = asyncHandler(async (req, res) => {
  const board = await Board.findByPk(req.params.boardId);
  if (!board) {
    res.status(404);
    throw new Error("Board not found");
  }
  const { name, description } = req.body;
  if (name !== undefined) board.name = name;
  if (description !== undefined) board.description = description;
  await board.save();
  res.json(board);
});

export const setVisibility = asyncHandler(async (req, res) => {
  const board = await Board.findByPk(req.params.boardId);
  if (!board) {
    res.status(404);
    throw new Error("Board not found");
  }
  if (!["private", "public"].includes(req.body.visibility)) {
    res.status(400);
    throw new Error("visibility must be 'private' or 'public'");
  }
  board.visibility = req.body.visibility;
  await board.save();
  res.json(board);
});

export const deleteBoard = asyncHandler(async (req, res) => {
  const board = await Board.findByPk(req.params.boardId);
  if (!board) {
    res.status(404);
    throw new Error("Board not found");
  }
  await board.destroy();
  res.json({ message: "Board removed" });
});

export const joinBoard = asyncHandler(async (req, res) => {
  const board = await Board.findByPk(req.params.boardId);
  if (!board) {
    res.status(404);
    throw new Error("Board not found");
  }
  if (board.visibility !== "public") {
    res.status(403);
    throw new Error("This board is private and cannot be joined without an invite");
  }
  const existing = await BoardMember.findOne({
    where: { boardId: board.id, userId: req.user.id },
  });
  if (existing) {
    res.status(400);
    throw new Error("You are already a member of this board");
  }
  const membership = await BoardMember.create({
    boardId: board.id,
    userId: req.user.id,
    role: "viewer",
  });
  res.status(201).json(membership);
});

export const leaveBoard = asyncHandler(async (req, res) => {
  const membership = await BoardMember.findOne({
    where: { boardId: req.params.boardId, userId: req.user.id },
  });
  if (!membership) {
    res.status(404);
    throw new Error("You are not a member of this board");
  }
  if (membership.role === "owner") {
    res.status(400);
    throw new Error("The owner cannot leave the board — delete it or transfer ownership instead");
  }
  await membership.destroy();
  res.json({ message: "Left board" });
});

export const getMembers = asyncHandler(async (req, res) => {
  const members = await BoardMember.findAll({
    where: { boardId: req.params.boardId },
    include: [{ model: User, as: "user", attributes: memberAttributes }],
  });
  res.json(members);
});

export const inviteMember = asyncHandler(async (req, res) => {
  const { email } = req.body;
  const user = await User.findOne({ where: { email } });
  if (!user) {
    res.status(404);
    throw new Error("No user found with that email");
  }
  const existing = await BoardMember.findOne({
    where: { boardId: req.params.boardId, userId: user.id },
  });
  if (existing) {
    res.status(400);
    throw new Error("User is already a member of this board");
  }
  const membership = await BoardMember.create({
    boardId: req.params.boardId,
    userId: user.id,
    role: "member",
  });
  res.status(201).json(membership);
});

export const updateMemberRole = asyncHandler(async (req, res) => {
  const { role } = req.body;
  if (!["owner", "admin", "member", "viewer"].includes(role)) {
    res.status(400);
    throw new Error("Invalid role");
  }
  const target = await BoardMember.findOne({
    where: { boardId: req.params.boardId, userId: req.params.userId },
  });
  if (!target) {
    res.status(404);
    throw new Error("Member not found");
  }
  if (target.role === "owner" || role === "owner") {
    if (req.boardMembership.role !== "owner") {
      res.status(403);
      throw new Error("Only the current owner can change owner status");
    }
  }
  await sequelize.transaction(async (t) => {
    if (role === "owner") {
      const board = await Board.findByPk(req.params.boardId, { transaction: t });
      board.ownerId = target.userId;
      await board.save({ transaction: t });
      req.boardMembership.role = "admin";
      await req.boardMembership.save({ transaction: t });
    }
    target.role = role;
    await target.save({ transaction: t });
  });
  res.json(target);
});

export const removeMember = asyncHandler(async (req, res) => {
  const target = await BoardMember.findOne({
    where: { boardId: req.params.boardId, userId: req.params.userId },
  });
  if (!target) {
    res.status(404);
    throw new Error("Member not found");
  }
  if (target.role === "owner") {
    res.status(400);
    throw new Error("Cannot remove the board owner");
  }
  await target.destroy();
  res.json({ message: "Member removed" });
});
