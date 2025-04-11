import { useNavigate } from "react-router-dom";

const HomePage = () => {
  const navigate = useNavigate();

  const clearStorage = () => {
    localStorage.clear();
    alert("Local storage cleared");
    navigate("/login");
  };

  return (
    <div className="p-8">
      <h1 className="text-3xl font-bold">Добро пожаловать 👋</h1>
      <p className="mt-2">Выберите действие:</p>
      <button onClick={() => navigate("/login")} className="mt-4 bg-blue-500 text-white p-2 rounded">
        🔐 Войти
      </button>
      <button onClick={clearStorage} className="mt-4 ml-4 bg-red-500 text-white p-2 rounded">
        🗑️ Очистить localStorage
      </button>
    </div>
  );
};

export default HomePage;
