import { Link } from "react-router-dom";

const EmployeeDashboard = () => {
  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold">Employee Dashboard</h1>
      <p>Вы вошли как сотрудник или администратор.</p>

      <div className="mt-6 space-y-4">
        <Link to="/admin/create-employee" className="text-blue-600 underline">👤 Добавить сотрудника</Link>
        <Link to="/reports/break-even" className="text-blue-600 underline">⚖️ Точка безубыточности</Link>
        <Link to="/reports/supply-debt" className="text-blue-600 underline">📦 Задолженности поставщиков</Link>
        <Link to="/reports/profit-loss" className="text-blue-600 underline">📊 Прибыль и убытки</Link>
        <Link to="/" onClick={() => { localStorage.clear(); window.location.reload(); }} className="text-red-500 underline">
          🔓 Выйти
        </Link>
      </div>
    </div>
  );
};

export default EmployeeDashboard;
