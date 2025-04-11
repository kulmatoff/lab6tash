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
      setSuccess("Employee created successfully!");
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
    <div className="p-8 max-w-md mx-auto">
      <h1 className="text-2xl font-bold mb-4">Create New Employee</h1>
      {error && <div className="text-red-500 mb-4">{error}</div>}
      {success && <div className="text-green-500 mb-4">{success}</div>}
      <form onSubmit={handleSubmit}>
        <input type="text" name="First_Name" placeholder="First Name" value={form.First_Name} onChange={handleChange} className="border p-2 mb-2 w-full" />
        <input type="text" name="Last_Name" placeholder="Last Name" value={form.Last_Name} onChange={handleChange} className="border p-2 mb-2 w-full" />
        <input type="date" name="Registration_Date" placeholder="Registration Date" value={form.Registration_Date} onChange={handleChange} className="border p-2 mb-2 w-full" />
        <input type="text" name="Phone" placeholder="Phone" value={form.Phone} onChange={handleChange} className="border p-2 mb-2 w-full" />
        <input type="text" name="Login" placeholder="Login" value={form.Login} onChange={handleChange} className="border p-2 mb-2 w-full" />
        <input type="password" name="Password" placeholder="Password" value={form.Password} onChange={handleChange} className="border p-2 mb-2 w-full" />
        <input type="number" name="Position_ID" placeholder="Position ID" value={form.Position_ID} onChange={handleChange} className="border p-2 mb-2 w-full" />
        <button type="submit" className="bg-blue-500 text-white p-2 rounded w-full">Create Employee</button>
      </form>
    </div>
  );
};

export default CreateEmployeePage;
