import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

const fetchData = async (endpoint, token, setData) => {
  const res = await fetch(`http://localhost:5000/api/reports/${endpoint}`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  const result = await res.json();
  setData(result.data || []);
};

const buildTable = (columns, data) => (
  <table className="w-full border text-sm bg-white shadow-md rounded">
    <thead className="bg-gray-200">
      <tr>
        {columns.map((col, i) => (
          <th key={i} className="px-4 py-2 border">{col}</th>
        ))}
      </tr>
    </thead>
    <tbody>
      {data.map((row, i) => (
        <tr key={i} className="hover:bg-gray-100">
          {columns.map((col, j) => (
            <td key={j} className="px-4 py-2 border">{row[col]}</td>
          ))}
        </tr>
      ))}
    </tbody>
  </table>
);

const createReport = (title, endpoint, columns) => {
  return () => {
    const [data, setData] = useState([]);
    const token = localStorage.getItem("token");
    useEffect(() => {
      fetchData(endpoint, token, setData);
    }, [token]);
    return (
      <div className="p-6 bg-gray-50 min-h-screen">
        <h2 className="text-2xl font-bold mb-4">{title}</h2>
        {buildTable(columns, data)}
      </div>
    );
  };
};
export const ClientOrdersReport = () => {
  const [data, setData] = useState([]);
  const token = localStorage.getItem("token");
  const user = JSON.parse(atob(token.split('.')[1])); // extract payload from JWT
  const clientId = user?.id;
  const userType = user?.userType;
  const navigate = useNavigate();

  const fetchOrders = async () => {
    if (!clientId) return;

    const res = await fetch(`http://localhost:5000/api/reports/client-orders/${clientId}`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    const json = await res.json();
    setData(json.data || []);
  };

  useEffect(() => {
    fetchOrders();
  }, [clientId, token]);

  const cancelOrder = async (orderId) => {
    const reason = prompt("Введите причину отмены заказа:");
    if (!reason) return;

    const res = await fetch("http://localhost:5000/api/orders/cancel", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`
      },
      body: JSON.stringify({
        Order_ID: orderId,
        Reason: reason,
        Employee_ID: userType === "seller" ? clientId : null
      })
    });

    const result = await res.json();
    if (result.success) {
      alert("Заказ успешно отменён.");
      fetchOrders(); // refresh list
    } else {
      alert("Ошибка: " + result.message);
    }
  };

  const columns = ["№ заказа", "Дата", "Стоимость", "№ накладной", "Статус"];

  return (
    <div className="p-6">
      <h2 className="text-xl font-bold mb-4">🛒 Заказы клиента</h2>
      <table className="w-full border text-sm bg-white shadow-md">
        <thead className="bg-gray-100">
          <tr>
            {columns.map((col, i) => (
              <th key={i} className="border px-2 py-1">{col}</th>
            ))}
            <th className="border px-2 py-1">Действия</th>
          </tr>
        </thead>
        <tbody>
          {data.map((row, i) => {
            const canCancel =
              userType === "client" || userType === "seller";
            const isPending = row["Статус"] !== "Отменён";

            return (
              <tr key={i} className="hover:bg-gray-50">
                {columns.map((col, j) => (
                  <td key={j} className="border px-2 py-1">{row[col]}</td>
                ))}
                <td className="border px-2 py-1 text-center">
                  <button
                    onClick={() => navigate(`/client-order/${row["№ заказа"]}`)}
                    className="text-blue-600 hover:underline mr-2"
                  >
                    Открыть
                  </button>
                  {canCancel && isPending && (
                    <button
                      onClick={() => cancelOrder(row["№ заказа"])}
                      className="text-red-600 hover:underline"
                    >
                      Отменить
                    </button>
                  )}
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
};

export const SellersClientOrdersReport = () => {
  const [data, setData] = useState([]);
  const token = localStorage.getItem("token");
  const user = JSON.parse(atob(token.split('.')[1])); // extract payload from JWT
  const clientId = user?.id;
  const userType = user?.userType;
  const navigate = useNavigate();

  const fetchOrders = async () => {

    const res = await fetch(`http://localhost:5000/api/reports/get-all-orders`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    const json = await res.json();
    setData(json.data || []);
  };
  console.log(userType);
  useEffect(() => {
    fetchOrders();
  }, [clientId, token]);

  const cancelOrder = async (orderId) => {
    const reason = prompt("Введите причину отмены заказа:");
    if (!reason) return;

    const res = await fetch("http://localhost:5000/api/orders/cancel", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`
      },
      body: JSON.stringify({
        Order_ID: orderId,
        Reason: reason,
        Employee_ID: userType === "seller" ? clientId : null
      })
    });

    const result = await res.json();
    if (result.success) {
      alert("Заказ успешно отменён.");
      fetchOrders(); // refresh list
    } else {
      alert("Ошибка: " + result.message);
    }
  };

  const columns = ["№ заказа", "Дата", "Стоимость", "№ накладной", "Статус"];

  return (
    <div className="p-6">
      <h2 className="text-xl font-bold mb-4">🛒 Заказы клиента</h2>
      <table className="w-full border text-sm bg-white shadow-md">
        <thead className="bg-gray-100">
          <tr>
            {columns.map((col, i) => (
              <th key={i} className="border px-2 py-1">{col}</th>
            ))}
            <th className="border px-2 py-1">Действия</th>
          </tr>
        </thead>
        <tbody>
          {data.map((row, i) => {
            const canCancel =
              userType === "client" || userType === "seller";
            const isPending = row["Статус"] !== "Отменён";

            return (
              <tr key={i} className="hover:bg-gray-50">
                {columns.map((col, j) => (
                  <td key={j} className="border px-2 py-1">{row[col]}</td>
                ))}
                <td className="border px-2 py-1 text-center">
                  <button
                    onClick={() => navigate(`/client-order/${row["№ заказа"]}`)}
                    className="text-blue-600 hover:underline mr-2"
                  >
                    Открыть
                  </button>
                  {canCancel && isPending && (
                    <button
                      onClick={() => cancelOrder(row["№ заказа"])}
                      className="text-red-600 hover:underline"
                    >
                      Отменить
                    </button>
                  )}
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
};

export const AddClientContact = () => {
  const [contactType, setContactType] = useState("phone");
  const [contactInfo, setContactInfo] = useState("");
  const [successMessage, setSuccessMessage] = useState("");
  const [errorMessage, setErrorMessage] = useState("");

  const token = localStorage.getItem("token");

  const contactTypeMap = {
    phone: 1,
    email: 2
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!contactInfo.trim()) {
      setErrorMessage("Контакт не может быть пустым.");
      return;
    }

    try {
      const response = await fetch("http://localhost:5000/api/clients/contact", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`
        },
        body: JSON.stringify({
          Contact_Info: contactInfo,
          Contact_Type_ID: contactTypeMap[contactType]
        })
      });

      const result = await response.json();
      if (result.success) {
        setSuccessMessage("Контакт успешно добавлен.");
        setContactInfo("");
        setErrorMessage("");
      } else {
        setErrorMessage("Ошибка при добавлении.");
        setSuccessMessage("");
      }
    } catch (error) {
      setErrorMessage("Ошибка: " + error.message);
    }
  };

  return (
    <div className="p-6 max-w-md mx-auto bg-white shadow-md rounded">
      <h2 className="text-xl font-bold mb-4">📞 Добавить контакт</h2>

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block mb-1">Тип контакта</label>
          <select
            value={contactType}
            onChange={(e) => setContactType(e.target.value)}
            className="w-full border px-3 py-2 rounded"
          >
            <option value="phone">Телефон</option>
            <option value="email">Email</option>
          </select>
        </div>

        <div>
          <label className="block mb-1">Контакт</label>
          <input
            type="text"
            value={contactInfo}
            onChange={(e) => setContactInfo(e.target.value)}
            placeholder={contactType === "phone" ? "+996 700 000 000" : "example@mail.com"}
            className="w-full border px-3 py-2 rounded"
          />
        </div>

        {errorMessage && <p className="text-red-600">{errorMessage}</p>}
        {successMessage && <p className="text-green-600">{successMessage}</p>}

        <button
          type="submit"
          className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
        >
          Добавить
        </button>
      </form>
    </div>
  );
};

export const ClientPaymentReport = () => {
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [data, setData] = useState([]);
  const [error, setError] = useState("");

  const token = localStorage.getItem("token");

  const fetchPayments = async () => {
    if (!startDate || !endDate) {
      setError("Выберите обе даты.");
      return;
    }

    try {
      const res = await fetch(`http://localhost:5000/api/reports/order-payments?StartDate=${startDate}&EndDate=${endDate}`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      const result = await res.json();
      if (result.success) {
        setData(result.data || []);
        setError("");
      } else {
        setError("Ошибка загрузки данных.");
      }
    } catch (err) {
      setError("Ошибка: " + err.message);
    }
  };

  const columns = ["Номер", "Дата заказа", "Сумма к оплате", "Сумма оплаты"];

  return (
    <div className="p-6 bg-gray-50 min-h-screen">
      <h2 className="text-2xl font-bold mb-4">💳 Отчёт по оплатам за период</h2>

      <div className="flex gap-4 items-end mb-4">
        <div>
          <label className="block">Дата начала</label>
          <input type="date" value={startDate} onChange={e => setStartDate(e.target.value)} className="border px-2 py-1" />
        </div>
        <div>
          <label className="block">Дата окончания</label>
          <input type="date" value={endDate} onChange={e => setEndDate(e.target.value)} className="border px-2 py-1" />
        </div>
        <button onClick={fetchPayments} className="bg-blue-600 text-white px-4 py-2 rounded">Загрузить</button>
      </div>

      {error && <p className="text-red-600 mb-2">{error}</p>}

      <table className="w-full border text-sm bg-white shadow-md rounded">
        <thead className="bg-gray-200">
          <tr>{columns.map((col, i) => <th key={i} className="px-4 py-2 border">{col}</th>)}</tr>
        </thead>
        <tbody>
          {data.map((row, i) => (
            <tr key={i} className="hover:bg-gray-100">
              {columns.map((col, j) => <td key={j} className="px-4 py-2 border">{row[col]}</td>)}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default ClientPaymentReport;


export const BreakEvenReportPage = createReport(
  "📉 Точка безубыточности",
  "break-even",
  ["Номер", "Тип товара", "Товар", "Цена покупки", "Цена продажи", "Прибыль"]
);
export const ClientDebtsReport = createReport("💰 Задолженности клиентов", "client-debts", ["№ заказа", "Сумма к оплате", "Фактическая сумма оплаты", "Дата дедлайна платежа"]);
export const WarehouseRemaindersReport = createReport(
  "📦 Остатки поставок",
  "warehouse-remainder",
  ["Номер", "Тип товаров", "Товар", "Цена", "Поставлено", "Продано", "Остаток", "Номер поставки", "Номер склада"]
);

export const OrdersSummaryReport = createReport("📦 Сводка заказов", "orders-summary", ["Номер", "Дата", "Состояние", "Тип заказа", "К оплате"]);
export const PromotionsReport = createReport("🎉 Текущие акции", "sales-promotions", ["Номер", "Название акции", "Скидка", "Дата начала", "Дата окончания"]);
export const SupplierDebtReport = createReport("📦 Задолженности поставщиков", "supplier-debt", ["Номер", "Номер поставки", "Поставщик", "Дедлайн", "Сумма оплате", "Задолженность"]);
export const ProfitLossReport = createReport("📊 Прибыль и убытки", "profit-loss", ["Номер", "Расход", "Доходы", "Налоги", "Прибыль"]);
export const ProductProfitReport = createReport("📈 Прибыльность товара", "supply-product-profit", ["Номер", "Тип товара", "Товар", "Цена покупки", "Цена продажи", "Номер поставки", "Прибыль"]);
export const TaxesReport = createReport("🧾 Налоги", "taxes", ["Номер", "Название налога", "Сумма", "Дата начала", "Дата окончания"]);
export const SalariesReport = createReport("💼 Зарплаты сотрудников", "salaries", ["Номер", "Дата", "Начисленно", "Оплачено", "Должность сотрудник"]);
export const SupplyPaymentsReport = createReport("💸 Оплаты поставок", "supply-payments", ["Номер", "Дата", "Сумма", "Поставщик", "Сотрудник", "Тип оплаты"]);
export const DefectiveProductsReport = createReport("🚫 Бракованные товары", "defective-products", ["Номер", "Дата поставки", "Тип товаров", "Товар", "Количество", "Цена", "Поставщик"]);
export const WarehouseProductsReport = createReport("🏬 Товары на складе", "warehouse-products", ["Номер", "Тип товаров", "Товар", "Цена", "Количество", "Номер поставки", "Номер склада"]);
export const PriceListReport = createReport("🧾 Прайс-лист", "price-list", ["Номер", "Категория товара", "Товар", "Цена товара"]);
export const OrderCompositionReport = createReport("🧾 Состав заказа", "order-composition", ["№ строки", "Товар", "Цена со скидкой", "Количество", "Стоимость"]);
export const CanceledOrdersReport = createReport("❌ Отмененные заказы", "canceled-orders", ["Номер заказа", "Дата заказа", "Причина отмены", "Тип оплаты"]);
export const ProductSalesReport = createReport("📦 Продажи по товарам", "product-sales", ["Номер", "Тип товара", "Товар", "Цена", "Кол-во"]);
export const SalesByClientsReport = createReport("👥 Продажи по клиентам", "sales-by-clients", ["Номер", "ФИО", "Оплачено", "Скидка клиента", "Акция"]);
export const SalesByWarehouseReport = createReport("📦 Продажи по складу", "sales-by-warehouse", ["Номер", "Тип товара", "Товар", "Цена", "Количество"]);
