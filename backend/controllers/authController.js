import jwt from "jsonwebtoken";
import asyncHandler from "express-async-handler";
import { User } from "../models/index.js";

const generateToken = (user) =>
  jwt.sign({ id: user.id, role: user.role }, process.env.JWT_SECRET, {
    expiresIn: "7d",
  });

const toPublicUser = (user) => ({
  id: user.id,
  name: user.name,
  email: user.email,
  role: user.role,
  profileImage: user.profileImage,
});

export const registerUser = asyncHandler(async (req, res) => {
  const { name, email, password } = req.body;

  const userExists = await User.findOne({ where: { email } });
  if (userExists) {
    res.status(400);
    throw new Error("User already exists");
  }

  const user = await User.create({ name, email, password });
  res.status(201).json({ ...toPublicUser(user), token: generateToken(user) });
});

export const loginUser = asyncHandler(async (req, res) => {
  const { email, password } = req.body;
  const user = await User.scope("withPassword").findOne({ where: { email } });

  if (user && (await user.matchPassword(password))) {
    res.json({ ...toPublicUser(user), token: generateToken(user) });
  } else {
    res.status(401);
    throw new Error("Invalid email or password");
  }
});

export const getUserProfile = asyncHandler(async (req, res) => {
  res.json(toPublicUser(req.user));
});

export const updateUserProfile = asyncHandler(async (req, res) => {
  const { name, profileImage, password } = req.body;
  if (name !== undefined) req.user.name = name;
  if (profileImage !== undefined) req.user.profileImage = profileImage;
  if (password) req.user.password = password;
  await req.user.save();
  res.json(toPublicUser(req.user));
});
