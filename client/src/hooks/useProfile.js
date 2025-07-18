import { useState, useEffect } from "react";
import axios from "axios";

const useUserProfile = () => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Function to retrieve user data from API
  const getUserProfile = async (token) => {
    try {
      const config = {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
      };

      const response = await axios.get(
        "http://localhost:3001/api/auth/profile", // Replace with actual URL
        config
      );
      return response.data;
    } catch (err) {
      throw new Error(
        err.response?.data?.message || "Failed to fetch user data"
      );
    }
  };

  // Function to retrieve the token from localStorage
  const getTokenFromStorage = () => {
    const userInfo = JSON.parse(localStorage.getItem("userInfo"));
    if (!userInfo || !userInfo.token) {
      throw new Error("User is not authenticated.");
    }
    return userInfo.token;
  };

  useEffect(() => {
    const fetchUserProfile = async () => {
      setLoading(true);
      try {
        const token = getTokenFromStorage();
        const userData = await getUserProfile(token);
        setUser(userData);
      } catch (err) {
        setError(err.message || "Error fetching user profile.");
      } finally {
        setLoading(false);
      }
    };

    fetchUserProfile();
  }, []); // Only run once when the component mounts

  return { user, loading, error };
};

export default useUserProfile;
