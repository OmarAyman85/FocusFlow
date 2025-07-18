import Joi from "joi-browser";

const taskValidationSchema = Joi.object({
  title: Joi.string().required().max(50).label("Title"),
  category: Joi.string().allow("").label("Category"),
  description: Joi.string().allow("").label("Description"),
  status: Joi.string()
    .valid("pending", "in-progress", "completed")
    .label("Status"),
  priority: Joi.string().valid("low", "medium", "high").label("Priority"),
  dueDate: Joi.date().optional().label("Due Date"),
});

export const validateTask = (taskFormData) => {
  const result = taskValidationSchema.validate(taskFormData, {
    abortEarly: false,
  });
  const validationErrors = {};
  if (result.error) {
    result.error.details.forEach((detail) => {
      const field = detail.path[0];
      if (!validationErrors[field]) {
        validationErrors[field] = [];
      }
      validationErrors[field].push(detail.message);
    });
  }
  return validationErrors;
};
