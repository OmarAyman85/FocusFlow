import { useState, useEffect } from "react";
import axios from "axios";

const useAdmin = (url) => {
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");

  // Helper function to get user info from localStorage
  const getUserInfo = () => JSON.parse(localStorage.getItem("userInfo")) || {};

  // Set Axios config with Authorization header
  const getConfig = () => {
    const { token } = getUserInfo();
    return token
      ? { headers: { Authorization: `Bearer ${token}` } }
      : { headers: { "Content-Type": "application/json" } };
  };

  useEffect(() => {
    const fetchAdminMessage = async () => {
      try {
        const { data } = await axios.get(url, getConfig());
        setMessage(data);
      } catch (err) {
        setError(err.response?.data?.message || "An error occurred");
      }
    };

    fetchAdminMessage();
  }, [url]);

  return { message, error };
};

export default useAdmin;
