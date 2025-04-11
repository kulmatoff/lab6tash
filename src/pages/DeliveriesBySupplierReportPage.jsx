import { useEffect, useState } from "react";

const DeliveriesBySupplierReportPage = () => {
  const [reportData, setReportData] = useState([]);
  const [error, setError] = useState("");

  const fetchReport = async () => {
    try {
      const token = localStorage.getItem("token");
      const response = await fetch("http://localhost:5000/api/reports/deliveries-by-supplier", {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${token}`,
        },
      });
      if (!response.ok) {
        const errorText = await response.text();
        setError(errorText);
        return;
      }
      const data = await response.json();
      setReportData(data.data);
    } catch (err) {
      setError(err.message);
    }
  };

  useEffect(() => {
    fetchReport();
  }, []);

  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold mb-4">Deliveries By Supplier Report</h1>
      {error && <div className="text-red-500">{error}</div>}
      {reportData.length > 0 ? (
        <table className="min-w-full border mt-4">
          <thead>
            <tr>
              <th className="border px-4 py-2">Номер</th>
              <th className="border px-4 py-2">Дата</th>
              <th className="border px-4 py-2">Поставщик</th>
              <th className="border px-4 py-2">Тип товара</th>
              <th className="border px-4 py-2">Товар</th>
              <th className="border px-4 py-2">Кол-во</th>
              <th className="border px-4 py-2">Цена</th>
              <th className="border px-4 py-2">Склад</th>
            </tr>
          </thead>
          <tbody>
            {reportData.map((row, idx) => (
              <tr key={idx}>
                <td className="border px-4 py-2">{row.Номер || row["Номер"]}</td>
                <td className="border px-4 py-2">{row.Дата || row["Дата"]}</td>
                <td className="border px-4 py-2">{row.Поставщик}</td>
                <td className="border px-4 py-2">{row["Тип товара"]}</td>
                <td className="border px-4 py-2">{row.Товар}</td>
                <td className="border px-4 py-2">{row["Кол-во"]}</td>
                <td className="border px-4 py-2">{row.Цена}</td>
                <td className="border px-4 py-2">{row.Склад}</td>
              </tr>
            ))}
          </tbody>
        </table>
      ) : (
        <div>No data available</div>
      )}
    </div>
  );
};

export default DeliveriesBySupplierReportPage;
