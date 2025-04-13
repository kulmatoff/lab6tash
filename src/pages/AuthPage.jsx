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
      redirectByUserType(storedUserType);
    }
  }, [navigate]);

  const redirectByUserType = (type) => {
    switch (type) {
      case "client":
        navigate("/client-dashboard");
        break;
      case "seller":
        navigate("/seller-dashboard");
        break;
      case "purchasing_manager":
        navigate("/purchasing-dashboard");
        break;
      case "accountant":
        navigate("/accountant-dashboard");
        break;
      case "administrator":
        navigate("/admin-dashboard");
        break;
      default:
        navigate("/");
    }
  };

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

      redirectByUserType(userType);
    } catch (err) {
      setErrorMessage("Unexpected error: " + err.message);
    }
  };

  const registerHandler = () => {
    navigate("/register");
  };

  return (
    <div className="p-12 bg-[#fdfbf7] min-h-screen">
      <h1 className="text-3xl font-bold text-center text-[#1b1b1b] mb-8">Welcome to Silentium</h1>
      <div className="bg-white shadow-lg border border-[#c2b8a3] rounded-2xl p-10 max-w-xl mx-auto space-y-6">
        {errorMessage && <div className="text-red-600">{errorMessage}</div>}
  
        <div className="space-y-2">
          <label className="block font-semibold text-[#2c2c2c]">User Type</label>
          <select value={userType} onChange={(e) => setUserType(e.target.value)} className="w-full">
            <option value="client">Client</option>
            <option value="seller">Seller</option>
            <option value="purchasing_manager">Purchasing Manager</option>
            <option value="accountant">Accountant</option>
            <option value="administrator">Administrator</option>
          </select>
        </div>
  
        <div className="space-y-2">
          <label className="block font-semibold text-[#2c2c2c]">Login</label>
          <input type="text" value={login} onChange={(e) => setLogin(e.target.value)} className="w-full" />
        </div>
  
        <div className="space-y-2">
          <label className="block font-semibold text-[#2c2c2c]">Password</label>
          <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} className="w-full" />
        </div>
  
        <div className="flex flex-col space-y-3">
          <button onClick={loginHandler}>Login</button>
          {userType === "client" && <button onClick={registerHandler}>Register</button>}
        </div>
      </div>
    </div>
  );  
};

export default AuthPage;
