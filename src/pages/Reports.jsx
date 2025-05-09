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
  <table className="w-full text-sm bg-white/60 backdrop-blur-lg border border-rose-300 rounded-3xl shadow-lg">
    <thead className="bg-rose-200/50">
      <tr>
        {columns.map((col, i) => (
          <th key={i} className="px-4 py-2 border-b border-rose-300 font-bold text-rose-900 tracking-wide text-left uppercase">
            {col}
          </th>
        ))}
      </tr>
    </thead>
    <tbody>
      {data.map((row, i) => (
        <tr key={i} className={i % 2 === 0 ? "bg-rose-50/70 hover:bg-rose-100 transition" : "bg-rose-100/80 hover:bg-rose-200 transition"}>
          {columns.map((col, j) => (
            <td key={j} className="px-4 py-2 border-b border-rose-200 text-rose-900">{row[col]}</td>
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
      <div className="min-h-screen bg-gradient-to-br from-rose-100 via-pink-200 to-rose-100 p-8 font-serif text-rose-900">
        <h2 className="text-5xl font-extrabold text-center mb-10 tracking-wide drop-shadow-md">{title}</h2>
        {buildTable(columns, data)}
      </div>
    );
  };
};

export const ClientOrdersReport = () => {
  const [data, setData] = useState([]);
  const token = localStorage.getItem("token");
  const user = JSON.parse(atob(token.split('.')[1]));
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
      headers: { "Content-Type": "application/json", Authorization: `Bearer ${token}` },
      body: JSON.stringify({ Order_ID: orderId, Reason: reason, Employee_ID: userType === "seller" ? clientId : null }),
    });
    const result = await res.json();
    if (result.success) {
      alert("Заказ успешно отменён.");
      fetchOrders();
    } else {
      alert("Ошибка: " + result.message);
    }
  };

  const columns = ["№ заказа", "Дата", "Стоимость", "№ накладной", "Статус"];

  return (
    <div className="min-h-screen bg-gradient-to-br from-rose-100 via-pink-200 to-rose-100 p-8 font-serif text-rose-900">
      <h2 className="text-4xl font-bold text-center mb-8">🛒 Заказы клиента</h2>
      <table className="w-full bg-white/60 backdrop-blur-lg border border-rose-300 rounded-3xl shadow-lg text-sm">
        <thead className="bg-rose-200/50">
          <tr>
            {columns.map((col, i) => (
              <th key={i} className="px-4 py-3 border-b border-rose-300 font-bold text-left tracking-wide">{col}</th>
            ))}
            <th className="px-4 py-3 border-b border-rose-300 font-bold text-left">Действия</th>
          </tr>
        </thead>
        <tbody>
          {data.map((row, i) => {
            const canCancel = userType === "client" || userType === "seller";
            const isPending = row["Статус"] !== "Отменён";
            return (
              <tr key={i} className={i % 2 === 0 ? "bg-rose-50/70 hover:bg-rose-100 transition" : "bg-rose-100/80 hover:bg-rose-200 transition"}>
                {columns.map((col, j) => (
                  <td key={j} className="px-4 py-3 border-b border-rose-200">{row[col]}</td>
                ))}
                <td className="px-4 py-3 border-b border-rose-200">
                  <button
                    onClick={() => navigate(`/client-order/${row["№ заказа"]}`)}
                    className="text-pink-600 hover:underline mr-4 font-bold"
                  >
                    Открыть
                  </button>
                  {canCancel && isPending && (
                    <button
                      onClick={() => cancelOrder(row["№ заказа"])}
                      className="text-red-600 hover:underline font-bold"
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
  const user = JSON.parse(atob(token.split('.')[1]));
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

  useEffect(() => {
    fetchOrders();
  }, [clientId, token]);

  const cancelOrder = async (orderId) => {
    const reason = prompt("Введите причину отмены заказа:");
    if (!reason) return;
    const res = await fetch("http://localhost:5000/api/orders/cancel", {
      method: "POST",
      headers: { "Content-Type": "application/json", Authorization: `Bearer ${token}` },
      body: JSON.stringify({ Order_ID: orderId, Reason: reason, Employee_ID: userType === "seller" ? clientId : null }),
    });
    const result = await res.json();
    if (result.success) {
      alert("Заказ успешно отменён.");
      fetchOrders();
    } else {
      alert("Ошибка: " + result.message);
    }
  };

  const columns = ["№ заказа", "Дата", "Стоимость", "№ накладной", "Статус"];

  return (
    <div className="min-h-screen bg-gradient-to-br from-rose-100 via-pink-200 to-rose-100 p-8 font-serif text-rose-900">
      <h2 className="text-4xl font-bold text-center mb-8">🛒 Все заказы клиентов</h2>
      <table className="w-full bg-white/60 backdrop-blur-lg border border-rose-300 rounded-3xl shadow-lg text-sm">
        <thead className="bg-rose-200/50">
          <tr>
            {columns.map((col, i) => (
              <th key={i} className="px-4 py-3 border-b border-rose-300 font-bold text-left tracking-wide">{col}</th>
            ))}
            <th className="px-4 py-3 border-b border-rose-300 font-bold text-left">Действия</th>
          </tr>
        </thead>
        <tbody>
          {data.map((row, i) => {
            const canCancel = userType === "client" || userType === "seller";
            const isPending = row["Статус"] !== "Отменён";
            return (
              <tr key={i} className={i % 2 === 0 ? "bg-rose-50/70 hover:bg-rose-100 transition" : "bg-rose-100/80 hover:bg-rose-200 transition"}>
                {columns.map((col, j) => (
                  <td key={j} className="px-4 py-3 border-b border-rose-200">{row[col]}</td>
                ))}
                <td className="px-4 py-3 border-b border-rose-200">
                  <button
                    onClick={() => navigate(`/client-order/${row["№ заказа"]}`)}
                    className="text-pink-600 hover:underline mr-4 font-bold"
                  >
                    Открыть
                  </button>
                  {canCancel && isPending && (
                    <button
                      onClick={() => cancelOrder(row["№ заказа"])}
                      className="text-red-600 hover:underline font-bold"
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

  const contactTypeMap = { phone: 1, email: 2 };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!contactInfo.trim()) {
      setErrorMessage("Контакт не может быть пустым.");
      return;
    }
    try {
      const response = await fetch("http://localhost:5000/api/clients/contact", {
        method: "POST",
        headers: { "Content-Type": "application/json", Authorization: `Bearer ${token}` },
        body: JSON.stringify({
          Contact_Info: contactInfo,
          Contact_Type_ID: contactTypeMap[contactType]
        })
      });
      const result = await response.json();
      if (result.success) {
        setSuccessMessage("🌸 Контакт успешно добавлен.");
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
    <div className="min-h-screen bg-gradient-to-br from-rose-100 via-pink-200 to-rose-100 flex items-center justify-center px-6 py-12 font-serif text-rose-900">
      <form onSubmit={handleSubmit} className="w-full max-w-md bg-white/60 backdrop-blur-lg p-8 rounded-3xl border border-rose-300 shadow-2xl space-y-6">
        <h2 className="text-4xl font-bold text-center mb-6 tracking-wide drop-shadow-md">📞 Добавить контакт</h2>

        <div>
          <label className="block mb-1 font-semibold">Тип контакта</label>
          <select
            value={contactType}
            onChange={(e) => setContactType(e.target.value)}
            className="w-full border px-4 py-2 rounded-xl bg-rose-50/70 border-rose-300 focus:ring-pink-400"
          >
            <option value="phone">Телефон</option>
            <option value="email">Email</option>
          </select>
        </div>

        <div>
          <label className="block mb-1 font-semibold">Контакт</label>
          <input
            type="text"
            value={contactInfo}
            onChange={(e) => setContactInfo(e.target.value)}
            placeholder={contactType === "phone" ? "+996 700 000 000" : "example@mail.com"}
            className="w-full border px-4 py-2 rounded-xl bg-rose-50/70 border-rose-300 focus:ring-pink-400"
          />
        </div>

        {errorMessage && <p className="text-red-600 font-medium">{errorMessage}</p>}
        {successMessage && <p className="text-green-600 font-medium">{successMessage}</p>}

        <button
          type="submit"
          className="w-full py-3 bg-gradient-to-r from-pink-400 to-rose-300 hover:brightness-110 rounded-full font-bold text-rose-900 shadow-lg"
        >
          🌸 Добавить
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
    <div className="min-h-screen bg-gradient-to-br from-rose-100 via-pink-200 to-rose-100 p-8 font-serif text-rose-900">
      <h2 className="text-5xl font-extrabold text-center mb-10 tracking-wide drop-shadow-md">💳 Отчёт по оплатам</h2>

      <div className="flex gap-6 flex-wrap items-end mb-8 justify-center">
        <div>
          <label className="block mb-1 font-semibold">Дата начала</label>
          <input type="date" value={startDate} onChange={e => setStartDate(e.target.value)} className="border border-rose-300 px-4 py-2 rounded-xl bg-rose-50/70" />
        </div>
        <div>
          <label className="block mb-1 font-semibold">Дата окончания</label>
          <input type="date" value={endDate} onChange={e => setEndDate(e.target.value)} className="border border-rose-300 px-4 py-2 rounded-xl bg-rose-50/70" />
        </div>
        <button
          onClick={fetchPayments}
          className="bg-gradient-to-r from-pink-400 to-rose-300 hover:brightness-110 px-6 py-3 rounded-full font-bold text-rose-900 shadow-md"
        >
          🌸 Загрузить
        </button>
      </div>

      {error && <p className="text-red-600 text-center mb-6 font-semibold">{error}</p>}

      <div className="overflow-x-auto rounded-3xl shadow-2xl backdrop-blur-lg bg-white/60 border border-rose-300 p-6">
        <table className="w-full text-sm text-rose-900">
          <thead className="bg-rose-200/50">
            <tr>{columns.map((col, i) => <th key={i} className="px-4 py-3 border-b border-rose-300 text-left font-bold uppercase tracking-wide">{col}</th>)}</tr>
          </thead>
          <tbody>
            {data.map((row, i) => (
              <tr key={i} className={i % 2 === 0 ? "bg-rose-50/70 hover:bg-rose-100 transition" : "bg-rose-100/80 hover:bg-rose-200 transition"}>
                {columns.map((col, j) => <td key={j} className="px-4 py-3 border-b border-rose-200">{row[col]}</td>)}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};
export const BreakEvenReportPage = createReport(
  "📉 Точка безубыточности",
  "break-even",
  ["Номер", "Тип товара", "Товар", "Цена покупки", "Цена продажи", "Прибыль"]
);

export const ClientDebtsReport = createReport(
  "💰 Задолженности клиентов",
  "client-debts",
  ["№ заказа", "Сумма к оплате", "Фактическая сумма оплаты", "Дата дедлайна платежа"]
);

export const WarehouseRemaindersReport = createReport(
  "📦 Остатки поставок",
  "warehouse-remainder",
  ["Номер", "Тип товаров", "Товар", "Цена", "Поставлено", "Продано", "Остаток", "Номер поставки", "Номер склада"]
);

export const OrdersSummaryReport = createReport(
  "📦 Сводка заказов",
  "orders-summary",
  ["Номер", "Дата", "Состояние", "Тип заказа", "К оплате"]
);

export const PromotionsReport = createReport(
  "🎉 Текущие акции",
  "sales-promotions",
  ["Номер", "Название акции", "Скидка", "Дата начала", "Дата окончания"]
);

export const SupplierDebtReport = createReport(
  "📦 Задолженности поставщиков",
  "supplier-debt",
  ["Номер", "Номер поставки", "Поставщик", "Дедлайн", "Сумма оплате", "Задолженность"]
);

export const ProfitLossReport = createReport(
  "📊 Прибыль и убытки",
  "profit-loss",
  ["Номер", "Расход", "Доходы", "Налоги", "Прибыль"]
);

export const ProductProfitReport = createReport(
  "📈 Прибыльность товара",
  "supply-product-profit",
  ["Номер", "Тип товара", "Товар", "Цена покупки", "Цена продажи", "Номер поставки", "Прибыль"]
);

export const TaxesReport = createReport(
  "🧾 Налоги",
  "taxes",
  ["Номер", "Название налога", "Сумма", "Дата начала", "Дата окончания"]
);

export const SalariesReport = createReport(
  "💼 Зарплаты сотрудников",
  "salaries",
  ["Номер", "Дата", "Начисленно", "Оплачено", "Должность сотрудник"]
);

export const SupplyPaymentsReport = createReport(
  "💸 Оплаты поставок",
  "supply-payments",
  ["Номер", "Дата", "Сумма", "Поставщик", "Сотрудник", "Тип оплаты"]
);

export const DefectiveProductsReport = createReport(
  "🚫 Бракованные товары",
  "defective-products",
  ["Номер", "Дата поставки", "Тип товаров", "Товар", "Количество", "Цена", "Поставщик"]
);

export const WarehouseProductsReport = createReport(
  "🏬 Товары на складе",
  "warehouse-products",
  ["Номер", "Тип товаров", "Товар", "Цена", "Количество", "Номер поставки", "Номер склада"]
);

export const PriceListReport = createReport(
  "🧾 Прайс-лист",
  "price-list",
  ["Номер", "Категория товара", "Товар", "Цена товара"]
);

export const OrderCompositionReport = createReport(
  "🧾 Состав заказа",
  "order-composition",
  ["№ строки", "Товар", "Цена со скидкой", "Количество", "Стоимость"]
);

export const CanceledOrdersReport = createReport(
  "❌ Отмененные заказы",
  "canceled-orders",
  ["Номер заказа", "Дата заказа", "Причина отмены", "Тип оплаты"]
);

export const ProductSalesReport = createReport(
  "📦 Продажи по товарам",
  "product-sales",
  ["Номер", "Тип товара", "Товар", "Цена", "Кол-во"]
);

export const SalesByClientsReport = createReport(
  "👥 Продажи по клиентам",
  "sales-by-clients",
  ["Номер", "ФИО", "Оплачено", "Скидка клиента", "Акция"]
);

export const SalesByWarehouseReport = createReport(
  "📦 Продажи по складу",
  "sales-by-warehouse",
  ["Номер", "Тип товара", "Товар", "Цена", "Количество"]
);
