import express from "express";
import {
  updateCard,
  deleteCard,
  assignCard,
  moveCard,
} from "../controllers/cardController.js";

const router = express.Router({ mergeParams: true });

router.patch("/move", moveCard);
router.put("/:cardId", updateCard);
router.delete("/:cardId", deleteCard);
router.patch("/:cardId/assign", assignCard);

export default router;
