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
    <div className="p-8 max-w-md mx-auto bg-gradient-to-tr from-indigo-900 via-purple-800 to-blue-900 text-white shadow-2xl rounded-2xl">
      <h1 className="text-3xl font-semibold mb-6 text-center tracking-wide">
        Add New Contact
      </h1>

      {error && (
        <div className="mb-4 bg-red-500/20 border border-red-500 text-red-300 px-4 py-2 rounded">
          {error}
        </div>
      )}
      {successMessage && (
        <div className="mb-4 bg-green-500/20 border border-green-500 text-green-300 px-4 py-2 rounded">
          {successMessage}
        </div>
      )}

      <div className="mb-4">
        <label className="block mb-1 text-sm font-light">Contact Info</label>
        <input
          type="text"
          value={contactInfo}
          onChange={(e) => setContactInfo(e.target.value)}
          className="w-full p-2 rounded bg-white/10 border border-white/30 placeholder:text-gray-200 text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
          placeholder="Enter contact info"
        />
      </div>
      <div className="mb-6">
        <label className="block mb-1 text-sm font-light">Contact Type ID</label>
        <input
          type="number"
          value={contactTypeId}
          onChange={(e) => setContactTypeId(e.target.value)}
          className="w-full p-2 rounded bg-white/10 border border-white/30 placeholder:text-gray-200 text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
          placeholder="Enter contact type ID"
        />
      </div>

      <button
        onClick={addContactHandler}
        className="w-full py-2 bg-gradient-to-r from-purple-600 to-blue-600 hover:from-purple-500 hover:to-blue-500 transition-all duration-300 rounded-xl font-semibold shadow-lg"
      >
        Add Contact
      </button>
    </div>
  );
};
