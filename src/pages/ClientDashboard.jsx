import { Link } from "react-router-dom";

const ClientDashboard = () => {
  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold">Client Dashboard</h1>
      <p>Welcome, client! Here you can view your profile, manage your orders, and see available reports.</p>
      <ul className="mt-4 space-y-2">
        <li>
          <Link to="/reports/client-orders" className="text-blue-500 underline">
            View Your Order History
          </Link>
        </li>
        <li>
          <Link to="/reports/order-composition" className="text-blue-500 underline">
            View Order Receipt (Composition)
          </Link>
        </li>
      </ul>
    </div>
  );
};

export default ClientDashboard;
