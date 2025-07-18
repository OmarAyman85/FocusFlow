import React, { useState, useEffect, useCallback } from "react";
import { useParams } from "react-router-dom";
import useTasks from "../../hooks/useTasks";
import { statusEnum, priorityEnum } from "../../utils/Tasks/taskConstants";
import Loader from "react-js-loader";

const TaskEdit = () => {
  const { errors, taskId, taskFormData, handleInputChange, updateTask } =
    useTasks();
  const [task, setTask] = useState({
    title: "",
    category: "",
    description: "",
    status: "",
    priority: "",
    dueDate: "",
  });
  const [errorMessage, setErrorMessage] = useState("");
  const [color, setColor] = useState("#008000");

  useEffect(() => {
    if (taskFormData && taskId) {
      setTask(taskFormData);
    }
  }, [taskFormData, taskId]);

  // Handler for form input changes
  const handleChange = useCallback(
    (e) => {
      const { name, value } = e.target;
      setTask((prevTask) => ({
        ...prevTask,
        [name]: value,
      }));
      handleInputChange(e);
    },
    [setTask, handleInputChange]
  );

  // Render input fields
  const renderInputField = (
    type,
    label,
    name,
    value,
    error,
    additionalProps = {}
  ) => (
    <div className="mb-3">
      <label htmlFor={name} className="form-label">
        {label}:
      </label>
      <input
        type={type}
        name={name}
        value={value || ""}
        onChange={handleChange}
        className="form-control"
        id={name}
        {...additionalProps}
      />
      {error && <div className="text-danger">{error}</div>}
    </div>
  );

  // Render radio button options
  const renderRadioButtons = (label, name, options, selectedValue, error) => (
    <div className="mb-3">
      <label htmlFor={name} className="form-label">
        {label}:
      </label>
      {options.map((option) => (
        <div className="form-check form-check-inline" key={option}>
          <input
            type="radio"
            id={option}
            name={name}
            value={option}
            checked={selectedValue === option}
            onChange={handleChange}
            className="form-check-input"
          />
          <label htmlFor={option} className="form-check-label">
            {option.charAt(0).toUpperCase() + option.slice(1)}
          </label>
        </div>
      ))}
      {error && <div className="text-danger">{error[0]}</div>}
    </div>
  );
  return (
    <div className="container">
      <div className="row justify-content-md-center">
        <div className="col-8">
          {task ? (
            <form onSubmit={(e) => updateTask(e)} noValidate>
              {/* Title */}
              {renderInputField(
                "text",
                "Title",
                "title",
                task.title,
                errors.title
              )}

              {/* Category */}
              {renderInputField(
                "text",
                "Category",
                "category",
                task.category,
                errors.category
              )}

              {/* Description */}
              <div className="mb-3">
                <label htmlFor="description" className="form-label">
                  Description:
                </label>
                <textarea
                  name="description"
                  value={task.description || ""}
                  onChange={handleChange}
                  className="form-control"
                  id="description"
                />
                {errors.description && (
                  <div className="text-danger">{errors.description}</div>
                )}
              </div>

              {/* Priority */}
              {renderRadioButtons(
                "Priority",
                "priority",
                priorityEnum,
                task.priority,
                errors.priority
              )}

              {/* Status */}
              {renderRadioButtons(
                "Status",
                "status",
                statusEnum,
                task.status,
                errors.status
              )}

              {/* Due Date */}
              {renderInputField(
                "datetime-local",
                "Due Date",
                "dueDate",
                task.dueDate,
                errors.dueDate
              )}

              <button type="submit" className="btn btn-success">
                Update
              </button>
              {errorMessage && (
                <div className="text-danger mt-3">{errorMessage}</div>
              )}
            </form>
          ) : (
            <div className="mt-5">
              <Loader
                type="bubble-scale"
                bgColor={color}
                color={color}
                size={150}
              />
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default TaskEdit;
