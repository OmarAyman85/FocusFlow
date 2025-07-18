import React, { useState } from "react";
import useRegister from "../hooks/useRegister";
import registerationValidate from "../utils/Registeration/RegisterationValidate";

const RegisterForm = () => {
  const {
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
  } = useRegister();
  const [isSubmitted, setIsSubmitted] = useState(false);

  // Helper function to handle error display
  const renderError = (fieldName) => {
    return errors[fieldName] ? (
      <div className="text-danger">
        {/* Only display the first error message */}
        <p>{errors[fieldName][0]}</p>
      </div>
    ) : null;
  };

  // Handle form submission with client-side validation
  const handleFormSubmit = (e) => {
    e.preventDefault();
    const validationErrors = registerationValidate({
      name,
      email,
      password,
      phone,
      address,
      role,
      profileImage,
      dateOfBirth,
      socialAccounts,
    });

    if (Object.keys(validationErrors).length === 0) {
      handleSubmit(e);
      setIsSubmitted(true);
    } else {
      setIsSubmitted(false);
      setErrors(validationErrors); // Update state with the validation errors
    }
  };

  return (
    <>
      <form onSubmit={handleFormSubmit} noValidate>
        {/*-----------------------------------------------------------------*/}
        <div className="mb-3 mt-5">
          <label htmlFor="name" className="form-label">
            Name
          </label>
          <input
            name="name"
            value={name}
            onChange={(e) => setName(e.target.value)}
            type="text"
            className="form-control"
            id="name"
            aria-describedby="nameError"
          />
          {renderError("name")}
        </div>
        {/*-----------------------------------------------------------------*/}
        <div className="mb-3">
          <label htmlFor="email" className="form-label">
            Email address
          </label>
          <input
            name="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            type="email"
            className="form-control"
            id="email"
            aria-describedby="emailError"
          />
          {renderError("email")}
        </div>
        {/*-----------------------------------------------------------------*/}
        <div className="mb-3">
          <label htmlFor="password" className="form-label">
            Password
          </label>
          <input
            name="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            type="password"
            className="form-control"
            id="password"
            aria-describedby="passwordError"
          />
          {renderError("password")}
        </div>
        {/*-----------------------------------------------------------------*/}
        <div className="mb-3">
          <label htmlFor="phone" className="form-label">
            Phone
          </label>
          <input
            name="phone"
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
            type="tel"
            className="form-control"
            id="phone"
            aria-describedby="phoneError"
          />
          {renderError("phone")}
        </div>
        {/*-----------------------------------------------------------------*/}
        <div className="mb-3">
          <label htmlFor="street" className="form-label">
            Street
          </label>
          <input
            name="street"
            value={address.street}
            onChange={(e) =>
              setAddress((prevAddress) => ({
                ...prevAddress,
                street: e.target.value,
              }))
            }
            type="text"
            className="form-control"
            id="street"
            aria-describedby="streetError"
          />
          {renderError("address.street")}
        </div>

        <div className="mb-3">
          <label htmlFor="city" className="form-label">
            City
          </label>
          <input
            name="city"
            value={address.city}
            onChange={(e) =>
              setAddress((prevAddress) => ({
                ...prevAddress,
                city: e.target.value,
              }))
            }
            type="text"
            className="form-control"
            id="city"
            aria-describedby="cityError"
          />
          {renderError("address.city")}
        </div>

        <div className="mb-3">
          <label htmlFor="state" className="form-label">
            State
          </label>
          <input
            name="state"
            value={address.state}
            onChange={(e) =>
              setAddress((prevAddress) => ({
                ...prevAddress,
                state: e.target.value,
              }))
            }
            type="text"
            className="form-control"
            id="state"
            aria-describedby="stateError"
          />
          {renderError("address.state")}
        </div>

        <div className="mb-3">
          <label htmlFor="country" className="form-label">
            Country
          </label>
          <input
            name="country"
            value={address.country}
            onChange={(e) =>
              setAddress((prevAddress) => ({
                ...prevAddress,
                country: e.target.value,
              }))
            }
            type="text"
            className="form-control"
            id="country"
            aria-describedby="countryError"
          />
          {renderError("address.country")}
        </div>

        <div className="mb-3">
          <label htmlFor="postalCode" className="form-label">
            Postal Code
          </label>
          <input
            name="postalCode"
            value={address.postalCode}
            onChange={(e) =>
              setAddress((prevAddress) => ({
                ...prevAddress,
                postalCode: e.target.value,
              }))
            }
            type="text"
            className="form-control"
            id="postalCode"
            aria-describedby="postalCodeError"
          />
          {renderError("address.postalCode")}
        </div>

        {/*-----------------------------------------------------------------*/}
        <div className="mb-3">
          <label htmlFor="role" className="form-label">
            Role
          </label>
          <select
            name="role"
            value={role}
            onChange={(e) => setRole(e.target.value)}
            className="form-select"
            id="role"
            aria-describedby="roleError"
          >
            <option value="user">User</option>
            <option value="admin">Admin</option>
            <option value="moderator">Moderator</option>
          </select>
          {renderError("role")}
        </div>
        {/*-----------------------------------------------------------------*/}
        <div className="mb-3">
          <label htmlFor="profileImage" className="form-label">
            Profile Image (URL)
          </label>
          <input
            name="profileImage"
            value={profileImage}
            onChange={(e) => setProfileImage(e.target.value)}
            type="url"
            className="form-control"
            id="profileImage"
            aria-describedby="profileImageError"
          />
          {renderError("profileImage")}
        </div>
        {/*-----------------------------------------------------------------*/}
        <div className="mb-3">
          <label htmlFor="dateOfBirth" className="form-label">
            Date of Birth
          </label>
          <input
            name="dateOfBirth"
            value={dateOfBirth}
            onChange={(e) => setDateOfBirth(e.target.value)}
            type="date"
            className="form-control"
            id="dateOfBirth"
            aria-describedby="dateOfBirthError"
          />
          {renderError("dateOfBirth")}
        </div>
        {/*-----------------------------------------------------------------*/}
        <div className="mb-3">
          <label htmlFor="facebook" className="form-label">
            Facebook URL
          </label>
          <input
            name="facebook"
            value={socialAccounts.facebook}
            onChange={(e) =>
              setSocialAccounts((prevSocialAccounts) => ({
                ...prevSocialAccounts,
                facebook: e.target.value,
              }))
            }
            type="text"
            className="form-control"
            id="facebook"
            placeholder="e.g., http://facebook.com/yourprofile"
            aria-describedby="facebookError"
          />
          {renderError("socialAccounts.facebook")}
        </div>

        <div className="mb-3">
          <label htmlFor="twitter" className="form-label">
            Twitter URL
          </label>
          <input
            name="twitter"
            value={socialAccounts.twitter}
            onChange={(e) =>
              setSocialAccounts((prevSocialAccounts) => ({
                ...prevSocialAccounts,
                twitter: e.target.value,
              }))
            }
            type="text"
            className="form-control"
            id="twitter"
            placeholder="e.g., http://twitter.com/yourprofile"
            aria-describedby="twitterError"
          />
          {renderError("socialAccounts.twitter")}
        </div>

        <div className="mb-3">
          <label htmlFor="linkedin" className="form-label">
            LinkedIn URL
          </label>
          <input
            name="linkedin"
            value={socialAccounts.linkedin}
            onChange={(e) =>
              setSocialAccounts((prevSocialAccounts) => ({
                ...prevSocialAccounts,
                linkedin: e.target.value,
              }))
            }
            type="text"
            className="form-control"
            id="linkedin"
            placeholder="e.g., http://linkedin.com/in/yourprofile"
            aria-describedby="linkedinError"
          />
          {renderError("socialAccounts.linkedin")}
        </div>

        <div className="mb-3">
          <label htmlFor="instagram" className="form-label">
            Instagram URL
          </label>
          <input
            name="instagram"
            value={socialAccounts.instagram}
            onChange={(e) =>
              setSocialAccounts((prevSocialAccounts) => ({
                ...prevSocialAccounts,
                instagram: e.target.value,
              }))
            }
            type="text"
            className="form-control"
            id="instagram"
            placeholder="e.g., http://instagram.com/yourprofile"
            aria-describedby="instagramError"
          />
          {renderError("socialAccounts.instagram")}
        </div>

        {/*-----------------------------------------------------------------*/}

        <button type="submit" className="btn btn-success">
          Register
        </button>

        {isSubmitted && (
          <div className="mt-3 text-success">
            <strong>Registration successful!</strong>
          </div>
        )}
      </form>
    </>
  );
};

export default RegisterForm;
