import React from "react";
import useLogin from "../hooks/useLogin";

const LoginForm = () => {
  const {
    email,
    setEmail,
    password,
    setPassword,
    rememberMe,
    setRememberMe,
    errors,
    handleSubmit,
  } = useLogin();

  // Common change handler for text inputs
  const handleInputChange = (setter) => (e) => setter(e.target.value);

  // Handle checkbox state change
  const handleCheckboxChange = (e) => setRememberMe(e.target.checked);

  return (
    <div className="container">
      <form onSubmit={handleSubmit} noValidate>
        {/* Email Field */}
        <div className="mb-3 mt-5">
          <label htmlFor="email" className="form-label">
            Email Address
          </label>
          <input
            type="email"
            id="email"
            name="email"
            value={email}
            onChange={handleInputChange(setEmail)}
            className="form-control"
            aria-describedby="emailHelp"
            required
          />
          {errors.email && <div className="text-danger">{errors.email[0]}</div>}
        </div>

        {/* Password Field */}
        <div className="mb-3">
          <label htmlFor="password" className="form-label">
            Password
          </label>
          <input
            type="password"
            id="password"
            name="password"
            value={password}
            onChange={handleInputChange(setPassword)}
            className="form-control"
            required
          />
          {errors.password && (
            <div className="text-danger">{errors.password[0]}</div>
          )}
        </div>

        {/* Remember Me Checkbox */}
        <div className="mb-3 form-check">
          <input
            type="checkbox"
            className="form-check-input"
            id="rememberMe"
            checked={rememberMe}
            onChange={handleCheckboxChange}
            aria-label="Remember me"
          />
          <label className="form-check-label" htmlFor="rememberMe">
            Remember me
          </label>
        </div>

        {/* Submit Button */}
        <button type="submit" className="btn btn-primary w-100">
          Log In
        </button>
      </form>
    </div>
  );
};

export default LoginForm;
