import { Link } from "react-router-dom";
import Header from "../pages/Header";


const DashboardCard = ({ to, label }) => (
  <Link to={to} className="block bg-white shadow-md rounded-md p-4 hover:bg-gray-100">
    {label}
  </Link>
);

const createDashboard = (title, links) => {
  return () => (
    <div className="p-6">
      <Header />
      <h1 className="text-2xl font-bold mb-6">{title}</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {links.map(([path, label]) => (
          <DashboardCard key={path} to={path} label={label} />
        ))}
      </div>
    </div>
  );
};

export const AdminDashboard = createDashboard("👑 Админ-панель", [
  ["/admin/create-employee", "Создание сотрудника"],
  ["/reports/break-even", "Точка безубыточности"],
  ["/reports/orders", "Сводка заказов"],
  ["/reports/client-debts", "Задолженности клиентов"],
  ["/reports/supply-debt", "Задолженности поставщиков"],
  ["/reports/profit-loss", "Отчёт о прибылях и убытках"],
  ["/reports/supply-payments", "Оплаты поставок"],
  ["/reports/canceled-orders", "Отмененные заказы"],
  ["/reports/taxes", "Налоги"],
  ["/reports/salaries", "Зарплаты сотрудников"]
]);

export const SellerDashboard = createDashboard("🛒 Панель продавца", [
  ["/reports/price-list", "Прайс-лист"],
  ["/reports/seller-orders", "Сводка заказов"],
  ["/reports/client-debts", "Задолженности клиентов"],
  ["/reports/warehouse-remainders", "Остатки на складе"],
  ["/reports/warehouse", "Складской отчёт"],
  ["/reports/product-sales", "Продажи по товарам"],
  ["/reports/sales-by-clients", "Продажи по клиентам"],
  ["/reports/sales-by-warehouse", "Продажи по складу"],
  ["/reports/order-receipt", "Состав заказа"],
  ["/reports/promotions", "Акции"]
]);

export const PurchasingManagerDashboard = createDashboard("📦 Закупки", [
  ["/reports/supply-debt", "Задолженности поставщиков"],
  ["/reports/warehouse", "Складской отчёт"],
  ["/reports/product-profit", "Прибыльность товаров"],
  ["/reports/defective-products", "Брак при поставке"],
  ["/reports/price-list", "Прайс-лист"],
  ["/reports/supply-payments", "Оплаты поставок"]
]);

export const AccountantDashboard = createDashboard("💰 Бухгалтерия", [
  ["/reports/client-debts", "Задолженности клиентов"],
  ["/reports/supply-payments", "Оплаты поставок"],
  ["/reports/profit-loss", "Прибыль и убытки"],
  ["/reports/salaries", "Зарплаты"],
  ["/reports/taxes", "Налоги"]
]);

export const ClientDashboard = createDashboard("👤 Кабинет клиента", [
  ["/reports/price-list", "Прайс-лист"],
  ["/order-payment", "Оплата заказа"],
  ["/reports/client-orders", "Мои заказы"],
  ["/reports/promotions", "Актуальные акции"],
  ["/reports/client-payments", "Отчёт по оплатам"],
  ["/client/add-contact", "Добавить контакт"],
  ["/reports/client-debts", "Задолженности"],
  ["/reports/canceled-orders", "Отмененные заказы"],
]);