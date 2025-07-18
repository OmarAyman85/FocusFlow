import NavBar from "../components/Navbar";
import { Outlet } from "react-router-dom";

function RootLayout() {
  return (
    <>
      <NavBar />
      <Outlet />
    </>
  );
}

export default RootLayout;
