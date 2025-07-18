import registerUserSchema from "./RegisterationSchema";

const registerationValidate = (formData) => {
  const result = registerUserSchema.validate(formData, { abortEarly: false });
  // const validationErrors = {};
  const errors = {};

  if (result.error) {
    result.error.details.forEach((detail) => {
      if (!errors[detail.path[0]]) {
        errors[detail.path[0]] = [];
      }
      errors[detail.path[0]].push(detail.message);
    });
  }
  return errors;
};

export default registerationValidate;
