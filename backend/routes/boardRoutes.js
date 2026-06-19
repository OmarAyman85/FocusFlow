import express from "express";
import {
  getMyBoards,
  getSharedBoards,
  getPublicBoards,
  createBoard,
  getBoard,
  updateBoard,
  setVisibility,
  deleteBoard,
  joinBoard,
  leaveBoard,
  getMembers,
  inviteMember,
  updateMemberRole,
  removeMember,
} from "../controllers/boardController.js";
import { protect, optionalAuth } from "../middleware/authMiddleware.js";
import { requireBoardRole } from "../middleware/boardAuthMiddleware.js";
import listRoutes from "./listRoutes.js";
import cardRoutes from "./cardRoutes.js";

const router = express.Router();

// Specific string routes must come before the generic "/:boardId" route.
router.get("/mine", protect, getMyBoards);
router.get("/shared", protect, getSharedBoards);
router.get("/public", getPublicBoards);

router.post("/", protect, createBoard);
router.get("/:boardId", optionalAuth, getBoard);
router.put("/:boardId", protect, requireBoardRole(["owner", "admin"]), updateBoard);
router.patch(
  "/:boardId/visibility",
  protect,
  requireBoardRole(["owner"]),
  setVisibility
);
router.delete("/:boardId", protect, requireBoardRole(["owner"]), deleteBoard);

router.post("/:boardId/join", protect, joinBoard);
router.post("/:boardId/leave", protect, leaveBoard);

router.get(
  "/:boardId/members",
  protect,
  requireBoardRole(["owner", "admin", "member", "viewer"]),
  getMembers
);
router.post(
  "/:boardId/members",
  protect,
  requireBoardRole(["owner", "admin"]),
  inviteMember
);
router.patch(
  "/:boardId/members/:userId",
  protect,
  requireBoardRole(["owner", "admin"]),
  updateMemberRole
);
router.delete(
  "/:boardId/members/:userId",
  protect,
  requireBoardRole(["owner", "admin"]),
  removeMember
);

router.use(
  "/:boardId/lists",
  protect,
  requireBoardRole(["owner", "admin", "member"]),
  listRoutes
);
router.use(
  "/:boardId/cards",
  protect,
  requireBoardRole(["owner", "admin", "member"]),
  cardRoutes
);

export default router;
