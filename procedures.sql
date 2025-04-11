
CREATE PROCEDURE sp_GetClients
AS
BEGIN
    SELECT * FROM dbo.Client;
END
GO

------------------------------------------------------------------
-- 2. sp_GetClientById: Returns a client specified by Client_ID
------------------------------------------------------------------
CREATE PROCEDURE sp_GetClientById
    @Client_ID INT
AS
BEGIN
    SELECT * FROM dbo.Client WHERE Client_ID = @Client_ID;
END
GO

------------------------------------------------------------------
-- 3. sp_RegisterClient: Inserts a new client record into dbo.Client
------------------------------------------------------------------
CREATE PROCEDURE sp_RegisterClient
    @First_Name VARCHAR(45),
    @Last_Name VARCHAR(45),
    @Client_Type_ID INT,
    @Contacts_ID INT,
    @District_ID INT,
    @Discount FLOAT,
    @Registration_Date VARCHAR(45),
    @Workplace VARCHAR(45),
    @Position VARCHAR(45),
    @Passport_Number VARCHAR(45),
    @Login VARCHAR(45),
    @Password VARCHAR(100)
AS
BEGIN
    INSERT INTO dbo.Client 
        (Client_ID, First_Name, Last_Name, Client_Type_ID, Contacts_ID, District_ID, Discount, Registration_Date, Workplace, Position, Passport_Number, Login, Password)
    VALUES 
        ((SELECT ISNULL(MAX(Client_ID), 0) + 1 FROM dbo.Client),
         @First_Name, @Last_Name, @Client_Type_ID, @Contacts_ID, @District_ID, @Discount, @Registration_Date, @Workplace, @Position, @Passport_Number, @Login, @Password);
END
GO

------------------------------------------------------------------
-- 4. sp_AddClientContact: Inserts a new contact record into dbo.Contacts
------------------------------------------------------------------
CREATE PROCEDURE sp_AddClientContact
    @Contact_Info VARCHAR(45),
    @Contact_Type_ID INT
AS
BEGIN
    INSERT INTO dbo.Contacts (Contacts_ID, Contact_Info, Contact_Type_ID)
    VALUES (
        (SELECT ISNULL(MAX(Contacts_ID), 0) + 1 FROM dbo.Contacts),
        @Contact_Info,
        @Contact_Type_ID
    );
END
GO

------------------------------------------------------------------
-- 5. sp_GetEmployees: Returns all employees
------------------------------------------------------------------
CREATE PROCEDURE sp_GetEmployees
AS
BEGIN
    SELECT * FROM dbo.Employee;
END
GO

------------------------------------------------------------------
-- 6. sp_GetEmployeeById: Returns an employee by Employee_ID
------------------------------------------------------------------
CREATE PROCEDURE sp_GetEmployeeById
    @Employee_ID INT
AS
BEGIN
    SELECT * FROM dbo.Employee WHERE Employee_ID = @Employee_ID;
END
GO

------------------------------------------------------------------
-- 7. sp_RegisterEmployee: Inserts a new employee record into dbo.Employee
------------------------------------------------------------------
CREATE PROCEDURE sp_RegisterEmployee
    @First_Name VARCHAR(45),
    @Last_Name VARCHAR(45),
    @Registration_Date DATE,
    @Phone VARCHAR(45),
    @Login VARCHAR(45),
    @Password VARCHAR(45),
    @Position_ID INT
AS
BEGIN
    INSERT INTO dbo.Employee
        (Employee_ID, First_Name, Last_Name, Registration_Date, Phone, Login, Password, Position_ID)
    VALUES
        ((SELECT ISNULL(MAX(Employee_ID), 0) + 1 FROM dbo.Employee),
         @First_Name, @Last_Name, @Registration_Date, @Phone, @Login, @Password, @Position_ID);
END
GO

CREATE PROCEDURE sp_AuthenticateUser
    @userType VARCHAR(50),
    @login VARCHAR(45),
    @password VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF (@userType = 'client')
    BEGIN
        SELECT * 
        FROM dbo.Client 
        WHERE Login = @login AND Password = @password;
    END
    ELSE IF (@userType IN ('seller', 'purchasing_manager', 'accountant', 'administrator'))
    BEGIN
        SELECT * 
        FROM dbo.Employee 
        WHERE Login = @login AND Password = @password;
    END
    ELSE
    BEGIN
        -- Return an error record if the userType is not recognized.
        SELECT 'Invalid user type' AS Error;
    END
END
GO



------------------------------------------------------------------
-- 1. Точка безубыточного продажи товара
-- Колонки: Номер, Тип товара, Товар, Цена покупки, Цена продажи, Прибыль
------------------------------------------------------------------
CREATE PROCEDURE sp_GetBreakEvenPoint
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY p.Product_ID) AS [Номер],
        cat.Category_Name AS [Тип товара],
        p.Product_Name AS [Товар],
        sl.Price AS [Цена покупки],
        pl.Price AS [Цена продажи],
        (pl.Price - sl.Price) AS [Прибыль]
    FROM dbo.Product p
    JOIN dbo.Category cat ON p.Category_ID = cat.Category_ID
    LEFT JOIN dbo.Supply_List sl ON p.Product_ID = sl.Product_ID
    LEFT JOIN dbo.Price_List pl ON p.Product_ID = pl.Product_ID;
END
GO

------------------------------------------------------------------
-- 2. Поставки по поставщикам
-- Колонки: Номер, Дата, Поставщик, Тип товара, Товар, Кол-во, Цена, Склад
------------------------------------------------------------------
CREATE PROCEDURE sp_GetDeliveriesBySupplier
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY s.Supply_ID) AS [Номер],
        s.Supply_Date AS [Дата],
        sup.Company_Name AS [Поставщик],
        cat.Category_Name AS [Тип товара],
        p.Product_Name AS [Товар],
        sl.Quantity AS [Кол-во],
        sl.Price AS [Цена],
        w.Warehouse_Name AS [Склад]
    FROM dbo.Supply s
    JOIN dbo.Supplier sup ON s.Supplier_ID = sup.Supplier_ID
    JOIN dbo.Supply_List sl ON s.Supply_ID = sl.Supply_ID
    JOIN dbo.Product p ON sl.Product_ID = p.Product_ID
    JOIN dbo.Category cat ON p.Category_ID = cat.Category_ID
    JOIN dbo.Warehouse w ON sl.Warehouse_ID = w.Warehouse_ID;
END
GO

------------------------------------------------------------------
-- 3. Задолженность поставщиков
-- Колонки: Номер, Номер поставки, Поставщик, Сотрудник, Дедлайн, Сумма оплате, Задолженность
------------------------------------------------------------------
CREATE PROCEDURE sp_GetSupplierDebt
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY s.Supply_ID) AS [Номер],
        s.Supply_ID AS [Номер поставки],
        sup.Company_Name AS [Поставщик],
        'Employee Name' AS [Сотрудник], -- Заглушка, требуется источник данных
        DATEADD(day, 30, s.Supply_Date) AS [Дедлайн],
        ISNULL(SUM(sp.Amount), 0) AS [Сумма оплате],
        (
          (SELECT ISNULL(SUM(CAST(sl.Price AS INT) * CAST(sl.Quantity AS INT)), 0)
           FROM dbo.Supply_List sl 
           WHERE sl.Supply_ID = s.Supply_ID)
          - ISNULL(SUM(sp.Amount), 0)
        ) AS [Задолженность]
    FROM dbo.Supply s
    JOIN dbo.Supplier sup ON s.Supplier_ID = sup.Supplier_ID
    LEFT JOIN dbo.Supply_Payment sp ON s.Supply_ID = sp.Supply_ID
    GROUP BY s.Supply_ID, s.Supply_Date, sup.Company_Name;
END
GO

------------------------------------------------------------------
-- 4. Прибыльность товара по поставкам
-- Колонки: Номер, Тип товара, Товар, Цена покупки, Цена продажи, Номер поставки, Прибыль
------------------------------------------------------------------
CREATE PROCEDURE sp_GetSupplyProductProfit
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY s.Supply_ID) AS [Номер],
        cat.Category_Name AS [Тип товара],
        p.Product_Name AS [Товар],
        sl.Price AS [Цена покупки],
        pl.Price AS [Цена продажи],
        s.Supply_ID AS [Номер поставки],
        (pl.Price - sl.Price) AS [Прибыль]
    FROM dbo.Supply s
    JOIN dbo.Supply_List sl ON s.Supply_ID = sl.Supply_ID
    JOIN dbo.Product p ON sl.Product_ID = p.Product_ID
    JOIN dbo.Category cat ON p.Category_ID = cat.Category_ID
    LEFT JOIN dbo.Price_List pl ON p.Product_ID = pl.Product_ID;
END
GO

------------------------------------------------------------------
-- 5. Налоги
-- Колонки: Номер, Название налога, Сумма, Дата начала, Дата окончания
------------------------------------------------------------------
CREATE PROCEDURE sp_GetTaxes
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY Tax_ID) AS [Номер],
        [Name_] AS [Название налога],
        Tax_Rate AS [Сумма],
        GETDATE() AS [Дата начала],
        DATEADD(month, 1, GETDATE()) AS [Дата окончания]
    FROM dbo.Tax;
END
GO

------------------------------------------------------------------
-- 6. Зарплата сотрудников
-- Колонки: Номер, Дата, Начисленно, Оплачено, Должность сотрудник
------------------------------------------------------------------
CREATE PROCEDURE sp_GetSalaries
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY s.Salary_ID) AS [Номер],
        s.Salary_Date AS [Дата],
        s.Salary_Amount AS [Начисленно],
        s.Bonus AS [Оплачено], -- Заглушка – можно заменить на реальные данные оплаты
        (e.First_Name + ' ' + e.Last_Name) AS [Должность сотрудник]
    FROM dbo.Salary s
    JOIN dbo.Employee e ON s.Employee_ID = e.Employee_ID;
END
GO

------------------------------------------------------------------
-- 7. Продажи по акциям
-- Колонки: Номер, Акция, Заказ, Дата, Сумма
------------------------------------------------------------------
CREATE PROCEDURE sp_GetSalesByPromotions
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY o.Order_ID) AS [Номер],
        e.Event_Name AS [Акция],
        o.Order_ID AS [Заказ],
        o.Order_Date AS [Дата],
        (SELECT SUM(od.Discounted_Price * od.Quantity) 
         FROM dbo.Order_Details od 
         WHERE od.Order_ID = o.Order_ID) AS [Сумма]
    FROM dbo.Order_ o
    LEFT JOIN dbo.Discount d ON o.Discount_ID = d.Discount_ID
    LEFT JOIN dbo.Events e ON d.Event_ID = e.Event_ID;
END
GO

------------------------------------------------------------------
-- 8. Отчет о прибылях и убытках
-- Колонки: Номер, Расход, Доходы, Налоги, Прибыль
------------------------------------------------------------------
CREATE PROCEDURE sp_GetProfitLossReport
AS
BEGIN
    DECLARE @Revenue INT, @Expenses INT, @Taxes INT;
    SELECT @Revenue = ISNULL(SUM(Amount), 0) FROM dbo.Payment;
    SELECT @Expenses = ISNULL(SUM(Salary_Amount), 0) FROM dbo.Salary;
    SELECT @Taxes = ISNULL(SUM(Tax_Rate), 0) FROM dbo.Tax;
    SELECT 
        1 AS [Номер],
        @Expenses AS [Расход],
        @Revenue AS [Доходы],
        @Taxes AS [Налоги],
        (@Revenue - @Expenses - @Taxes) AS [Прибыль];
END
GO

------------------------------------------------------------------
-- 9. Оплата поставок
-- Колонки: Номер, Дата, Сумма, Поставщик, Сотрудник, Тип оплаты
------------------------------------------------------------------
CREATE PROCEDURE sp_GetSupplyPayments
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY sp.Supply_Payment_ID) AS [Номер],
        sp.[Date_] AS [Дата],
        sp.Amount AS [Сумма],
        sup.Company_Name AS [Поставщик],
        'Employee Name' AS [Сотрудник], -- Заглушка
        pt.[Payment_Type] AS [Тип оплаты]
    FROM dbo.Supply_Payment sp
    JOIN dbo.Supply s ON sp.Supply_ID = s.Supply_ID
    JOIN dbo.Supplier sup ON s.Supplier_ID = sup.Supplier_ID
    JOIN dbo.Payment_Type pt ON sp.Payment_Type_ID = pt.Payment_Type_ID;
END
GO

------------------------------------------------------------------
-- 10. Список бракованных товаров при поставке
-- Колонки: Номер, Дата поставки, Тип товаров, Товар, Количество, Цена, Поставщик
------------------------------------------------------------------
CREATE PROCEDURE sp_GetDefectiveProducts
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY pw.Product_WriteOff_ID) AS [Номер],
        s.Supply_Date AS [Дата поставки],
        cat.Category_Name AS [Тип товаров],
        p.Product_Name AS [Товар],
        pw.Quantity AS [Количество],
        sl.Price AS [Цена],
        sup.Company_Name AS [Поставщик]
    FROM dbo.Product_WriteOff pw
    JOIN dbo.Product p ON pw.Product_ID = p.Product_ID
    JOIN dbo.Category cat ON p.Category_ID = cat.Category_ID
    LEFT JOIN dbo.Supply_List sl ON p.Product_ID = sl.Product_ID
    LEFT JOIN dbo.Supply s ON sl.Supply_ID = s.Supply_ID
    LEFT JOIN dbo.Supplier sup ON s.Supplier_ID = sup.Supplier_ID;
END
GO

------------------------------------------------------------------
-- 11. Список товаров на складе (Отчет №5 Sales Manager)
-- Колонки: Номер, Тип товаров, Товар, Цена, Количество, Номер поставки, Номер склада
------------------------------------------------------------------
CREATE PROCEDURE sp_GetWarehouseProducts
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY sl.Supply_List_ID) AS [Номер],
        cat.Category_Name AS [Тип товаров],
        p.Product_Name AS [Товар],
        sl.Price AS [Цена],
        sl.Quantity AS [Количество],
        sl.Supply_ID AS [Номер поставки],
        sl.Warehouse_ID AS [Номер склада]
    FROM dbo.Supply_List sl
    JOIN dbo.Product p ON sl.Product_ID = p.Product_ID
    JOIN dbo.Category cat ON p.Category_ID = cat.Category_ID;
END
GO

------------------------------------------------------------------
-- 12. Прайс-лист
-- Колонки: Номер, Категория товара, Товар, Цена товара
------------------------------------------------------------------
CREATE PROCEDURE sp_GetPriceList
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY pl.Price_List_ID) AS [Номер],
        cat.Category_Name AS [Категория товара],
        p.Product_Name AS [Товар],
        pl.Price AS [Цена товара]
    FROM dbo.Price_List pl
    JOIN dbo.Product p ON pl.Product_ID = p.Product_ID
    JOIN dbo.Category cat ON p.Category_ID = cat.Category_ID;
END
GO

------------------------------------------------------------------
-- 13. Состав заказа (чек)
-- Колонки: № строки, Товар, Цена со скидкой, Количество, Стоимость
------------------------------------------------------------------
CREATE PROCEDURE sp_GetOrderComposition
AS
BEGIN
    SELECT 
        od.Order_Details_ID AS [№ строки],
        p.Product_Name AS [Товар],
        od.Discounted_Price AS [Цена со скидкой],
        od.Quantity AS [Количество],
        (od.Discounted_Price * od.Quantity) AS [Стоимость]
    FROM dbo.Order_Details od
    JOIN dbo.Supply_List sl ON od.Supply_List_ID = sl.Supply_List_ID
    JOIN dbo.Product p ON sl.Product_ID = p.Product_ID;
END
GO

------------------------------------------------------------------
-- 14. Заказы клиента
-- Колонки: № заказа, Дата, Стоимость, № накладной, Статус
------------------------------------------------------------------
CREATE PROCEDURE sp_GetClientOrders
AS
BEGIN
    SELECT 
        o.Order_ID AS [№ заказа],
        o.Order_Date AS [Дата],
        o.Comment AS [Стоимость],  -- заглушка; заменить на реальное поле стоимости, если есть
        o.Invoice_Number AS [№ накладной],
        os.[Order_Status] AS [Статус]
    FROM dbo.Order_ o
    JOIN dbo.Order_Status os ON o.Order_Status_ID = os.Order_Status_ID;
END
GO

------------------------------------------------------------------
-- 15. Форма отмены заказа
-- Принимает параметры: Order_ID, Reason, Employee_ID
------------------------------------------------------------------
CREATE PROCEDURE sp_CancelOrder
    @Order_ID INT,
    @Reason VARCHAR(255),
    @Employee_ID INT
AS
BEGIN
    UPDATE dbo.Order_
    SET Order_Status_ID = (
         SELECT TOP 1 Order_Status_ID 
         FROM dbo.Order_Status 
         WHERE [Order_Status] = 'Отменён'
         ORDER BY Order_Status_ID
         ),
        Comment = @Reason
    WHERE Order_ID = @Order_ID;

    SELECT * FROM dbo.Order_ WHERE Order_ID = @Order_ID;
END
GO

------------------------------------------------------------------
-- 16. Оплата заказов за период
-- Колонки: Номер, Дата заказа, Сумма к оплате, Сумма оплаты
------------------------------------------------------------------
CREATE PROCEDURE sp_GetOrderPaymentsForPeriod
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        o.Order_ID AS [Номер],
        o.Order_Date AS [Дата заказа],
        0 AS [Сумма к оплате],  -- заглушка – требуется логика расчёта
        (SELECT ISNULL(SUM(Amount), 0) FROM dbo.Payment WHERE Order_ID = o.Order_ID) AS [Сумма оплаты]
    FROM dbo.Order_ o
    WHERE o.Order_Date BETWEEN @StartDate AND @EndDate;
END
GO

------------------------------------------------------------------
-- 17. Скидки по акциям (текущим)
-- Колонки: Номер, Название акции, Скидка, Дата начала, Дата окончания
------------------------------------------------------------------
CREATE PROCEDURE sp_GetCurrentPromotionDiscounts
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY d.Discount_ID) AS [Номер],
        e.Event_Name AS [Название акции],
        d.Discount_Value AS [Скидка],
        GETDATE() AS [Дата начала],
        DATEADD(day, 10, GETDATE()) AS [Дата окончания]
    FROM dbo.Discount d
    LEFT JOIN dbo.Events e ON d.Event_ID = e.Event_ID;
END
GO

------------------------------------------------------------------
-- 18. Задолженности клиентов
-- Колонки: № заказа, Сумма к оплате, Фактическая сумма оплаты, Дата дедлайна платежа
------------------------------------------------------------------
CREATE PROCEDURE sp_GetClientDebts
AS
BEGIN
    SELECT 
        o.Order_ID AS [№ заказа],
        1000 AS [Сумма к оплате],         -- заглушка
        800 AS [Фактическая сумма оплаты], -- заглушка
        DATEADD(day, 30, o.Order_Date) AS [Дата дедлайна платежа]
    FROM dbo.Order_ o;
END
GO

------------------------------------------------------------------
-- 19. Отмененные заказы
-- Колонки: Номер заказа, Дата заказа, Причина отмены, Сотрудник, Тип оплаты
------------------------------------------------------------------
CREATE PROCEDURE sp_GetCanceledOrders
AS
BEGIN
    SELECT 
        o.Order_ID AS [Номер заказа],
        o.Order_Date AS [Дата заказа],
        o.Comment AS [Причина отмены],
        'Employee Name' AS [Сотрудник],  -- заглушка
        pt.[Payment_Type] AS [Тип оплаты]
    FROM dbo.Order_ o
    JOIN dbo.Order_Status os ON o.Order_Status_ID = os.Order_Status_ID
    LEFT JOIN dbo.Payment p ON o.Order_ID = p.Order_ID
    LEFT JOIN dbo.Payment_Type pt ON p.Payment_Type_ID = pt.Payment_Type_ID
    WHERE os.[Order_Status] = 'Отменён';
END
GO

------------------------------------------------------------------
-- 20. Продажи по товарам
-- Колонки: Номер, Тип товара, Товар, Цена, Кол-во
------------------------------------------------------------------
CREATE PROCEDURE sp_GetProductSales
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY p.Product_ID) AS [Номер],
        cat.Category_Name AS [Тип товара],
        p.Product_Name AS [Товар],
        sl.Price AS [Цена],
        od.Quantity AS [Кол-во]
    FROM dbo.Order_Details od
    JOIN dbo.Supply_List sl ON od.Supply_List_ID = sl.Supply_List_ID
    JOIN dbo.Product p ON sl.Product_ID = p.Product_ID
    JOIN dbo.Category cat ON p.Category_ID = cat.Category_ID;
END
GO

------------------------------------------------------------------
-- 21. Заказы
-- Колонки: Номер, Дата, Состояние, Тип заказа, К оплате
------------------------------------------------------------------
CREATE PROCEDURE sp_GetOrdersSummary
AS
BEGIN
    SELECT 
        o.Order_ID AS [Номер],
        o.Order_Date AS [Дата],
        os.[Order_Status] AS [Состояние],
        ot.[Order_Type] AS [Тип заказа],
        0 AS [К оплате]  -- заглушка
    FROM dbo.Order_ o
    JOIN dbo.Order_Status os ON o.Order_Status_ID = os.Order_Status_ID
    JOIN dbo.Order_Type ot ON o.Order_Type_ID = ot.Order_Type_ID;
END
GO

------------------------------------------------------------------
-- 22. Продажи по клиентам
-- Колонки: Номер, ФИО, Оплачено, Скидка клиента, Акция
------------------------------------------------------------------
CREATE PROCEDURE sp_GetSalesByClients
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY c.Client_ID) AS [Номер],
        (c.First_Name + ' ' + c.Last_Name) AS [ФИО],
        (SELECT ISNULL(SUM(Amount), 0) FROM dbo.Payment WHERE Order_ID = o.Order_ID) AS [Оплачено],
        c.Discount AS [Скидка клиента],
        e.Event_Name AS [Акция]
    FROM dbo.Order_ o
    JOIN dbo.Client c ON o.Client_ID = c.Client_ID
    LEFT JOIN dbo.Discount d ON o.Discount_ID = d.Discount_ID
    LEFT JOIN dbo.Events e ON d.Event_ID = e.Event_ID;
END
GO

------------------------------------------------------------------
-- 23. Продажи по складу
-- Колонки: Номер, Тип товара, Товар, Цена, Количество
------------------------------------------------------------------
CREATE PROCEDURE sp_GetSalesByWarehouse
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY sl.Supply_List_ID) AS [Номер],
        cat.Category_Name AS [Тип товара],
        p.Product_Name AS [Товар],
        sl.Price AS [Цена],
        sl.Quantity AS [Количество]
    FROM dbo.Supply_List sl
    JOIN dbo.Product p ON sl.Product_ID = p.Product_ID
    JOIN dbo.Category cat ON p.Category_ID = cat.Category_ID;
END
GO
