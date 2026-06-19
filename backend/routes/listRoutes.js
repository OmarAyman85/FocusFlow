import express from "express";
import {
  createList,
  updateList,
  deleteList,
  reorderLists,
} from "../controllers/listController.js";
import { createCard } from "../controllers/cardController.js";

const router = express.Router({ mergeParams: true });

router.post("/", createList);
router.patch("/reorder", reorderLists);
router.put("/:listId", updateList);
router.delete("/:listId", deleteList);
router.post("/:listId/cards", createCard);

export default router;
