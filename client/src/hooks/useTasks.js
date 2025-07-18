import { useState, useEffect, useCallback } from "react";
import { useNavigate, useParams } from "react-router-dom";
import {
  fetchTasks,
  fetchTask,
  createTask,
  updateTask,
  deleteTask,
} from "../utils/Tasks/taskApi";
import { validateTask } from "../utils/Tasks/taskValidation";

const useTasks = () => {
  const [tasks, setTasks] = useState([]);
  const [taskFormData, setTaskFormData] = useState({
    title: "",
    category: "",
    description: "",
    status: "",
    priority: "",
    dueDate: "",
  });
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");

  const { taskId } = useParams();
  const navigate = useNavigate();

  // Track form input changes
  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setTaskFormData((prevData) => ({ ...prevData, [name]: value }));
  };

  useEffect(() => {
    if (taskId) {
      fetchTask(
        taskId,
        (taskData) => {
          if (taskData) {
            setTaskFormData(taskData);
          } else {
            setTaskFormData({
              title: "",
              category: "",
              description: "",
              status: "",
              priority: "",
              dueDate: "",
            });
          }
        },
        setLoading,
        setErrorMessage
      );
    } else {
      fetchTasks(
        (fetchedTasks) => {
          if (fetchedTasks) {
            setTasks(fetchedTasks);
          } else {
            setTasks([]);
          }
        },
        setLoading,
        setErrorMessage
      );
    }
  }, [taskId]);

  return {
    tasks,
    errors,
    taskFormData,
    handleInputChange,
    loading,
    errorMessage,
    createTask: async (e) => {
      await createTask(
        e,
        taskFormData,
        setErrors,
        setLoading,
        fetchTasks,
        setTaskFormData,
        setErrorMessage
      );
    },
    updateTask: async (e) => {
      await updateTask(
        e,
        taskId,
        taskFormData,
        setErrors,
        setLoading,
        navigate,
        setErrorMessage
      );
    },
    deleteTask: (taskId) =>
      deleteTask(taskId, setTasks, setLoading, setErrorMessage),
    taskId, // Ensure taskId is returned
  };
};

export default useTasks;
