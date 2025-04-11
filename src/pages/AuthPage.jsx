import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

const AuthPage = () => {
  const [userType, setUserType] = useState("client");
  const [login, setLogin] = useState("");
  const [password, setPassword] = useState("");
  const [errorMessage, setErrorMessage] = useState("");
  const navigate = useNavigate();

  useEffect(() => {
    const token = localStorage.getItem("token");
    const storedUserType = localStorage.getItem("userType");

    if (token && storedUserType) {
      if (storedUserType === "client") {
        navigate("/client-dashboard");
      } else {
        navigate("/employee-dashboard");
      }
    }
  }, [navigate]);

  const loginHandler = async () => {
    try {
      const response = await fetch("http://localhost:5000/api/auth", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ userType, login, password }),
      });

      if (!response.ok) {
        const errorText = await response.text();
        setErrorMessage("Login error: " + errorText);
        return;
      }

      const data = await response.json();
      localStorage.setItem("token", data.token);
      localStorage.setItem("userType", userType);

      if (userType === "client") {
        navigate("/client-dashboard");
      } else {
        navigate("/employee-dashboard");
      }
    } catch (err) {
      setErrorMessage("Unexpected error: " + err.message);
    }
  };

  const registerHandler = () => {
    navigate("/register");
  };

  return (
    <div className="p-8">
      <h1 className="text-xl font-bold mb-4">Login</h1>
      {errorMessage && <div className="text-red-500 mb-4">{errorMessage}</div>}
      <div className="grid grid-cols-2 gap-4 w-1/2 bg-red-200 rounded-xl p-8 mx-auto">
        <label>User Type</label>
        <select value={userType} onChange={(e) => setUserType(e.target.value)} className="border p-1">
          <option value="client">Клиент</option>
          <option value="seller">Продавец</option>
          <option value="purchasing_manager">Менеджер по закупкам</option>
          <option value="accountant">Бухгалтер</option>
          <option value="administrator">Администратор</option>
        </select>

        <label>Login</label>
        <input type="text" value={login} onChange={(e) => setLogin(e.target.value)} className="border p-1" />

        <label>Password</label>
        <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} className="border p-1" />

        <button onClick={loginHandler} className="bg-white p-2 border rounded">Login</button>
        {userType === "client" && (
          <button onClick={registerHandler} className="bg-white p-2 border rounded">Register</button>
        )}
      </div>
    </div>
  );
};

export default AuthPage;
