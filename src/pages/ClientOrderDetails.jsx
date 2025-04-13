import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";

const ClientOrderDetails = () => {
  const { id } = useParams(); // Order ID from route
  const [data, setData] = useState([]);
  const [error, setError] = useState("");
  const token = localStorage.getItem("token");
  const client = JSON.parse(atob(token.split('.')[1])); // Decode JWT
  const clientId = client?.id;

  useEffect(() => {
    if (!token || !id || !clientId) return;

    fetch(`http://localhost:5000/api/reports/client-order-composition/${id}?clientId=${clientId}`, {
      headers: { Authorization: `Bearer ${token}` }
    })
      .then(res => res.json())
      .then(json => {
        if (json.success) {
          setData(json.data);
        } else {
          setError(json.message || "Unknown error");
        }
      })
      .catch(err => setError("Failed to load data: " + err.message));
  }, [id, token, clientId]);

  const columns = ["№ строки", "Товар", "Цена со скидкой", "Количество", "Стоимость"];

  return (
    <div className="p-6">
      <h2 className="text-xl font-bold mb-4">🧾 Состав заказа №{id}</h2>
      {error && <p className="text-red-500 mb-4">{error}</p>}
      <table className="w-full border text-sm">
        <thead>
          <tr>{columns.map((col, i) => <th key={i}>{col}</th>)}</tr>
        </thead>
        <tbody>
          {data.map((row, i) => (
            <tr key={i}>
              {columns.map((col, j) => <td key={j}>{row[col]}</td>)}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default ClientOrderDetails;
