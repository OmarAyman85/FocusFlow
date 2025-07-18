// controllers/taskController.js
import asyncHandler from "express-async-handler";
import Task from "../models/Task.js";

export const createTask = asyncHandler(async (req, res) => {
  const { title, category, description, priority, status, dueDate } = req.body;
  const task = await Task.create({
    title,
    category,
    description,
    priority,
    status,
    dueDate,
    user: req.user.id,
  });
  res.status(201).json(task);
});

export const getTasks = asyncHandler(async (req, res) => {
  const tasks = await Task.find({ user: req.user.id });
  res.json(tasks);
});

export const updateTask = asyncHandler(async (req, res) => {
  const task = await Task.findById(req.params.id);

  if (task && task.user.toString() === req.user.id) {
    Object.assign(task, req.body);
    const updatedTask = await task.save();
    res.json(updatedTask);
  } else {
    res.status(404);
    throw new Error("Task not found");
  }
});

export const getTask = asyncHandler(async (req, res) => {
  const task = await Task.findById(req.params.id);
  if (task && task.user.toString() === req.user.id) {
    res.json(task);
  } else {
    res.status(404);
    throw new Error("Task not found");
  }
});

export const deleteTask = asyncHandler(async (req, res) => {
  const task = await Task.findById(req.params.id);

  if (task && task.user.toString() === req.user.id) {
    await task.deleteOne();
    res.json({ message: "Task removed" });
  } else {
    res.status(404);
    throw new Error("Task not found");
  }
});
