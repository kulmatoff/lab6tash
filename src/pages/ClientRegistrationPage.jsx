import { useState } from "react";
import { useNavigate } from "react-router-dom";

const ClientRegistrationPage = () => {
  const [form, setForm] = useState({
    First_Name: "",
    Last_Name: "",
    Client_Type_ID: 1,
    Contacts_ID: 1,
    District_ID: 1,
    Discount: 0,
    Registration_Date: "",
    Workplace: "",
    Position: "",
    Passport_Number: "",
    Login: "",
    Password: ""
  });
  const [error, setError] = useState("");
  const navigate = useNavigate();
  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };
  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await fetch("http://localhost:5000/api/clients/register", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(form)
      });
      if (!response.ok) {
        const errText = await response.text();
        setError(errText);
        return;
      }
      navigate("/client-dashboard");
    } catch (err) {
      setError(err.message);
    }
  };
  return (
    <div className="p-8">
      <h1 className="text-xl font-bold mb-4">Client Registration</h1>
      {error && <div className="text-red-500 mb-4">{error}</div>}
      <form onSubmit={handleSubmit} className="max-w-md mx-auto">
        <input type="text" name="First_Name" placeholder="First Name" value={form.First_Name} onChange={handleChange} className="border p-2 mb-2 w-full" />
        <input type="text" name="Last_Name" placeholder="Last Name" value={form.Last_Name} onChange={handleChange} className="border p-2 mb-2 w-full" />
        <input type="text" name="Workplace" placeholder="Workplace" value={form.Workplace} onChange={handleChange} className="border p-2 mb-2 w-full" />
        <input type="text" name="Passport_Number" placeholder="Passport Number" value={form.Passport_Number} onChange={handleChange} className="border p-2 mb-2 w-full" />
        <input type="text" name="Login" placeholder="Login" value={form.Login} onChange={handleChange} className="border p-2 mb-2 w-full" />
        <input type="password" name="Password" placeholder="Password" value={form.Password} onChange={handleChange} className="border p-2 mb-2 w-full" />
        <input type="date" name="Registration_Date" placeholder="Registration Date" value={form.Registration_Date} onChange={handleChange} className="border p-2 mb-2 w-full" />
        <button type="submit" className="bg-blue-500 text-white p-2 rounded mt-4 w-full">Register</button>
      </form>
    </div>
  );
};

export default ClientRegistrationPage;
