import { Link } from "react-router-dom";

const ClientDashboard = () => {
  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold">Client Dashboard</h1>
      <p>Добро пожаловать, клиент!</p>

      <div className="mt-6 space-y-4">
        <Link to="/reports/orders" className="text-blue-600 underline">📄 Мои заказы</Link>
        <Link to="/reports/client-debts" className="text-blue-600 underline">💰 Моя задолженность</Link>
        <Link to="/reports/promotions" className="text-blue-600 underline">🎉 Актуальные акции</Link>
        <Link to="/" onClick={() => { localStorage.clear(); window.location.reload(); }} className="text-red-500 underline">
          🔓 Выйти
        </Link>
      </div>
    </div>
  );
};

export default ClientDashboard;
