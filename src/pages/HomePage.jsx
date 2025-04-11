import { useNavigate } from "react-router-dom";

const HomePage = () => {
  const navigate = useNavigate();

  const clearLocalStorage = () => {
    localStorage.clear();
    alert("Local storage cleared!");
    navigate("/login");
  };

  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold">Welcome to the Home Page</h1>
      <p>This is the main landing page of the application.</p>
      <button
        onClick={clearLocalStorage}
        className="mt-4 bg-red-500 text-white p-2 rounded"
      >
        Clear Local Storage
      </button>
    </div>
  );
};

export default HomePage;
