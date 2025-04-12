import { useEffect, useState } from "react";

const fetchData = async (endpoint, token, setData) => {
  const res = await fetch(`http://localhost:5000/api/reports/${endpoint}`, {
    headers: { Authorization: `Bearer ${token}` }
  });
  const result = await res.json();
  setData(result.data || []);
};

const buildTable = (columns, data) => (
  <table className="w-full border text-sm">
    <thead>
      <tr>{columns.map((col, i) => <th key={i}>{col}</th>)}</tr>
    </thead>
    <tbody>
      {data.map((row, i) => (
        <tr key={i}>{columns.map((col, j) => <td key={j}>{row[col]}</td>)}</tr>
      ))}
    </tbody>
  </table>
);

const createReport = (title, endpoint, columns) => {
  return () => {
    const [data, setData] = useState([]);
    const token = localStorage.getItem("token");
    useEffect(() => { fetchData(endpoint, token, setData); }, [token]);
    return <div className="p-6">
      <h2 className="text-xl font-bold mb-4">{title}</h2>
      {buildTable(columns, data)}
    </div>;
  };
};


export const ClientOrdersReport = () => {
  const [data, setData] = useState([]);
  const token = localStorage.getItem("token");
  const user = JSON.parse(atob(token.split('.')[1])); // Извлекаем payload из JWT
  const clientId = user?.id;

  useEffect(() => {
    if (!clientId) return;

    fetch(`http://localhost:5000/api/reports/client-orders/${clientId}`, {
      headers: { Authorization: `Bearer ${token}` }
    })
      .then(res => res.json())
      .then(json => setData(json.data || []))
      .catch(err => console.error("Error loading client orders:", err));
  }, [clientId, token]);

  const columns = ["№ заказа", "Дата", "Стоимость", "№ накладной", "Статус"];

  return (
    <div className="p-6">
      <h2 className="text-xl font-bold mb-4">🛒 Заказы клиента</h2>
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

export const BreakEvenReportPage = createReport("📉 Точка безубыточности", "break-even", ["Номер", "Тип товара", "Товар", "Цена покупки", "Цена продажи", "Прибыль"]);
export const ClientDebtsReport = createReport("💰 Задолженности клиентов", "client-debts", ["№ заказа", "Сумма к оплате", "Фактическая сумма оплаты", "Дата дедлайна платежа"]);
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
