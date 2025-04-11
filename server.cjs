const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const jwt = require("jsonwebtoken");
const { sql, poolPromise } = require("./db.cjs");

const app = express();
app.use(bodyParser.json());
app.use(cors());

const PORT = process.env.PORT || 5000;
const SECRET_KEY = process.env.SECRET_KEY || "my_secret_key"; // Рекомендуется хранить в .env

// Middleware для проверки JWT-токена
function verifyToken(req, res, next) {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        return res.status(403).json({ message: "No token provided" });
    }
    const token = authHeader.split(" ")[1];
    try {
        const decoded = jwt.verify(token, SECRET_KEY);
        req.user = decoded;
        next();
    } catch (err) {
        return res.status(401).json({ message: "Invalid or expired token" });
    }
}

// ---------------
// AUTHENTICATION
// ---------------
app.post("/api/auth", async (req, res) => {
    try {
        const { userType, login, password } = req.body;
        if (!userType || !login || !password) {
            return res.status(400).json({ success: false, message: "Incorrect request" });
        }
        const pool = await poolPromise;
        const result = await pool
            .request()
            .input("userType", sql.VarChar, userType)
            .input("login", sql.VarChar, login)
            .input("password", sql.VarChar, password)
            .query("EXEC sp_AuthenticateUser @userType, @login, @password");
        if (result.recordset.length === 0) {
            return res.status(401).json({ success: false, message: "Incorrect login or password" });
        }
        const user = result.recordset[0];
        const userId = user.Client_ID || user.Employee_ID;
        const token = jwt.sign(
            { id: userId, login: user.Login, userType },
            SECRET_KEY,
            { expiresIn: "1h" }
        );
        res.status(200).json({
            success: true,
            token,
            user: { id: userId, name: user.First_Name + " " + user.Last_Name, userType }
        });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// ---------------
// Клиенты
// ---------------

// Получение всех клиентов (sp_GetClients)
app.get("/api/clients", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetClients");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Получение клиента по ID (sp_GetClientById)
app.get("/api/clients/:id", verifyToken, async (req, res) => {
    try {
        const clientId = req.params.id;
        const pool = await poolPromise;
        const result = await pool
            .request()
            .input("Client_ID", sql.Int, clientId)
            .query("EXEC sp_GetClientById @Client_ID");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Регистрация клиента (sp_RegisterClient)
app.post("/api/clients/register", async (req, res) => {
    try {
        const {
            First_Name, Last_Name, Client_Type_ID, Contacts_ID,
            District_ID, Discount, Registration_Date, Workplace,
            Position, Passport_Number, Login, Password
        } = req.body;
        const pool = await poolPromise;
        const result = await pool
            .request()
            .input("First_Name", sql.VarChar, First_Name)
            .input("Last_Name", sql.VarChar, Last_Name)
            .input("Client_Type_ID", sql.Int, Client_Type_ID)
            .input("Contacts_ID", sql.Int, Contacts_ID)
            .input("District_ID", sql.Int, District_ID)
            .input("Discount", sql.Float, Discount)
            .input("Registration_Date", sql.VarChar, Registration_Date)
            .input("Workplace", sql.VarChar, Workplace)
            .input("Position", sql.VarChar, Position)
            .input("Passport_Number", sql.VarChar, Passport_Number)
            .input("Login", sql.VarChar, Login)
            .input("Password", sql.VarChar, Password)
            .query("EXEC sp_RegisterClient @First_Name, @Last_Name, @Client_Type_ID, @Contacts_ID, @District_ID, @Discount, @Registration_Date, @Workplace, @Position, @Passport_Number, @Login, @Password");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Добавление контакта клиента (sp_AddClientContact)
app.post("/api/clients/contact", async (req, res) => {
    try {
        const { Contact_Info, Contact_Type_ID } = req.body;
        const pool = await poolPromise;
        const result = await pool
            .request()
            .input("Contact_Info", sql.VarChar, Contact_Info)
            .input("Contact_Type_ID", sql.Int, Contact_Type_ID)
            .query("EXEC sp_AddClientContact @Contact_Info, @Contact_Type_ID");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// ---------------
// Сотрудники
// ---------------

// Получение всех сотрудников (sp_GetEmployees)
app.get("/api/employees", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetEmployees");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Получение сотрудника по ID (sp_GetEmployeeById)
app.get("/api/employees/:id", verifyToken, async (req, res) => {
    try {
        const employeeId = req.params.id;
        const pool = await poolPromise;
        const result = await pool
            .request()
            .input("Employee_ID", sql.Int, employeeId)
            .query("EXEC sp_GetEmployeeById @Employee_ID");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Регистрация сотрудника (sp_RegisterEmployee)
app.post("/api/employees/register", async (req, res) => {
    try {
        const { First_Name, Last_Name, Registration_Date, Phone, Login, Password, Position_ID } = req.body;
        const pool = await poolPromise;
        const result = await pool
            .request()
            .input("First_Name", sql.VarChar, First_Name)
            .input("Last_Name", sql.VarChar, Last_Name)
            .input("Registration_Date", sql.Date, Registration_Date)
            .input("Phone", sql.VarChar, Phone)
            .input("Login", sql.VarChar, Login)
            .input("Password", sql.VarChar, Password)
            .input("Position_ID", sql.Int, Position_ID)
            .query("EXEC sp_RegisterEmployee @First_Name, @Last_Name, @Registration_Date, @Phone, @Login, @Password, @Position_ID");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// ---------------
// Заказы
// ---------------

// Получение всех заказов (sp_GetOrders)
app.get("/api/orders", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetOrders");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Добавление заказа (sp_AddOrder)
app.post("/api/orders", verifyToken, async (req, res) => {
    try {
        const { Client_ID, Order_Type_ID, Discount_ID, Order_Status_ID, Order_Date, Invoice_Number, Comment, Employee_ID } = req.body;
        const pool = await poolPromise;
        const result = await pool
            .request()
            .input("Client_ID", sql.Int, Client_ID)
            .input("Order_Type_ID", sql.Int, Order_Type_ID)
            .input("Discount_ID", sql.Int, Discount_ID)
            .input("Order_Status_ID", sql.Int, Order_Status_ID)
            .input("Order_Date", sql.Date, Order_Date)
            .input("Invoice_Number", sql.VarChar, Invoice_Number)
            .input("Comment", sql.VarChar, Comment)
            .input("Employee_ID", sql.Int, Employee_ID)
            .query("EXEC sp_AddOrder @Client_ID, @Order_Type_ID, @Discount_ID, @Order_Status_ID, @Order_Date, @Invoice_Number, @Comment, @Employee_ID");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// ---------------
// Товары и поставки
// ---------------

// Получение списка продуктов (sp_GetProducts)
app.get("/api/products", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetProducts");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Получение списка поставщиков (sp_GetSuppliers)
app.get("/api/suppliers", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetSuppliers");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Получение поставок (sp_GetDeliveries)
app.get("/api/deliveries", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetDeliveries");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// ---------------
// ФИНАНСОВЫЕ ОТЧЁТЫ / РЕПОРТЫ
// ---------------

// 1. Точка безубыточного товара (sp_GetBreakEvenPoint)
app.get("/api/reports/break-even", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetBreakEvenPoint");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 2. Поставки по поставщикам (sp_GetDeliveriesBySupplier)
app.get("/api/reports/deliveries-by-supplier", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetDeliveriesBySupplier");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 3. Задолженность поставщиков (sp_GetSupplierDebt)
app.get("/api/reports/supplier-debt", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetSupplierDebt");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 4. Прибыльность товара по поставкам (sp_GetSupplyProductProfit)
app.get("/api/reports/supply-product-profit", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetSupplyProductProfit");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 5. Налоги (sp_GetTaxes)
app.get("/api/reports/taxes", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetTaxes");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 6. Зарплата сотрудников (sp_GetSalaries)
app.get("/api/reports/salaries", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetSalaries");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 7. Продажи по акциям (sp_GetSalesByPromotions)
app.get("/api/reports/sales-promotions", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetSalesByPromotions");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 8. Отчет о прибылях и убытках (sp_GetProfitLossReport)
app.get("/api/reports/profit-loss", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetProfitLossReport");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 9. Оплата поставок (sp_GetSupplyPayments)
app.get("/api/reports/supply-payments", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetSupplyPayments");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 10. Список бракованных товаров при поставке (sp_GetDefectiveProducts)
app.get("/api/reports/defective-products", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetDefectiveProducts");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 11. Список товаров на складе (сп_Отчет №5 Sales Manager) (sp_GetWarehouseProducts)
app.get("/api/reports/warehouse-products", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetWarehouseProducts");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 12. Прайс-лист (sp_GetPriceList)
app.get("/api/reports/price-list", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetPriceList");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 13. Состав заказа (чек) (sp_GetOrderComposition)
app.get("/api/reports/order-composition", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetOrderComposition");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 14. Заказы клиента (sp_GetClientOrders)
app.get("/api/reports/client-orders", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetClientOrders");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 15. Форма отмены заказа (sp_CancelOrder) – выполняется методом POST
app.post("/api/orders/cancel", verifyToken, async (req, res) => {
    try {
        const { Order_ID, Reason, Employee_ID } = req.body;
        const pool = await poolPromise;
        const result = await pool
            .request()
            .input("Order_ID", sql.Int, Order_ID)
            .input("Reason", sql.VarChar, Reason)
            .input("Employee_ID", sql.Int, Employee_ID)
            .query("EXEC sp_CancelOrder @Order_ID, @Reason, @Employee_ID");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 16. Оплата заказов за период (sp_GetOrderPaymentsForPeriod)
// Принимает параметры даты через query string (например, ?StartDate=2023-01-01&EndDate=2023-01-31)
app.get("/api/reports/order-payments", verifyToken, async (req, res) => {
    try {
        const { StartDate, EndDate } = req.query;
        const pool = await poolPromise;
        const result = await pool
            .request()
            .input("StartDate", sql.Date, StartDate)
            .input("EndDate", sql.Date, EndDate)
            .query("EXEC sp_GetOrderPaymentsForPeriod @StartDate, @EndDate");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 17. Скидки по акциям (текущим) (sp_GetCurrentPromotionDiscounts)
app.get("/api/reports/current-promotions", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetCurrentPromotionDiscounts");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 18. Задолженности клиентов (sp_GetClientDebts)
app.get("/api/reports/client-debts", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetClientDebts");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 19. Отмененные заказы (sp_GetCanceledOrders)
app.get("/api/reports/canceled-orders", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetCanceledOrders");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 20. Продажи по товарам (sp_GetProductSales)
app.get("/api/reports/product-sales", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetProductSales");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 21. Заказы (спутанные) (sp_GetOrdersSummary)
app.get("/api/reports/orders-summary", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetOrdersSummary");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 22. Продажи по клиентам (sp_GetSalesByClients)
app.get("/api/reports/sales-by-clients", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetSalesByClients");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// 23. Продажи по складу (sp_GetSalesByWarehouse)
app.get("/api/reports/sales-by-warehouse", verifyToken, async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query("EXEC sp_GetSalesByWarehouse");
        res.status(200).json({ success: true, data: result.recordset });
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Запуск сервера
app.listen(PORT, () => console.log(`Server started on port ${PORT}`));
