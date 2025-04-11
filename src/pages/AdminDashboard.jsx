import { Link } from "react-router-dom";

const AdminDashboard = () => {
  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold">Administrator Dashboard</h1>
      <p>Welcome, admin! You have full access.</p>
      <div className="mt-4">
        <Link to="/admin/create-employee" className="text-blue-500 underline">
          Create New Employee
        </Link>
      </div>
      <div className="mt-4">
        <Link to="/reports/profit-loss" className="text-blue-500 underline">
          View Profit & Loss Report
        </Link>
      </div>
    </div>
  );
};

export default AdminDashboard;
