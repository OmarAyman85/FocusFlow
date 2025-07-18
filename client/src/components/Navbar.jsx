import React, { useState } from "react";
import { NavLink } from "react-router-dom";
import clsx from "clsx";

const NavBar = () => {
  const [searchTerm, setSearchTerm] = useState("");

  // Helper function for active link styling
  const getLinkClassName = (isActive) =>
    clsx("nav-link", { "text-success": isActive });

  // Handle search input change
  const handleSearchChange = (e) => {
    setSearchTerm(e.target.value);
  };

  // Handle search form submission
  const handleSearchSubmit = (e) => {
    e.preventDefault();
    // You can add search functionality here
    console.log("Search submitted:", searchTerm);
    setSearchTerm(""); // Clear search field after submit
  };

  return (
    <nav className="navbar navbar-expand-lg bg-dark navbar-dark">
      <div className="container-fluid">
        <NavLink className="navbar-brand" to="/" style={{ color: "green" }}>
          FocusFlow
        </NavLink>
        <button
          className="navbar-toggler"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#navbarSupportedContent"
          aria-controls="navbarSupportedContent"
          aria-expanded="false"
          aria-label="Toggle navigation"
        >
          <span className="navbar-toggler-icon"></span>
        </button>
        <div className="collapse navbar-collapse" id="navbarSupportedContent">
          <ul className="navbar-nav me-auto mb-2 mb-lg-0">
            <li className="nav-item">
              <NavLink
                className={({ isActive }) => getLinkClassName(isActive)}
                aria-current="page"
                to="/tasks"
              >
                Dashboard
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink
                className={({ isActive }) => getLinkClassName(isActive)}
                to="/Login"
              >
                Login
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink
                className={({ isActive }) => getLinkClassName(isActive)}
                to="/Register"
              >
                Register
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink
                className={({ isActive }) => getLinkClassName(isActive)}
                to="/Profile"
              >
                Profile
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink
                className={({ isActive }) => getLinkClassName(isActive)}
                to="/Admin"
              >
                Admin
              </NavLink>
            </li>
            <li className="nav-item">
              <NavLink
                className={({ isActive }) =>
                  getLinkClassName(isActive) + " disabled"
                }
                aria-disabled="true"
                to="#"
              >
                User
              </NavLink>
            </li>
          </ul>
          <form className="d-flex" role="search" onSubmit={handleSearchSubmit}>
            <input
              className="form-control me-2"
              type="search"
              placeholder="Search"
              aria-label="Search"
              value={searchTerm}
              onChange={handleSearchChange}
            />
            <button className="btn btn-outline-success" type="submit">
              Search
            </button>
          </form>
        </div>
      </div>
    </nav>
  );
};

export default NavBar;
