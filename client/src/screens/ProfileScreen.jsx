import React, { useState, useEffect } from "react";
import PropTypes from "prop-types"; // Add PropTypes import
import useProfile from "../hooks/useProfile";
import Loader from "react-js-loader";
import ErrorScreen from "./ErrorScreen";

const ProfileScreen = () => {
  const { user, loading, error } = useProfile();
  const [editMode, setEditMode] = useState(false);
  const [color, setColor] = useState("#008000");
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    phone: "",
    address: {
      street: "",
      city: "",
      state: "",
      country: "",
      postalCode: "",
    },
    role: "",
    profileImage: "",
    dateOfBirth: "",
    socialAccounts: {
      facebook: "",
      instagram: "",
      twitter: "",
      linkedin: "",
    },
  });

  useEffect(() => {
    if (user) {
      setFormData(user); // Populate formData when user data is available
    }
  }, [user]);

  if (loading) {
    return (
      <div className="mt-5">
        <Loader type="bubble-scale" bgColor={color} color={color} size={150} />
      </div>
    );
  }

  if (error) {
    return <ErrorScreen />;
  }

  // Handle change in input fields
  const handleInputChange = (e) => {
    const { name, value } = e.target;
    if (name.startsWith("address")) {
      const addressKey = name.split(".")[1];
      setFormData((prevState) => ({
        ...prevState,
        address: {
          ...prevState.address,
          [addressKey]: value,
        },
      }));
    } else if (name.startsWith("socialAccounts")) {
      const socialKey = name.split(".")[1];
      setFormData((prevState) => ({
        ...prevState,
        socialAccounts: {
          ...prevState.socialAccounts,
          [socialKey]: value,
        },
      }));
    } else {
      setFormData((prevState) => ({
        ...prevState,
        [name]: value,
      }));
    }
  };

  // Handle form submission
  const handleSubmit = (e) => {
    e.preventDefault();
    // Add form submission logic here
    console.log("Updated User Data:", formData);
    setEditMode(false); // Disable edit mode after saving
  };

  return (
    <div className="container">
      <div className="row justify-content-md-center">
        <div className="col-8">
          <div className="mb-5 mt-5">
            <h1>{user?.name || "User"}'s Profile</h1>
            {/* Display profile image */}
            <div>
              <img
                src={formData.profileImage || "default-image.jpg"} // Add default profile image
                alt={`${user?.name || "User"}'s Profile`}
                style={{ width: "150px", height: "150px", borderRadius: "50%" }}
              />
            </div>
            {/* Display user information */}
            <div className="mt-3">
              <p>
                <strong>Email:</strong> {formData.email || "N/A"}
              </p>
              <p>
                <strong>Phone:</strong> {formData.phone || "N/A"}
              </p>
              <p>
                <strong>Role:</strong> {formData.role || "N/A"}
              </p>
              <p>
                <strong>Date of Birth:</strong> {formData.dateOfBirth || "N/A"}
              </p>
            </div>
            {/* Display address */}
            <div className="mt-3">
              <h5>Address</h5>
              <p>
                <strong>Street:</strong> {formData.address.street || "N/A"}
              </p>
              <p>
                <strong>City:</strong> {formData.address.city || "N/A"}
              </p>
              <p>
                <strong>State:</strong> {formData.address.state || "N/A"}
              </p>
              <p>
                <strong>Country:</strong> {formData.address.country || "N/A"}
              </p>
              <p>
                <strong>Postal Code:</strong>{" "}
                {formData.address.postalCode || "N/A"}
              </p>
            </div>
            {/* Display social accounts */}
            <div className="mt-3">
              <h5>Social Accounts</h5>
              {Object.entries(formData.socialAccounts).map(([key, value]) => (
                <p key={key}>
                  <strong>{key.charAt(0).toUpperCase() + key.slice(1)}:</strong>{" "}
                  <a
                    href={value || "#"}
                    target="_blank"
                    rel="noopener noreferrer"
                  >
                    {value || "N/A"}
                  </a>
                </p>
              ))}
            </div>

            <button
              className="btn btn-primary mt-3"
              onClick={() => setEditMode((prev) => !prev)}
            >
              {editMode ? "Cancel Edit" : "Edit Profile"}
            </button>
          </div>
        </div>
      </div>

      {/* If edit mode is active, show input fields for editing */}
      {editMode && (
        <div className="row justify-content-md-center">
          <div className="col-8">
            <form onSubmit={handleSubmit}>
              <div className="mb-3">
                <label htmlFor="name" className="form-label">
                  Name
                </label>
                <input
                  type="text"
                  className="form-control"
                  id="name"
                  name="name"
                  value={formData.name}
                  onChange={handleInputChange}
                />
              </div>

              {/* Additional fields */}
              {/* ... */}
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

ProfileScreen.propTypes = {
  user: PropTypes.object,
  loading: PropTypes.bool,
  error: PropTypes.string,
};

export default ProfileScreen;
