import React from "react";
import { FaTrashAlt } from "react-icons/fa";
import { NavLink } from "react-router-dom";
import PropTypes from "prop-types";

const TaskCard = ({ task, onDelete }) => {
  const { _id, title, category, description, priority, status, dueDate } = task;

  return (
    <div className="col-3" key={_id}>
      <div className="card text-start mb-3">
        <div className="card-body">
          <h3 className="card-title">{title}</h3>
          <h5 className="card-title">{category}</h5>
          <p className="card-text">{description}</p>
          <p className="card-text">Priority: {priority}</p>
          <p className="card-text">Status: {status}</p>
          <p className="card-text">
            Due Date:{" "}
            {dueDate ? new Date(dueDate).toLocaleDateString() : "No Due Date"}
          </p>
          <NavLink to={`/tasks/${_id}`} className="btn btn-primary">
            Modify
          </NavLink>
          <button
            onClick={() => onDelete(_id)}
            className="delete-btn"
            aria-label="Delete Task"
          >
            <FaTrashAlt />
          </button>
        </div>
      </div>
    </div>
  );
};

TaskCard.propTypes = {
  task: PropTypes.shape({
    id: PropTypes.string.isRequired,
    title: PropTypes.string.isRequired,
    category: PropTypes.string.isRequired,
    description: PropTypes.string.isRequired,
    priority: PropTypes.string.isRequired,
    status: PropTypes.string.isRequired,
    dueDate: PropTypes.string,
  }).isRequired,
  onDelete: PropTypes.func.isRequired,
};

export default TaskCard;
