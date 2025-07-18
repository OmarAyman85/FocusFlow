// ** Routes: Authentication and Tasks **
// routes/authRoutes.js
import express from "express";
import {
  registerUser,
  loginUser,
  getUserProfile,
} from "../controllers/authController.js";
import { protect } from "../middleware/authMiddleware.js";
import { roleMiddleware } from "../middleware/roleMiddleware.js";
const router = express.Router();

router.post("/register", registerUser);
router.post("/login", loginUser);
router.get("/profile", protect, getUserProfile);

router.get(
  "/admin-dashboard",
  protect,
  roleMiddleware(["admin"]),
  (req, res) => {
    res.send("Welcome to the Admin Dashboard!");
  }
);

router.get(
  "/editor-dashboard",
  roleMiddleware(["admin", "editor"]),
  (req, res) => {
    res.send("Welcome to the Editor Dashboard!");
  }
);

router.get(
  "/user-profile",
  roleMiddleware(["user", "admin", "editor"]),
  (req, res) => {
    res.send("Welcome to your profile!");
  }
);

export default router;
