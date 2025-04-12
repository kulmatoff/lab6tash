import { useNavigate } from "react-router-dom";
import { getUserFromToken } from "../utils/token";

const Header = () => {
  const navigate = useNavigate();
  const user = getUserFromToken();

  const logout = () => {
    localStorage.clear();
    navigate("/login");
  };

  return (
    <div className="flex justify-between items-center mb-6">
      <div className="text-lg font-semibold">
        👋 Привет, {user?.login || "Пользователь"}
      </div>
      <button
        onClick={logout}
        className="bg-red-500 text-white px-4 py-1 rounded"
      >
        Выйти
      </button>
    </div>
  );
};

export default Header;
