// hooks/useRegister.js
import { useState } from "react";
import axios from "axios";
import Joi from "joi-browser";
import { useNavigate } from "react-router-dom";
import registerationValidate from "../utils/Registeration/RegisterationValidate";

const useRegister = () => {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [phone, setPhone] = useState("");
  const [address, setAddress] = useState({
    street: "",
    city: "",
    state: "",
    country: "",
    postalCode: "",
  });
  const [role, setRole] = useState("user");
  const [profileImage, setProfileImage] = useState("default-profile.png");
  const [dateOfBirth, setDateOfBirth] = useState("");
  const [socialAccounts, setSocialAccounts] = useState({
    facebook: "",
    twitter: "",
    linkedin: "",
    instagram: "",
  });
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    const validationErrors = registerationValidate();
    if (Object.keys(validationErrors).length > 0) {
      setErrors(validationErrors);
      setLoading(false);
      return;
    }

    try {
      const { data } = await axios.post(
        "http://localhost:3001/api/auth/register", // Replace with actual API URL
        {
          name,
          email,
          password,
          phone,
          address,
          role,
          profileImage,
          dateOfBirth,
          socialAccounts,
        },
        { headers: { "Content-Type": "application/json" } }
      );

      localStorage.setItem("userInfo", JSON.stringify(data));
      navigate("/tasks");
    } catch (error) {
      if (error.response) {
        setErrors({
          general: error.response.data.message || "Registration failed.",
        });
      } else {
        setErrors({ general: "Server error. Please try again later." });
      }
    } finally {
      setLoading(false);
    }
  };

  return {
    name,
    setName,
    email,
    setEmail,
    password,
    setPassword,
    phone,
    setPhone,
    address,
    setAddress,
    role,
    setRole,
    profileImage,
    setProfileImage,
    dateOfBirth,
    setDateOfBirth,
    socialAccounts,
    setSocialAccounts,
    errors,
    setErrors,
    handleSubmit,
    loading,
  };
};

export default useRegister;
