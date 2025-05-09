import { Link } from "react-router-dom";
import Header from "../pages/Header";

const DashboardCard = ({ to, label }) => (
  <Link
    to={to}
    className="block p-6 rounded-3xl shadow-md bg-gradient-to-br from-pink-100 via-rose-200 to-rose-100 text-rose-900 hover:shadow-2xl hover:scale-[1.03] hover:brightness-110 transition-all duration-300 font-semibold backdrop-blur-md border border-rose-300"
  >
    <span className="text-lg tracking-wide">{label}</span>
  </Link>
);

const createDashboard = (title, links) => {
  return () => (
    <div className="min-h-screen bg-gradient-to-br from-rose-100 via-pink-200 to-rose-100 px-6 py-12 font-serif text-rose-900">
      <Header />
      <h1 className="text-5xl font-extrabold mb-12 text-center tracking-wide drop-shadow-md">
        {title}
      </h1>
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8 max-w-7xl mx-auto">
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
  ["/reports/salaries", "Зарплаты сотрудников"],
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
  ["/reports/promotions", "Акции"],
]);

export const PurchasingManagerDashboard = createDashboard("📦 Закупки", [
  ["/reports/supply-debt", "Задолженности поставщиков"],
  ["/reports/warehouse", "Складской отчёт"],
  ["/reports/product-profit", "Прибыльность товаров"],
  ["/reports/defective-products", "Брак при поставке"],
  ["/reports/price-list", "Прайс-лист"],
  ["/reports/supply-payments", "Оплаты поставок"],
]);

export const AccountantDashboard = createDashboard("💰 Бухгалтерия", [
  ["/reports/client-debts", "Задолженности клиентов"],
  ["/reports/supply-payments", "Оплаты поставок"],
  ["/reports/profit-loss", "Прибыль и убытки"],
  ["/reports/salaries", "Зарплаты"],
  ["/reports/taxes", "Налоги"],
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
