import { useState } from "react";

export const AdminPage = () => {
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [registrationDate, setRegistrationDate] = useState("");
  const [phone, setPhone] = useState("");
  const [login, setLogin] = useState("");
  const [password, setPassword] = useState("");
  const [positionId, setPositionId] = useState("");
  const [error, setError] = useState("");
  const [successMessage, setSuccessMessage] = useState("");

  const createEmployeeHandler = async () => {
    try {
      const token = localStorage.getItem("token");
      const response = await fetch("http://localhost:5000/api/employees/register", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${token}`
        },
        body: JSON.stringify({
          First_Name: firstName,
          Last_Name: lastName,
          Registration_Date: registrationDate, // Expect YYYY-MM-DD
          Phone: phone,
          Login: login,
          Password: password,
          Position_ID: Number(positionId)
        })
      });
      if (!response.ok) {
        const errorText = await response.text();
        setError("Error creating employee: " + errorText);
        return;
      }
      const data = await response.json();
      console.log("Employee registration response:", data);
      setSuccessMessage("Employee created successfully.");
      // Reset form fields
      setFirstName("");
      setLastName("");
      setRegistrationDate("");
      setPhone("");
      setLogin("");
      setPassword("");
      setPositionId("");
    } catch (err) {
      console.error("Error creating employee:", err);
      setError("Error creating employee: " + err.message);
    }
  };

  return (
    <div className="p-8 max-w-md mx-auto bg-gray-100 rounded-md">
      <h1 className="text-xl font-bold mb-4">Create New Employee</h1>
      {error && <div className="mb-4 text-red-500">{error}</div>}
      {successMessage && <div className="mb-4 text-green-500">{successMessage}</div>}
      <div className="mb-4">
        <label className="block mb-1">First Name</label>
        <input
          type="text"
          value={firstName}
          onChange={(e) => setFirstName(e.target.value)}
          className="w-full border p-2 rounded"
        />
      </div>
      <div className="mb-4">
        <label className="block mb-1">Last Name</label>
        <input
          type="text"
          value={lastName}
          onChange={(e) => setLastName(e.target.value)}
          className="w-full border p-2 rounded"
        />
      </div>
      <div className="mb-4">
        <label className="block mb-1">Registration Date</label>
        <input
          type="date"
          value={registrationDate}
          onChange={(e) => setRegistrationDate(e.target.value)}
          className="w-full border p-2 rounded"
        />
      </div>
      <div className="mb-4">
        <label className="block mb-1">Phone</label>
        <input
          type="text"
          value={phone}
          onChange={(e) => setPhone(e.target.value)}
          className="w-full border p-2 rounded"
        />
      </div>
      <div className="mb-4">
        <label className="block mb-1">Login</label>
        <input
          type="text"
          value={login}
          onChange={(e) => setLogin(e.target.value)}
          className="w-full border p-2 rounded"
        />
      </div>
      <div className="mb-4">
        <label className="block mb-1">Password</label>
        <input
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          className="w-full border p-2 rounded"
        />
      </div>
      <div className="mb-4">
        <label className="block mb-1">Position ID</label>
        <input
          type="number"
          value={positionId}
          onChange={(e) => setPositionId(e.target.value)}
          className="w-full border p-2 rounded"
        />
      </div>
      <button
        onClick={createEmployeeHandler}
        className="bg-blue-500 text-white p-2 rounded w-full"
      >
        Create Employee
      </button>
    </div>
  );
};
