import { Routes, Route } from "react-router-dom";
import HomePage from "./page/HomePage";
import AuthPage from "./page/AuthPage";
import ClientRegistrationPage from "./page/ClientRegistrationPage";
import ClientDashboard from "./page/ClientDashboard";
import EmployeeDashboard from "./page/EmployeeDashboard";
import CreateEmployeePage from "./page/CreateEmployeePage";
import BreakEvenReportPage from "./page/BreakEvenReportPage";
import ProtectedRoute from "./page/ProtectedRoute";

function App() {
  return (
    <Routes>
      <Route path="/" element={<HomePage />} />
      <Route path="/login" element={<AuthPage />} />
      <Route path="/register" element={<ClientRegistrationPage />} />

      <Route element={<ProtectedRoute />}>
        <Route path="/client-dashboard" element={<ClientDashboard />} />
        <Route path="/employee-dashboard" element={<EmployeeDashboard />} />
        <Route path="/admin/create-employee" element={<CreateEmployeePage />} />
        <Route path="/reports/break-even" element={<BreakEvenReportPage />} />
      </Route>
    </Routes>
  );
}

export default App;
