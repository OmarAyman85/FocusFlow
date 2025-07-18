import jwt from "jsonwebtoken";
import User from "../models/User.js";
import asyncHandler from "express-async-handler";
import bcrypt from "bcryptjs";

const generateToken = (user) => {
  return jwt.sign(
    { id: user._id, role: user.role }, // Include role in the payload
    process.env.JWT_SECRET,
    { expiresIn: "1h" }
  );
};

export const registerUser = asyncHandler(async (req, res) => {
  const {
    name,
    email,
    password,
    phone,
    address = {},
    role = "user",
    profileImage = "default-profile.png",
    dateOfBirth,
    socialAccounts = {},
  } = req.body;
  const userExists = await User.findOne({ email });

  if (userExists) {
    res.status(400);
    throw new Error("User already exists");
  }

  const user = await User.create({
    name,
    email,
    password,
    phone,
    address,
    role,
    profileImage,
    dateOfBirth,
    socialAccounts,
  });

  if (user) {
    res.status(201).json({
      _id: user._id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      address: user.address,
      role: user.role,
      profileImage: user.profileImage,
      dateOfBirth: user.dateOfBirth,
      socialAccounts: user.socialAccounts,
      token: generateToken(user),
    });
  } else {
    res.status(400);

    throw new Error("Invalid user data");
  }
});

export const loginUser = asyncHandler(async (req, res) => {
  const { email, password } = req.body;
  const user = await User.findOne({ email });

  if (user && (await bcrypt.compare(password, user.password))) {
    res.json({
      _id: user._id,
      name: user.name,
      email: user.email,
      token: generateToken(user),
    });
  } else {
    res.status(401);
    throw new Error("Invalid email or password");
  }
});

export const getUserProfile = asyncHandler(async (req, res) => {
  const user = await User.findById(req.user.id);

  if (user) {
    res.json({
      _id: user._id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      address: user.address,
      role: user.role,
      profileImage: user.profileImage,
      dateOfBirth: user.dateOfBirth,
      socialAccounts: user.socialAccounts,
    });
  } else {
    res.status(404);
    throw new Error("User not found");
  }
});
