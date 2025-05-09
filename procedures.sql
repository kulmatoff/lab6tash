USE flowers_db_2025;
GO
/*──────────────────────────────────────────────────────────────
  0.  Helper scalar functions (no schema changes required)
──────────────────────────────────────────────────────────────*/
CREATE FUNCTION dbo.fn__ClientTypeId()
RETURNS INT
AS
BEGIN
    RETURN (SELECT id_contragent_type
            FROM   dbo.contragent_type
            WHERE  contragent_type=N'Client');
END;
GO

CREATE FUNCTION dbo.fn__SupplierTypeId()
RETURNS INT
AS
BEGIN
    RETURN (SELECT id_contragent_type
            FROM   dbo.contragent_type
            WHERE  contragent_type=N'Supplier');
END;
GO

/*================================================================
  1.  CLIENT–RELATED PROCEDURES
================================================================*/
CREATE PROCEDURE dbo.sp_GetClients
AS
BEGIN
    SELECT *
    FROM dbo.contragent
    WHERE contragent_type_id = dbo.fn__ClientTypeId();
END;
GO

CREATE PROCEDURE dbo.sp_GetClientById
    @Client_ID INT
AS
BEGIN
    SELECT *
    FROM dbo.contragent
    WHERE id_contragent     = @Client_ID
      AND contragent_type_id= dbo.fn__ClientTypeId();
END;
GO

CREATE PROCEDURE dbo.sp_RegisterClient
    @First_Name     NVARCHAR(45),
    @Middle_Name    NVARCHAR(45)=NULL,
    @Last_Name      NVARCHAR(45),
    @District_ID    INT,
    @Discount       DECIMAL(5,2)=0,
    @Reg_Date       DATE        =NULL,
    @Org_Name       NVARCHAR(45)=NULL,
    @Position       NVARCHAR(45)=NULL,
    @Passport_Num   NVARCHAR(45)=NULL,
    @Login          NVARCHAR(45),
    @Password       NVARCHAR(100),
    @Phone          NVARCHAR(45)=NULL
AS
BEGIN
    INSERT dbo.contragent
          (first_name,middle_name,last_name,org_name,
           passport_num,position,login_,pw,
           reg_date,pers_discount,phone,
           contragent_type_id,district_id_district)
    VALUES(@First_Name,@Middle_Name,@Last_Name,@Org_Name,
           @Passport_Num,@Position,@Login,@Password,
           ISNULL(@Reg_Date,SYSDATETIME()),@Discount,@Phone,
           dbo.fn__ClientTypeId(),@District_ID);

    SELECT SCOPE_IDENTITY() AS NewClientID;
END;
GO

CREATE PROCEDURE dbo.sp_AddClientContact
    @Client_ID INT,
    @Phone     NVARCHAR(45)
AS
BEGIN
    IF NOT EXISTS (SELECT 1
                   FROM dbo.contragent
                   WHERE id_contragent=@Client_ID
                     AND contragent_type_id=dbo.fn__ClientTypeId())
    BEGIN
        RAISERROR(N'Client not found',16,1);
        RETURN;
    END;

    UPDATE dbo.contragent
       SET phone = CONCAT_WS(N'; ',phone,@Phone)
     WHERE id_contragent=@Client_ID;
END;
GO

/*================================================================
  2.  EMPLOYEE PROCEDURES
================================================================*/
CREATE PROCEDURE dbo.sp_GetEmployees
AS
BEGIN
    SELECT * FROM dbo.employee;
END;
GO

CREATE PROCEDURE dbo.sp_GetEmployeeById
    @Employee_ID INT
AS
BEGIN
    SELECT * FROM dbo.employee WHERE id_employee=@Employee_ID;
END;
GO

CREATE PROCEDURE dbo.sp_RegisterEmployee
    @First_Name   NVARCHAR(45),
    @Middle_Name  NVARCHAR(45)=NULL,
    @Last_Name    NVARCHAR(45),
    @Phone        NVARCHAR(45),
    @Login        NVARCHAR(45),
    @Password     NVARCHAR(45),
    @Position_ID  INT
AS
BEGIN
    INSERT dbo.employee
          (first_name,middle_name,last_name,reg_date,
           emp_phone,emp_login,emp_password,positions_id)
    VALUES(@First_Name,@Middle_Name,@Last_Name,
           SYSDATETIME(),@Phone,@Login,@Password,@Position_ID);

    SELECT SCOPE_IDENTITY() AS NewEmployeeID;
END;
GO

/*================================================================
  3.  AUTHENTICATION
================================================================*/
CREATE PROCEDURE dbo.sp_AuthenticateUser
    @userType NVARCHAR(50),
    @login    NVARCHAR(45),
    @password NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF LOWER(@userType)=N'client'
    BEGIN
        SELECT *
        FROM dbo.contragent
        WHERE login_=@login
          AND pw=@password
          AND contragent_type_id=dbo.fn__ClientTypeId();
        RETURN;
    END;

    DECLARE @PosName NVARCHAR(45)=
        CASE LOWER(@userType)
            WHEN N'administrator'       THEN N'Administrator'
            WHEN N'seller'              THEN N'Seller'
            WHEN N'purchasing_manager'  THEN N'Purchasing Manager'
            WHEN N'accountant'          THEN N'Accountant'
        END;

    IF @PosName IS NULL
    BEGIN
        RAISERROR(N'Invalid userType',16,1);
        RETURN;
    END;

    SELECT e.*
    FROM   dbo.employee  e
    JOIN   dbo.positions p ON e.positions_id=p.id_positions
    WHERE  e.emp_login   =@login
      AND  e.emp_password=@password
      AND  p.position    =@PosName;
END;
GO

/*================================================================
  4.  BREAK-EVEN REPORT
================================================================*/
CREATE PROCEDURE dbo.sp_GetBreakEvenPoint
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH buy AS (
        SELECT g.id_goods,
               ol.price_with_discount AS buy_price,
               ROW_NUMBER() OVER(PARTITION BY g.id_goods
                                 ORDER BY o.operation_date DESC) AS rn
        FROM   dbo.goods g
        JOIN   dbo.operation_list ol ON g.id_goods      =ol.goods_id
        JOIN   dbo.operations     o  ON ol.operations_id=o.id_operations
        WHERE  o.operation_type_id=(SELECT id_operation_type
                                    FROM dbo.operation_type
                                    WHERE operation_type=N'Purchase')
    )
    SELECT ROW_NUMBER() OVER(ORDER BY g.id_goods)       AS [Номер],
           gc.goods_category                            AS [Тип товара],
           g.goods_name                                 AS [Товар],
           ISNULL(b.buy_price,0)                        AS [Цена покупки],
           pl.price_value                               AS [Цена продажи],
           pl.price_value-ISNULL(b.buy_price,0)         AS [Прибыль]
    FROM   dbo.goods g
    JOIN   dbo.goods_category gc ON g.goods_category_id=gc.id_goods_category
    LEFT JOIN dbo.price_list pl  ON g.id_goods=pl.goods_id
    LEFT JOIN buy b              ON g.id_goods=b.id_goods AND b.rn=1;
END;
GO

/*================================================================
  5.  DELIVERIES BY SUPPLIER
================================================================*/
CREATE PROCEDURE dbo.sp_GetDeliveriesBySupplier
AS
BEGIN
    SET NOCOUNT ON;

    SELECT ROW_NUMBER() OVER (ORDER BY o.id_operations) AS [Номер],
           o.operation_date                             AS [Дата],
           sup.org_name                                 AS [Поставщик],
           gc.goods_category                            AS [Тип товара],
           g.goods_name                                 AS [Товар],
           ol.quantity                                  AS [Кол-во],
           ol.price_with_discount                       AS [Цена],
           w.warehouse_name                             AS [Склад]
    FROM   dbo.operations     o
    JOIN   dbo.operation_type ot ON o.operation_type_id=ot.id_operation_type
    JOIN   dbo.contragent     sup ON o.contragent_id  =sup.id_contragent
    JOIN   dbo.operation_list ol  ON o.id_operations  =ol.operations_id
    JOIN   dbo.goods          g   ON ol.goods_id      =g.id_goods
    JOIN   dbo.goods_category gc  ON g.goods_category_id=gc.id_goods_category
    JOIN   dbo.warehouse      w   ON ol.warehouse_id  =w.id_warehouse
    WHERE  ot.operation_type=N'Purchase';
END;
GO

/*================================================================
  6.  SUPPLIER DEBT
================================================================*/
CREATE PROCEDURE dbo.sp_GetSupplierDebt
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH purch AS (
        SELECT o.id_operations,
               o.contragent_id,
               SUM(ol.quantity*ol.price_with_discount) AS purchase_sum
        FROM dbo.operations o
        JOIN dbo.operation_type ot ON o.operation_type_id=ot.id_operation_type
        JOIN dbo.operation_list ol ON o.id_operations=ol.operations_id
        WHERE ot.operation_type=N'Purchase'
        GROUP BY o.id_operations,o.contragent_id,o.operation_date
    ),
    pay AS (
        SELECT operations_id,
               SUM(payment_sum) AS paid
        FROM dbo.payments
        GROUP BY operations_id
    )
    SELECT ROW_NUMBER() OVER(ORDER BY p.id_operations)        AS [Номер],
           p.id_operations                                    AS [Номер поставки],
           s.org_name                                         AS [Поставщик],
           DATEADD(day,30,o.operation_date)                   AS [Дедлайн],
           ISNULL(py.paid,0)                                  AS [Сумма оплате],
           p.purchase_sum-ISNULL(py.paid,0)                   AS [Задолженность]
    FROM   purch p
    JOIN   dbo.operations o ON p.id_operations=o.id_operations
    JOIN   dbo.contragent s ON p.contragent_id=s.id_contragent
    LEFT   JOIN pay py      ON p.id_operations=py.operations_id;
END;
GO

/*================================================================
  7.  SUPPLY PRODUCT PROFIT
================================================================*/
CREATE PROCEDURE dbo.sp_GetSupplyProductProfit
AS
BEGIN
    ;WITH retail AS (
        SELECT goods_id, MAX(price_value) AS retail
        FROM dbo.price_list
        GROUP BY goods_id)
    SELECT ROW_NUMBER() OVER(ORDER BY o.id_operations) AS [Номер],
           gc.goods_category                            AS [Тип товара],
           g.goods_name                                 AS [Товар],
           ol.price_with_discount                       AS [Цена покупки],
           r.retail                                     AS [Цена продажи],
           o.id_operations                              AS [Номер поставки],
           r.retail-ol.price_with_discount              AS [Прибыль]
    FROM   dbo.operations o
    JOIN   dbo.operation_type ot ON o.operation_type_id=ot.id_operation_type
    JOIN   dbo.operation_list ol ON o.id_operations=ol.operations_id
    JOIN   dbo.goods          g  ON ol.goods_id=g.id_goods
    JOIN   dbo.goods_category gc ON g.goods_category_id=gc.id_goods_category
    LEFT   JOIN retail r         ON g.id_goods=r.goods_id
    WHERE  ot.operation_type=N'Purchase';
END;
GO

/*================================================================
  8.  TAX LIST
================================================================*/
CREATE PROCEDURE dbo.sp_GetTaxes
AS
BEGIN
    SELECT ROW_NUMBER() OVER(ORDER BY id_taxes) AS [Номер],
           tax_name                             AS [Название налога],
           tax_rate                             AS [Ставка %],
           CAST(GETDATE() AS date)              AS [Дата начала],
           DATEADD(month,1,GETDATE())           AS [Дата окончания]
    FROM dbo.taxes;
END;
GO

/*================================================================
  9.  SALARIES (earning_payments)
================================================================*/
CREATE PROCEDURE dbo.sp_GetSalaries
AS
BEGIN
    SELECT ROW_NUMBER() OVER(ORDER BY ep.id_earning_payments) AS [Номер],
           ep.earning_date									  AS [Дата],
           ep.earning_amount								  AS [Начислено],
           CONCAT(e.first_name,' ',e.last_name)               AS [Сотрудник],
           rt.reason_type                                     AS [Основание]
    FROM dbo.earning_payments ep
    JOIN dbo.employee       e  ON ep.employee_id   =e.id_employee
    JOIN dbo.reason_type    rt ON ep.reason_type_id=rt.id_reason_type;
END;
GO

/*================================================================
 10.  PRICE LIST
================================================================*/
CREATE PROCEDURE dbo.sp_GetPriceList
AS
BEGIN
    SELECT ROW_NUMBER() OVER(ORDER BY pl.id_price_list)   AS [Номер],
           gc.goods_category                              AS [Категория товара],
           g.goods_name                                   AS [Товар],
           pl.price_value                                 AS [Цена товара]
    FROM dbo.price_list pl
    JOIN dbo.goods g           ON pl.goods_id=g.id_goods
    JOIN dbo.goods_category gc ON g.goods_category_id=gc.id_goods_category;
END;
GO

/*================================================================
 11.  WAREHOUSE PRODUCTS
================================================================*/
CREATE PROCEDURE dbo.sp_GetWarehouseProducts
AS
BEGIN
    SELECT ROW_NUMBER() OVER(ORDER BY ol.id_operation_list) AS [Номер],
           gc.goods_category                                AS [Тип товаров],
           g.goods_name                                     AS [Товар],
           ol.price_with_discount                           AS [Цена],
           ol.quantity                                      AS [Количество],
           o.id_operations                                  AS [Номер поставки],
           w.warehouse_name                                 AS [Склад]
    FROM   dbo.operation_list ol
    JOIN   dbo.operations o     ON ol.operations_id=o.id_operations
    JOIN   dbo.operation_type ot ON o.operation_type_id=ot.id_operation_type
    JOIN   dbo.goods g          ON ol.goods_id=g.id_goods
    JOIN   dbo.goods_category gc ON g.goods_category_id=gc.id_goods_category
    JOIN   dbo.warehouse w      ON ol.warehouse_id=w.id_warehouse
    WHERE  ot.operation_type=N'Purchase';
END;
GO

/*--------- remainder in warehouse (in – out) -------------------*/
CREATE PROCEDURE dbo.sp_GetWarehouseProductRemainders
AS
BEGIN
    ;WITH stock_in AS (
        SELECT ol.goods_id,ol.warehouse_id,
               SUM(ol.quantity) AS qty_in
        FROM dbo.operation_list ol
        JOIN dbo.operations     o ON ol.operations_id=o.id_operations
        WHERE o.operation_type_id=
              (SELECT id_operation_type FROM dbo.operation_type WHERE operation_type=N'Purchase')
        GROUP BY ol.goods_id,ol.warehouse_id),
    stock_out AS (
        SELECT ol.goods_id,ol.warehouse_id,
               SUM(ol.quantity) AS qty_out
        FROM dbo.operation_list ol
        JOIN dbo.operations     o ON ol.operations_id=o.id_operations
        WHERE o.operation_type_id=
              (SELECT id_operation_type FROM dbo.operation_type WHERE operation_type=N'Sale')
        GROUP BY ol.goods_id,ol.warehouse_id)
    SELECT ROW_NUMBER() OVER(ORDER BY w.warehouse_name,g.goods_name) AS [Номер],
           gc.goods_category                                          AS [Тип товаров],
           g.goods_name                                               AS [Товар],
           si.qty_in                                                  AS [Поставлено],
           ISNULL(so.qty_out,0)                                       AS [Продано],
           si.qty_in-ISNULL(so.qty_out,0)                             AS [Остаток],
           w.warehouse_name                                           AS [Склад]
    FROM stock_in si
    JOIN dbo.goods g            ON si.goods_id=g.id_goods
    JOIN dbo.goods_category gc  ON g.goods_category_id=gc.id_goods_category
    JOIN dbo.warehouse w        ON si.warehouse_id=w.id_warehouse
    LEFT JOIN stock_out so      ON si.goods_id=so.goods_id
                               AND si.warehouse_id=so.warehouse_id;
END;
GO

/*================================================================
 12.  DEFECTIVE PRODUCTS
================================================================*/
CREATE PROCEDURE dbo.sp_GetDefectiveProducts
AS
BEGIN
    SELECT ROW_NUMBER() OVER(ORDER BY wo.id_write_off_list) AS [Номер],
           o.operation_date                                 AS [Дата поставки],
           gc.goods_category                                AS [Тип товаров],
           g.goods_name                                     AS [Товар],
           wo.write_off_amount                              AS [Количество],
           ol.price_with_discount                           AS [Цена],
           sup.org_name                                     AS [Поставщик]
    FROM dbo.write_off_list wo
    JOIN dbo.operation_list ol ON wo.operation_list_id=ol.id_operation_list
    JOIN dbo.operations o      ON ol.operations_id        =o.id_operations
    JOIN dbo.contragent sup    ON o.contragent_id         =sup.id_contragent
    JOIN dbo.goods g           ON ol.goods_id             =g.id_goods
    JOIN dbo.goods_category gc ON g.goods_category_id     =gc.id_goods_category
    WHERE wo.write_off_type_id=
          (SELECT id_write_off_type FROM dbo.write_off_type WHERE write_off_type=N'Defect');
END;
GO

/*================================================================
 13.  SUPPLY PAYMENTS
================================================================*/
CREATE PROCEDURE dbo.sp_GetSupplyPayments
AS
BEGIN
    SELECT ROW_NUMBER() OVER(ORDER BY pay.id_payments)     AS [Номер],
           pay.payment_date                                AS [Дата],
           pay.payment_sum                                 AS [Сумма],
           sup.org_name                                    AS [Поставщик],
           emp.first_name+N' '+emp.last_name               AS [Сотрудник],
           pt.payment_type                                 AS [Тип оплаты]
    FROM dbo.payments pay
    JOIN dbo.operations o      ON pay.operations_id=o.id_operations
    JOIN dbo.contragent sup    ON o.contragent_id=sup.id_contragent
    LEFT JOIN dbo.employee emp ON o.employee_id=emp.id_employee
    JOIN dbo.payment_type pt   ON pay.payment_type_id=pt.id_payment_type
    WHERE o.operation_type_id=
          (SELECT id_operation_type FROM dbo.operation_type WHERE operation_type=N'Purchase');
END;
GO

/*================================================================
 14.  SALES BY PROMOTIONS
================================================================*/
CREATE PROCEDURE dbo.sp_GetSalesByPromotions
AS
BEGIN
    ;WITH promo AS (
        SELECT o.id_operations,
               pr.promotion_name,
               o.operation_date,
               SUM(ol.quantity*ol.price_with_discount) AS total
        FROM dbo.operations o
        JOIN dbo.operation_type ot ON o.operation_type_id=ot.id_operation_type
        JOIN dbo.operation_list ol ON o.id_operations   =ol.operations_id
		JOIN dbo.price_list pl ON pl.goods_id = ol.goods_id
        LEFT JOIN dbo.promotions pr ON pl.promotions_id =pr.id_promotions
        WHERE ot.operation_type=N'Sale'
        GROUP BY o.id_operations,pr.promotion_name,o.operation_date)
    SELECT ROW_NUMBER() OVER(ORDER BY id_operations)      AS [Номер],
           promotion_name                                 AS [Акция],
           id_operations                                  AS [Заказ],
           operation_date                                 AS [Дата],
           total                                          AS [Сумма]
    FROM promo;
END;
GO

/*================================================================
 15.  ORDERS SUMMARY
================================================================*/
CREATE PROCEDURE dbo.sp_GetOrdersSummary
AS
BEGIN
    ;WITH due AS (
        SELECT operations_id,SUM(price_with_discount*quantity) AS total_due
        FROM dbo.operation_list
        GROUP BY operations_id)
    SELECT o.id_operations                     AS [Номер],
           o.operation_date                    AS [Дата],
           os.operation_status                 AS [Состояние],
           ot.operation_type                   AS [Тип заказа],
           d.total_due                         AS [К оплате]
    FROM dbo.operations o
    JOIN dbo.operation_status os ON o.operation_status_id=os.id_operation_status
    JOIN dbo.operation_type   ot ON o.operation_type_id  =ot.id_operation_type
    LEFT JOIN due d               ON o.id_operations     =d.operations_id
    WHERE ot.operation_type=N'Sale';
END;
GO

/*================================================================
 16.  PRODUCT SALES (aggregated)
================================================================*/
CREATE PROCEDURE dbo.sp_GetProductSales
AS
BEGIN
    SELECT ROW_NUMBER() OVER(ORDER BY g.id_goods)          AS [Номер],
           gc.goods_category                               AS [Тип товара],
           g.goods_name                                    AS [Товар],
           AVG(ol.price_with_discount)                     AS [Средняя цена],
           SUM(ol.quantity)                                AS [Кол-во]
    FROM dbo.operation_list ol
    JOIN dbo.operations o       ON ol.operations_id=o.id_operations
    JOIN dbo.goods g            ON ol.goods_id=g.id_goods
    JOIN dbo.goods_category gc  ON g.goods_category_id=gc.id_goods_category
    WHERE o.operation_type_id=
          (SELECT id_operation_type FROM dbo.operation_type WHERE operation_type=N'Sale')
    GROUP BY g.id_goods,g.goods_name,gc.goods_category;
END;
GO

/*================================================================
 17.  SALES BY WAREHOUSE
================================================================*/
CREATE PROCEDURE dbo.sp_GetSalesByWarehouse
AS
BEGIN
    SELECT ROW_NUMBER() OVER(ORDER BY w.id_warehouse)      AS [Номер],
           gc.goods_category                               AS [Тип товара],
           g.goods_name                                    AS [Товар],
           ol.price_with_discount                          AS [Цена],
           ol.quantity                                     AS [Количество],
           w.warehouse_name                                AS [Склад]
    FROM dbo.operation_list ol
    JOIN dbo.operations o       ON ol.operations_id=o.id_operations
    JOIN dbo.goods g            ON ol.goods_id=g.id_goods
    JOIN dbo.goods_category gc  ON g.goods_category_id=gc.id_goods_category
    JOIN dbo.warehouse w        ON ol.warehouse_id=w.id_warehouse
    WHERE o.operation_type_id=
          (SELECT id_operation_type FROM dbo.operation_type WHERE operation_type=N'Sale');
END;
GO

/*================================================================
 18.  ORDER COMPOSITION
================================================================*/
CREATE PROCEDURE dbo.sp_GetOrderComposition
    @Client_ID INT,
    @Order_ID  INT
AS
BEGIN
    IF NOT EXISTS(SELECT 1
                  FROM dbo.operations
                  WHERE id_operations=@Order_ID
                    AND contragent_id=@Client_ID
                    AND operation_type_id=
                        (SELECT id_operation_type
                         FROM dbo.operation_type
                         WHERE operation_type=N'Sale'))
    BEGIN
        RAISERROR(N'Order not found for this client',16,1);
        RETURN;
    END;

    SELECT ol.id_operation_list                         AS [№ строки],
           g.goods_name                                 AS [Товар],
           ol.price_with_discount                       AS [Цена со скидкой],
           ol.quantity                                  AS [Количество],
           ol.price_with_discount*ol.quantity           AS [Стоимость]
    FROM dbo.operation_list ol
    JOIN dbo.goods g ON ol.goods_id=g.id_goods
    WHERE ol.operations_id=@Order_ID;
END;
GO

/*================================================================
 19.  CLIENT ORDERS (single + all)
================================================================*/
CREATE PROCEDURE dbo.sp_GetClientOrders
    @Client_ID INT
AS
BEGIN
    ;WITH paid AS (
        SELECT operations_id,SUM(payment_sum) AS paid
        FROM dbo.payments
        GROUP BY operations_id)
    SELECT o.id_operations                       AS [№ заказа],
           o.operation_date                      AS [Дата],
           ISNULL(paid.paid,0)                   AS [Оплачено],
           o.doc_num                             AS [Док №],
           os.operation_status                   AS [Статус]
    FROM dbo.operations o
    JOIN dbo.operation_status os ON o.operation_status_id=os.id_operation_status
    LEFT JOIN paid               ON o.id_operations=paid.operations_id
    WHERE o.contragent_id=@Client_ID
      AND o.operation_type_id=
          (SELECT id_operation_type FROM dbo.operation_type WHERE operation_type=N'Sale');
END;
GO

CREATE PROCEDURE dbo.sp_GetAllClientOrders
AS
BEGIN
    ;WITH paid AS (
        SELECT operations_id,SUM(payment_sum) AS paid
        FROM dbo.payments
        GROUP BY operations_id)
    SELECT o.id_operations                     AS [№ заказа],
           o.operation_date                    AS [Дата],
           ISNULL(paid.paid,0)                 AS [Оплачено],
           o.doc_num                           AS [Док №],
           os.operation_status                 AS [Статус],
           c.first_name+N' '+c.last_name       AS [Клиент]
    FROM dbo.operations o
    JOIN dbo.contragent c        ON o.contragent_id=c.id_contragent
    JOIN dbo.operation_status os ON o.operation_status_id=os.id_operation_status
    LEFT JOIN paid               ON o.id_operations=paid.operations_id
    WHERE o.operation_type_id=
          (SELECT id_operation_type FROM dbo.operation_type WHERE operation_type=N'Sale');
END;
GO

/*================================================================
 20.  CANCEL ORDER
================================================================*/
CREATE PROCEDURE dbo.sp_CancelOrder
    @Order_ID INT,
    @Reason   NVARCHAR(255)
AS
BEGIN
    UPDATE dbo.operations
       SET operation_status_id=
            (SELECT id_operation_status
             FROM dbo.operation_status
             WHERE operation_status=N'Cancelled'),
           comments=@Reason
     WHERE id_operations=@Order_ID
       AND operation_type_id=
           (SELECT id_operation_type FROM dbo.operation_type WHERE operation_type=N'Sale');

    SELECT * FROM dbo.operations WHERE id_operations=@Order_ID;
END;
GO

/*================================================================
 21.  ORDER PAYMENTS FOR PERIOD
================================================================*/
CREATE PROCEDURE dbo.sp_GetOrderPaymentsForPeriod
    @StartDate DATE,
    @EndDate   DATE
AS
BEGIN
    ;WITH due AS (
        SELECT operations_id,SUM(price_with_discount*quantity) AS due_total
        FROM dbo.operation_list
        GROUP BY operations_id),
    paid AS (
        SELECT operations_id,SUM(payment_sum) AS paid_total
        FROM dbo.payments
        GROUP BY operations_id)
    SELECT o.id_operations                     AS [Номер],
           o.operation_date                    AS [Дата заказа],
           d.due_total                         AS [Сумма к оплате],
           ISNULL(p.paid_total,0)              AS [Сумма оплаты]
    FROM dbo.operations o
    JOIN due d  ON o.id_operations=d.operations_id
    LEFT JOIN paid p ON o.id_operations=p.operations_id
    WHERE o.operation_date BETWEEN @StartDate AND @EndDate
      AND o.operation_type_id=
          (SELECT id_operation_type FROM dbo.operation_type WHERE operation_type=N'Sale');
END;
GO

/*================================================================
 22.  CURRENT PROMOTION DISCOUNTS
================================================================*/
CREATE PROCEDURE dbo.sp_GetCurrentPromotionDiscounts
AS
BEGIN
    SELECT ROW_NUMBER() OVER(ORDER BY id_promotions)     AS [Номер],
           promotion_name                                AS [Название акции],
           discount_value                                AS [Скидка],
           promotion_date_start                          AS [Дата начала],
           promotion_date_end                            AS [Дата окончания]
    FROM dbo.promotions
    WHERE GETDATE() BETWEEN promotion_date_start AND promotion_date_end;
END;
GO

/*================================================================
 23.  CLIENT DEBTS
================================================================*/
CREATE PROCEDURE dbo.sp_GetClientDebts
AS
BEGIN
    ;WITH due AS (
        SELECT operations_id,SUM(price_with_discount*quantity) AS due_total
        FROM dbo.operation_list
        GROUP BY operations_id),
    paid AS (
        SELECT operations_id,SUM(payment_sum) AS paid_total
        FROM dbo.payments
        GROUP BY operations_id)
    SELECT o.id_operations                     AS [№ заказа],
           d.due_total                         AS [Сумма к оплате],
           ISNULL(p.paid_total,0)              AS [Фактическая сумма оплаты],
           DATEADD(day,30,o.operation_date)    AS [Дата дедлайна]
    FROM dbo.operations o
    JOIN due d  ON o.id_operations=d.operations_id
    LEFT JOIN paid p ON o.id_operations=p.operations_id
    WHERE o.operation_type_id=
          (SELECT id_operation_type FROM dbo.operation_type WHERE operation_type=N'Sale')
      AND d.due_total>ISNULL(p.paid_total,0);
END;
GO

CREATE PROCEDURE dbo.sp_AddOrderPayment
    @Order_ID        INT,
    @Amount          DECIMAL(18,2),
    @Payment_Type_ID INT,
    @Comment         NVARCHAR(255)=NULL
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM dbo.operations
                  WHERE id_operations=@Order_ID
                    AND operation_type_id=
                        (SELECT id_operation_type
                         FROM dbo.operation_type
                         WHERE operation_type=N'Sale'))
    BEGIN
        RAISERROR(N'Order not found',16,1);
        RETURN;
    END;

    INSERT dbo.payments(payment_date,payment_sum,payment_comments,
                        operations_id,payment_type_id)
    VALUES(SYSDATETIME(),@Amount,@Comment,@Order_ID,@Payment_Type_ID);

    SELECT * FROM dbo.payments WHERE operations_id=@Order_ID;
END;
GO

/*================================================================
 24.  CANCELED ORDERS
================================================================*/
CREATE PROCEDURE dbo.sp_GetCanceledOrders
AS
BEGIN
    SELECT o.id_operations                       AS [Номер заказа],
           o.operation_date                      AS [Дата заказа],
           o.comments                            AS [Причина отмены],
           pt.payment_type                       AS [Тип оплаты]
    FROM dbo.operations o
    JOIN dbo.operation_status os ON o.operation_status_id=os.id_operation_status
    LEFT JOIN dbo.payments pay    ON o.id_operations=pay.operations_id
    LEFT JOIN dbo.payment_type pt ON pay.payment_type_id=pt.id_payment_type
    WHERE os.operation_status=N'Cancelled'
      AND o.operation_type_id=
          (SELECT id_operation_type FROM dbo.operation_type WHERE operation_type=N'Sale');
END;
GO

/*================================================================
 25.  SALES BY CLIENTS
================================================================*/
CREATE PROCEDURE dbo.sp_GetSalesByClients
AS
BEGIN
    ;WITH pay AS (
        SELECT operations_id,SUM(payment_sum) AS paid
        FROM dbo.payments
        GROUP BY operations_id)
    SELECT ROW_NUMBER() OVER(ORDER BY c.id_contragent)     AS [Номер],
           c.first_name+N' '+c.last_name                   AS [ФИО],
           ISNULL(pay.paid,0)                              AS [Оплачено],
           c.pers_discount                                 AS [Скидка клиента],
           pr.promotion_name                               AS [Акция]
    FROM dbo.operations o
    JOIN dbo.contragent c ON o.contragent_id=c.id_contragent
    LEFT JOIN pay ON o.id_operations=pay.operations_id
    LEFT JOIN dbo.operation_list ol ON o.id_operations=ol.operations_id
	LEFT JOIN dbo.price_list pl ON pl.goods_id = ol.goods_id
    LEFT JOIN dbo.promotions pr     ON pl.promotions_id   =pr.id_promotions
    WHERE o.operation_type_id=
          (SELECT id_operation_type FROM dbo.operation_type WHERE operation_type=N'Sale');
END;
GO

/*================================================================
 26.  PROFIT / LOSS REPORT
================================================================*/
CREATE PROCEDURE dbo.sp_GetProfitLossReport
AS
BEGIN
    /* Revenue: money received on sales */
    DECLARE @Revenue DECIMAL(18,2)=
        (SELECT ISNULL(SUM(p.payment_sum),0)
         FROM dbo.payments p
         JOIN dbo.operations o ON p.operations_id=o.id_operations
         WHERE o.operation_type_id=
               (SELECT id_operation_type FROM dbo.operation_type WHERE operation_type=N'Sale'));

    /* COGS: money paid on purchases */
    DECLARE @COGS DECIMAL(18,2)=
        (SELECT ISNULL(SUM(p.payment_sum),0)
         FROM dbo.payments p
         JOIN dbo.operations o ON p.operations_id=o.id_operations
         WHERE o.operation_type_id=
               (SELECT id_operation_type FROM dbo.operation_type WHERE operation_type=N'Purchase'));

    /* Salaries (expenses) */
    DECLARE @Salaries DECIMAL(18,2)=
        (SELECT ISNULL(SUM(earning_amount),0)
         FROM dbo.earning_payments);

    /* Taxes (demo – sum of rates) */
    DECLARE @Taxes DECIMAL(18,2)=
        (SELECT ISNULL(SUM(tax_rate),0) FROM dbo.taxes);

    SELECT 1                         AS [Номер],
           @COGS+@Salaries           AS [Расходы],
           @Revenue                  AS [Доходы],
           @Taxes                    AS [Налоги],
           @Revenue-@COGS-@Salaries-@Taxes AS [Прибыль];
END;
GO
