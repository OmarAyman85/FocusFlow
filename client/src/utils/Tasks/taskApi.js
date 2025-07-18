import axios from "axios";
import { getConfig } from "./taskConstants";
import { validateTask } from "./taskValidation";

const API_BASE_URL = "http://localhost:3001/api/tasks";

export const fetchTasks = async (setTasks, setLoading, setErrorMessage) => {
  if (typeof setLoading === "function") setLoading(true);
  try {
    const { data } = await axios.get(API_BASE_URL, getConfig());
    setTasks(data);
  } catch (error) {
    if (typeof setErrorMessage === "function")
      setErrorMessage("Error fetching tasks.");
  } finally {
    if (typeof setLoading === "function") setLoading(false);
  }
};

export const fetchTask = async (
  taskId,
  setTaskFormData,
  setLoading,
  setErrorMessage
) => {
  if (typeof setLoading === "function") setLoading(false);
  try {
    const { data } = await axios.get(`${API_BASE_URL}/${taskId}`, getConfig());
    setTaskFormData({
      title: data.title,
      category: data.category,
      description: data.description,
      status: data.status,
      priority: data.priority,
      dueDate: data.dueDate,
    });
  } catch (error) {
    if (typeof setErrorMessage === "function")
      setErrorMessage("Error fetching task.");
  } finally {
    if (typeof setLoading === "function") setLoading(false);
  }
};

export const createTask = async (
  e,
  taskFormData,
  setErrors,
  setLoading,
  fetchTasks,
  setTaskFormData,
  setErrorMessage
) => {
  e.preventDefault();
  const validationErrors = validateTask(taskFormData);
  if (Object.keys(validationErrors).length > 0) {
    setErrors(validationErrors);
    return;
  }

  if (typeof setLoading === "function") {
    setLoading(true);
  }
  try {
    await axios.post(API_BASE_URL, taskFormData, getConfig());
    setTaskFormData({
      title: "",
      category: "",
      description: "",
      status: "",
      priority: "",
      dueDate: "",
    });
    if (typeof fetchTasks === "function") {
      await fetchTasks(); // Ensure tasks are fetched after creating a new task
    }
    setErrors({});
  } catch (error) {
    if (typeof setErrorMessage === "function")
      setErrorMessage("Error creating task.");
  } finally {
    if (typeof setLoading === "function") setLoading(false);
  }
};

export const updateTask = async (
  e,
  taskId,
  taskFormData,
  setErrors,
  setLoading,
  navigate
) => {
  e.preventDefault();
  const validationErrors = validateTask(taskFormData);
  if (Object.keys(validationErrors).length > 0) {
    setErrors(validationErrors);
    return;
  }

  if (typeof setLoading === "function") setLoading(true);
  try {
    await axios.put(`${API_BASE_URL}/${taskId}`, taskFormData, getConfig());
    navigate("/tasks");
  } catch (error) {
    if (typeof setErrors === "function")
      setErrors({ general: "Failed to update task. Please try again." });
  } finally {
    if (typeof setLoading === "function") setLoading(false);
  }
};

export const deleteTask = async (
  taskId,
  setTasks,
  setLoading,
  setErrorMessage
) => {
  if (typeof setLoading === "function") setLoading(true);
  try {
    await axios.delete(`${API_BASE_URL}/${taskId}`, getConfig());
    setTasks((tasks) => tasks.filter((task) => task._id !== taskId));
  } catch (error) {
    if (typeof setErrorMessage === "function")
      setErrorMessage("Error deleting task.");
  } finally {
    if (typeof setLoading === "function") setLoading(false);
  }
};
