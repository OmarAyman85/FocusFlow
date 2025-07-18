import { useState } from "react";
import axios from "axios";
import Joi from "joi-browser";
import { useNavigate } from "react-router-dom";

const useLogin = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  // Joi schema for validation
  const schema = Joi.object({
    email: Joi.string().required().email().label("Email"),
    password: Joi.string().required().label("Password"),
  });

  // Async validation for form data
  const validate = () => {
    const { error } = schema.validate(
      { email, password },
      { abortEarly: false }
    );
    if (error) {
      const validationErrors = error.details.reduce((acc, curr) => {
        if (!acc[curr.path[0]]) {
          acc[curr.path[0]] = [];
        }
        acc[curr.path[0]].push(curr.message);
        return acc;
      }, {});
      return validationErrors;
    }
    return {};
  };

  // Handle form submission
  const handleSubmit = async (e) => {
    e.preventDefault();
    const validationErrors = validate();
    if (Object.keys(validationErrors).length > 0) {
      setErrors(validationErrors);
      return;
    }

    setLoading(true); // Show loading state

    try {
      const { data } = await axios.post(
        "http://localhost:3001/api/auth/login", // Replace with actual URL
        { email, password }
      );
      localStorage.setItem("userInfo", JSON.stringify(data));
      navigate("/tasks");
    } catch (error) {
      setErrors({ server: ["Invalid credentials or server error"] });
      console.error("Login failed: ", error.response || error.message);
    } finally {
      setLoading(false); // Hide loading state
    }
  };

  return {
    email,
    setEmail,
    password,
    setPassword,
    errors,
    handleSubmit,
    loading,
  };
};

export default useLogin;
