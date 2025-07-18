import React from "react";
import { Link } from "react-router-dom";

const HomeScreen = () => {
  return (
    <div className="home-screen">
      <h1>Welcome to Task Manager</h1>
      <Link to="/register">Get Started</Link>
    </div>
  );
};

export default HomeScreen;
