import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import HomePage from "./pages/HomePage";
import AuthPage from "./pages/AuthPage";
import ClientRegistrationPage from "./pages/ClientRegistrationPage";
import ClientDashboard from "./pages/ClientDashboard";
import EmployeeDashboard from "./pages/EmployeeDashboard";
import AdminDashboard from "./pages/AdminDashboard";
import CreateEmployeePage from "./pages/CreateEmployeePage";
import BreakEvenReportPage from "./pages/BreakEvenReportPage";
import DeliveriesBySupplierReportPage from "./pages/DeliveriesBySupplierReportPage";
import ProtectedRoute from "./pages/ProtectedRoute";

function App() {
  return (
    <Routes>
      <Route path="/" element={<HomePage />} />
      
      <Route path="/login" element={<AuthPage />} />
      <Route path="/register" element={<ClientRegistrationPage />} />

      <Route element={<ProtectedRoute />}>
        <Route path="/client-dashboard" element={<ClientDashboard />} />
        <Route path="/employee-dashboard" element={<EmployeeDashboard />} />
        <Route path="/admin-dashboard" element={<AdminDashboard />} />
        <Route path="/admin/create-employee" element={<CreateEmployeePage />} />
        <Route path="/reports/break-even" element={<BreakEvenReportPage />} />
        <Route path="/reports/deliveries-by-supplier" element={<DeliveriesBySupplierReportPage />} />
      </Route>
    </Routes>
  );
}

export default App;
