import { useState } from "react";
import { useNavigate } from "react-router-dom";

const CreateEmployeePage = () => {
  const [form, setForm] = useState({
    First_Name: "",
    Last_Name: "",
    Registration_Date: "",
    Phone: "",
    Login: "",
    Password: "",
    Position_ID: "",
  });
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");
  const navigate = useNavigate();

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const token = localStorage.getItem("token");
    try {
      const response = await fetch("http://localhost:5000/api/employees/register", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${token}`,
        },
        body: JSON.stringify({ ...form, Position_ID: Number(form.Position_ID) }),
      });

      if (!response.ok) {
        const errorText = await response.text();
        setError(errorText);
        return;
      }

      const data = await response.json();
      setSuccess("🌸 Сотрудник успешно создан!");
      setForm({
        First_Name: "",
        Last_Name: "",
        Registration_Date: "",
        Phone: "",
        Login: "",
        Password: "",
        Position_ID: "",
      });
      navigate("/admin-dashboard");
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-rose-100 via-pink-200 to-rose-100 flex items-center justify-center px-6 py-12 font-serif text-rose-900">
      <form
        onSubmit={handleSubmit}
        className="w-full max-w-3xl bg-white/60 backdrop-blur-lg p-10 rounded-3xl border border-rose-300 shadow-2xl space-y-6"
      >
        <h1 className="text-4xl font-extrabold text-center mb-6 tracking-wide drop-shadow-md">
          🌸 Создание нового сотрудника
        </h1>

        {error && (
          <div className="bg-rose-200/40 border border-rose-400 text-rose-800 px-4 py-3 rounded-lg shadow">
            {error}
          </div>
        )}
        {success && (
          <div className="bg-green-200/40 border border-green-400 text-green-800 px-4 py-3 rounded-lg shadow">
            {success}
          </div>
        )}

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
          <input
            type="text"
            name="First_Name"
            placeholder="First Name"
            value={form.First_Name}
            onChange={handleChange}
            className="p-3 rounded-xl bg-rose-50/70 border border-rose-300 placeholder:text-rose-400 text-rose-900 focus:outline-none focus:ring-2 focus:ring-pink-400"
          />
          <input
            type="text"
            name="Last_Name"
            placeholder="Last Name"
            value={form.Last_Name}
            onChange={handleChange}
            className="p-3 rounded-xl bg-rose-50/70 border border-rose-300 placeholder:text-rose-400 text-rose-900"
          />
          <input
            type="date"
            name="Registration_Date"
            value={form.Registration_Date}
            onChange={handleChange}
            className="p-3 rounded-xl bg-rose-50/70 border border-rose-300 text-rose-900"
          />
          <input
            type="text"
            name="Phone"
            placeholder="Phone"
            value={form.Phone}
            onChange={handleChange}
            className="p-3 rounded-xl bg-rose-50/70 border border-rose-300 placeholder:text-rose-400 text-rose-900"
          />
          <input
            type="text"
            name="Login"
            placeholder="Login"
            value={form.Login}
            onChange={handleChange}
            className="p-3 rounded-xl bg-rose-50/70 border border-rose-300 placeholder:text-rose-400 text-rose-900"
          />
          <input
            type="password"
            name="Password"
            placeholder="Password"
            value={form.Password}
            onChange={handleChange}
            className="p-3 rounded-xl bg-rose-50/70 border border-rose-300 placeholder:text-rose-400 text-rose-900"
          />
          <input
            type="number"
            name="Position_ID"
            placeholder="Position ID"
            value={form.Position_ID}
            onChange={handleChange}
            className="p-3 rounded-xl bg-rose-50/70 border border-rose-300 placeholder:text-rose-400 text-rose-900"
          />
        </div>

        <button
          type="submit"
          className="w-full py-3 mt-8 bg-gradient-to-r from-pink-400 to-rose-300 hover:from-pink-300 hover:to-rose-200 transition-all duration-300 rounded-full font-bold text-rose-900 shadow-lg"
        >
          🌸 Создать сотрудника
        </button>
      </form>
    </div>
  );
};

export default CreateEmployeePage;
