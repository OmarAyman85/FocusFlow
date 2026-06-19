import asyncHandler from "express-async-handler";
import { BoardMember } from "../models/index.js";

export const requireBoardRole = (allowedRoles) =>
  asyncHandler(async (req, res, next) => {
    const membership = await BoardMember.findOne({
      where: { boardId: req.params.boardId, userId: req.user.id },
    });
    if (!membership || !allowedRoles.includes(membership.role)) {
      res.status(403);
      throw new Error("You do not have the required role on this board");
    }
    req.boardMembership = membership;
    next();
  });
