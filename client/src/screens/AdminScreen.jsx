import React from "react";
import useAdmin from "../hooks/useAdmin"; // Adjust the path as needed

const AdminScreen = () => {
  const { message, error } = useAdmin(
    "http://localhost:3001/api/auth/admin-dashboard"
  );

  return (
    <div>
      {error ? (
        <div className="alert alert-danger" role="alert">
          {error}
        </div>
      ) : (
        <div className="alert alert-success" role="alert">
          {message}
        </div>
      )}
    </div>
  );
};

export default AdminScreen;
