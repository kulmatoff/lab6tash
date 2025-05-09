import { Navigate, Outlet, useLocation } from "react-router-dom";
import { getUserFromToken } from "../utils/token";

const roleToDashboardPath = {
  client: "/client-dashboard",
  seller: "/seller-dashboard",
  purchasing_manager: "/purchasing-dashboard",
  accountant: "/accountant-dashboard",
  administrator: "/admin-dashboard",
};

const ProtectedRoute = () => {
  const user = getUserFromToken();
  const location = useLocation();
  const currentPath = location.pathname;

  // Redirect unauthenticated users
  if (!user) {
    return <Navigate to="/login" replace />;
  }

  // Check if current path matches the role dashboard root
  const expectedRoleEntry = Object.entries(roleToDashboardPath).find(([, path]) =>
    currentPath.startsWith(path)
  );

  // Redirect to correct dashboard if user accesses a path that doesn't match their role
  if (expectedRoleEntry && user.userType !== expectedRoleEntry[0]) {
    const correctPath = roleToDashboardPath[user.userType] || "/login";
    return <Navigate to={correctPath} replace />;
  }

  // Render children routes
  return <Outlet />;
};

export default ProtectedRoute;
