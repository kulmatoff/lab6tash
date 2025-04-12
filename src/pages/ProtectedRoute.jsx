import { Navigate, Outlet, useLocation } from "react-router-dom";
import { getUserFromToken } from "../utils/token";

const roleToPath = {
  client: "/client-dashboard",
  seller: "/seller-dashboard",
  purchasing_manager: "/purchasing-dashboard",
  accountant: "/accountant-dashboard",
  administrator: "/admin-dashboard"
};

const pathToRole = Object.fromEntries(
  Object.entries(roleToPath).map(([role, path]) => [path, role])
);

const ProtectedRoute = () => {
  const user = getUserFromToken();
  const location = useLocation();
  const currentPath = location.pathname;

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  const expectedRole = Object.entries(roleToPath).find(([, path]) =>
    currentPath.startsWith(path)
  );

  if (expectedRole && user.userType !== expectedRole[0]) {
    return <Navigate to={roleToPath[user.userType]} replace />;
  }

  return <Outlet />;
};

export default ProtectedRoute;
