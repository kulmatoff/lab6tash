import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

const AuthPage = () => {
  const [userType, setUserType] = useState("client");
  const [login, setLogin] = useState("");
  const [password, setPassword] = useState("");
  const [errorMessage, setErrorMessage] = useState("");
  const navigate = useNavigate();

  const loginHandler = async () => {
    try {
      const response = await fetch("http://localhost:5000/api/auth", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ userType, login, password }),
      });

      if (!response.ok) {
        const errorText = await response.text();
        console.error("Login error:", errorText);
        setErrorMessage("Login error: " + errorText);
        return;
      }

      const data = await response.json();
      console.log("Login response:", data);
      localStorage.setItem("token", data.token);
      localStorage.setItem("userType", data.user.userType);
      if (data.user.userType === "client") {
        navigate("/client-dashboard");
      } else if (data.user.userType === "administrator") {
        navigate("/admin-dashboard");
      } else {
        navigate("/employee-dashboard");
      }
    } catch (err) {
      console.error("Unexpected error during login:", err);
      setErrorMessage("Unexpected error: " + err.message);
    }
  };

  useEffect(() => {
    const storedToken = localStorage.getItem("token");
    const storedUserType = localStorage.getItem("userType");
    if (storedToken && storedUserType) {
      if (storedUserType === "client") {
        navigate("/client-dashboard");
      } else if (storedUserType === "administrator") {
        navigate("/admin-dashboard");
      } else {
        navigate("/employee-dashboard");
      }
    }
  }, [navigate]);

  const registerHandler = () => {
    navigate("/register");
  };

  return (
    <div className="p-8">
      <h1 className="text-xl font-bold mb-4">Login</h1>
      {errorMessage && <div className="mb-4 text-red-500">{errorMessage}</div>}
      <div className="grid grid-cols-2 gap-4 w-1/2 bg-red-200 rounded-xl p-8 mx-auto">
        <label htmlFor="user_type">User Type</label>
        <select
          name="user_type"
          id="user_type"
          value={userType}
          onChange={(e) => setUserType(e.target.value)}
          className="border p-1"
        >
          <option value="client">Клиент</option>
          <option value="seller">Продавец</option>
          <option value="purchasing_manager">Менеджер по закупкам</option>
          <option value="accountant">Бухгалтер</option>
          <option value="administrator">Администратор</option>
        </select>
        <label htmlFor="login">Login</label>
        <input
          type="text"
          name="login"
          id="login"
          value={login}
          onChange={(e) => setLogin(e.target.value)}
          className="border p-1"
        />
        <label htmlFor="password">Password</label>
        <input
          type="password"
          name="password"
          id="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          className="border p-1"
        />
        <button className="border rounded-md bg-white p-2" onClick={loginHandler}>
          Login
        </button>
        {userType === "client" && (
          <button className="border rounded-md bg-white p-2" onClick={registerHandler}>
            Register
          </button>
        )}
      </div>
    </div>
  );
};

export default AuthPage;
