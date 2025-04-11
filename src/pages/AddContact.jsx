import { useState } from "react";

export const AddContactPage = () => {
  const [contactInfo, setContactInfo] = useState("");
  const [contactTypeId, setContactTypeId] = useState("");
  const [error, setError] = useState("");
  const [successMessage, setSuccessMessage] = useState("");

  const addContactHandler = async () => {
    try {
      const token = localStorage.getItem("token");
      const response = await fetch("http://localhost:5000/api/clients/contact", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${token}`
        },
        body: JSON.stringify({
          Contact_Info: contactInfo,
          Contact_Type_ID: Number(contactTypeId)
        })
      });
      if (!response.ok) {
        const errorText = await response.text();
        setError("Error adding contact: " + errorText);
        return;
      }
      const data = await response.json();
      console.log("Add contact response:", data);
      setSuccessMessage("Contact added successfully.");
      setContactInfo("");
      setContactTypeId("");
    } catch (err) {
      console.error("Error adding contact:", err);
      setError("Error adding contact: " + err.message);
    }
  };

  return (
    <div className="p-8 max-w-md mx-auto bg-gray-100 rounded-md">
      <h1 className="text-xl font-bold mb-4">Add New Contact</h1>
      {error && <div className="mb-4 text-red-500">{error}</div>}
      {successMessage && <div className="mb-4 text-green-500">{successMessage}</div>}
      <div className="mb-4">
        <label className="block mb-1">Contact Info</label>
        <input
          type="text"
          value={contactInfo}
          onChange={(e) => setContactInfo(e.target.value)}
          className="w-full border p-2 rounded"
        />
      </div>
      <div className="mb-4">
        <label className="block mb-1">Contact Type ID</label>
        <input
          type="number"
          value={contactTypeId}
          onChange={(e) => setContactTypeId(e.target.value)}
          className="w-full border p-2 rounded"
        />
      </div>
      <button
        onClick={addContactHandler}
        className="bg-blue-500 text-white p-2 rounded w-full"
      >
        Add Contact
      </button>
    </div>
  );
};
