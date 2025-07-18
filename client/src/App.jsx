import React from "react";
import "./App.css";
import {
  createRoutesFromElements,
  createBrowserRouter,
  Route,
  RouterProvider,
} from "react-router-dom";
import HomeScreen from "./screens/HomeScreen";
import LoginScreen from "./screens/LoginScreen";
import RegisterScreen from "./screens/RegisterScreen";
import TaskScreen from "./screens/TaskScreen";
import ErrorScreen from "./screens/ErrorScreen";
import ProfileScreen from "./screens/ProfileScreen";
import AdminScreen from "./screens/AdminScreen";
import RootLayout from "./layouts/RootLayout";
import TaskEdit from "./components/Tasks/TaskEdit";

const router = createBrowserRouter(
  createRoutesFromElements(
    <Route path="/" element={<RootLayout />}>
      <Route index element={<HomeScreen />} />
      <Route path="/login" element={<LoginScreen />} />
      <Route path="/register" element={<RegisterScreen />} />
      <Route path="/profile" element={<ProfileScreen />} />
      <Route path="/admin" element={<AdminScreen />} />
      <Route path="/tasks" element={<TaskScreen />} />
      <Route path="/tasks/:taskId" element={<TaskEdit />} />
      <Route path="*" element={<ErrorScreen />} />
    </Route>
  )
);

function App() {
  return <RouterProvider router={router} />;
}

export default App;
