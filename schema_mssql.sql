/*============================================================
  Inventory / Flower-Store DB
  SQL Server 2019+ (works on Azure SQL DB too)
============================================================
IF DB_ID(N'flowers_db_2025') IS NOT NULL
    DROP DATABASE flowers_db_2025;
GO
CREATE DATABASE flowers_db_2025;
GO
USE flowers_db_2025;
GO*/


/*-------------------------------------------------------------
  CREATE a login + user with full rights in flowers_db_2025
-------------------------------------------------------------
USE master;
GO
CREATE LOGIN [flower_admin]                 -- change the name if you wish
WITH  PASSWORD = N'pass',           -- << choose a strong password
      CHECK_POLICY = ON,                    -- enforces Windows password rules
      CHECK_EXPIRATION = OFF;               -- set ON if you want it to expire
GO*/

/* Map the login to a user in the target database 
USE flowers_db_2025;
GO
CREATE USER  [flower_admin] FOR LOGIN [flower_admin];
ALTER ROLE db_owner ADD MEMBER [flower_admin];   -- full rights in this DB
GO
*/
/* Optional: give the login power over the whole instance   */
/* EXEC sp_addsrvrolemember 'flower_admin', 'sysadmin'; */


/* ----------  DICTIONARY TABLES  ---------- */
CREATE TABLE dbo.contragent_type (
    id_contragent_type INT IDENTITY(1,1) PRIMARY KEY,
    contragent_type    NVARCHAR(45) NOT NULL
);

CREATE TABLE dbo.district (
    id_district INT IDENTITY(1,1) PRIMARY KEY,
    district    NVARCHAR(45) NOT NULL
);

CREATE TABLE dbo.positions (
    id_positions INT IDENTITY(1,1) PRIMARY KEY,
    position     NVARCHAR(45) NOT NULL
);

CREATE TABLE dbo.operation_type (
    id_operation_type INT IDENTITY(1,1) PRIMARY KEY,
    operation_type    NVARCHAR(45) NOT NULL
);

CREATE TABLE dbo.operation_status (
    id_operation_status INT IDENTITY(1,1) PRIMARY KEY,
    operation_status    NVARCHAR(45) NOT NULL
);

CREATE TABLE dbo.payment_type (
    id_payment_type INT IDENTITY(1,1) PRIMARY KEY,
    payment_type    NVARCHAR(45) NOT NULL
);

CREATE TABLE dbo.reason_type (
    id_reason_type INT IDENTITY(1,1) PRIMARY KEY,
    reason_type    NVARCHAR(45) NOT NULL
);

CREATE TABLE dbo.write_off_type (
    id_write_off_type INT IDENTITY(1,1) PRIMARY KEY,
    write_off_type    NVARCHAR(45) NOT NULL
);

CREATE TABLE dbo.goods_category (
    id_goods_category INT IDENTITY(1,1) PRIMARY KEY,
    goods_category    NVARCHAR(45) NOT NULL
);

CREATE TABLE dbo.warehouse (
    id_warehouse   INT IDENTITY(1,1) PRIMARY KEY,
    warehouse_name NVARCHAR(45) NOT NULL
);

CREATE TABLE dbo.event_type (
    id_event_type INT IDENTITY(1,1) PRIMARY KEY,
    event_type    NVARCHAR(45) NOT NULL
);

CREATE TABLE dbo.user_type (
    id_user_type INT IDENTITY(1,1) PRIMARY KEY,
    user_type    NVARCHAR(45) NOT NULL
);

CREATE TABLE dbo.taxes (
    id_taxes  INT IDENTITY(1,1) PRIMARY KEY,
    tax_name  NVARCHAR(45),
    tax_rate  DECIMAL(5,2)   -- e.g. 12.50 %
);

/* ----------  CORE ENTITIES  ---------- */
CREATE TABLE dbo.contragent (
    id_contragent            INT IDENTITY(1,1) PRIMARY KEY,
    first_name               NVARCHAR(45),
    middle_name              NVARCHAR(45),
    last_name                NVARCHAR(45),
    org_name                 NVARCHAR(45),
    passport_num             NVARCHAR(45),
    position                 NVARCHAR(45),
    login_                   NVARCHAR(45),
    pw                       NVARCHAR(45),
    reg_date                 DATE,
    pers_discount            DECIMAL(5,2),
    phone                    NVARCHAR(45),
    contragent_type_id       INT            NOT NULL,
    district_id_district     INT            NOT NULL,
    CONSTRAINT FK_contragent_type
        FOREIGN KEY (contragent_type_id)   REFERENCES dbo.contragent_type (id_contragent_type),
    CONSTRAINT FK_contragent_district
        FOREIGN KEY (district_id_district) REFERENCES dbo.district        (id_district)
);

CREATE TABLE dbo.employee (
    id_employee         INT IDENTITY(1,1) PRIMARY KEY,
    first_name          NVARCHAR(45),
    middle_name         NVARCHAR(45),
    last_name           NVARCHAR(45),
    reg_date            DATE,
    emp_login           NVARCHAR(45),
    emp_password        NVARCHAR(45),
    emp_phone           NVARCHAR(45),
    emp_month_salary    DECIMAL(18,2),
    positions_id        INT NOT NULL,
    CONSTRAINT FK_employee_position
        FOREIGN KEY (positions_id) REFERENCES dbo.positions (id_positions)
);

/* ----------  TRANSACTION HEADERS  ---------- */
CREATE TABLE dbo.operations (
    id_operations             INT IDENTITY(1,1) PRIMARY KEY,
    operation_date            DATE,
    doc_num                   NVARCHAR(45),
    comments                  NVARCHAR(45),
    contragent_id             INT NOT NULL,
    operation_type_id         INT NOT NULL,
    employee_id               INT NOT NULL,
    operation_status_id       INT NOT NULL,
    CONSTRAINT FK_ops_contragent  FOREIGN KEY (contragent_id)       REFERENCES dbo.contragent      (id_contragent),
    CONSTRAINT FK_ops_type        FOREIGN KEY (operation_type_id)   REFERENCES dbo.operation_type  (id_operation_type),
    CONSTRAINT FK_ops_employee    FOREIGN KEY (employee_id)         REFERENCES dbo.employee        (id_employee),
    CONSTRAINT FK_ops_status      FOREIGN KEY (operation_status_id) REFERENCES dbo.operation_status(id_operation_status)
);

/* ----------  TRANSACTION LINES  ---------- */
CREATE TABLE dbo.goods (
    id_goods            INT IDENTITY(1,1) PRIMARY KEY,
    goods_name          NVARCHAR(45) NOT NULL,
    goods_comments      NVARCHAR(245),
    goods_category_id   INT NOT NULL,
    CONSTRAINT FK_goods_category FOREIGN KEY (goods_category_id)
        REFERENCES dbo.goods_category (id_goods_category)
);

CREATE TABLE dbo.operation_list (
    id_operation_list INT IDENTITY(1,1) PRIMARY KEY,
    quantity          INT,
    price_with_discount DECIMAL(18,2),
    operations_id     INT NOT NULL,
    goods_id          INT NOT NULL,
    warehouse_id      INT NOT NULL,
    CONSTRAINT FK_oplist_head  FOREIGN KEY (operations_id) REFERENCES dbo.operations (id_operations),
    CONSTRAINT FK_oplist_goods FOREIGN KEY (goods_id)      REFERENCES dbo.goods      (id_goods),
    CONSTRAINT FK_oplist_wh    FOREIGN KEY (warehouse_id)  REFERENCES dbo.warehouse  (id_warehouse)
);

/* ----------  PAYMENTS  ---------- */
CREATE TABLE dbo.payments (
    id_payments      INT IDENTITY(1,1) PRIMARY KEY,
    payment_date     DATE,
    payment_sum      DECIMAL(18,2),
    payment_comments NVARCHAR(45),
    operations_id    INT NOT NULL,
    payment_type_id  INT NOT NULL,
    CONSTRAINT FK_pay_ops  FOREIGN KEY (operations_id)   REFERENCES dbo.operations   (id_operations),
    CONSTRAINT FK_pay_type FOREIGN KEY (payment_type_id) REFERENCES dbo.payment_type (id_payment_type)
);

/* ----------  WRITE-OFFS  ---------- */
CREATE TABLE dbo.write_off_list (
    id_write_off_list INT IDENTITY(1,1) PRIMARY KEY,
    write_off_amount  DECIMAL(18,2),
    operation_list_id INT NOT NULL,
    write_off_type_id INT NOT NULL,
    write_off_date    DATE,
    write_off_comments NVARCHAR(245),
    CONSTRAINT FK_wo_line FOREIGN KEY (operation_list_id) REFERENCES dbo.operation_list (id_operation_list),
    CONSTRAINT FK_wo_type FOREIGN KEY (write_off_type_id) REFERENCES dbo.write_off_type (id_write_off_type)
);

/* ----------  PROMOTIONS / PRICING  ---------- */
CREATE TABLE dbo.promotions (
    id_promotions        INT IDENTITY(1,1) PRIMARY KEY,
    promotion_name       NVARCHAR(45),
    discount_value       DECIMAL(5,2),
    promotion_comment    NVARCHAR(45),
    promotion_date_start DATE,
    promotion_date_end   DATE,
    event_type_id        INT,
    CONSTRAINT FK_promo_event FOREIGN KEY (event_type_id) REFERENCES dbo.event_type (id_event_type)
);

CREATE TABLE dbo.price_list (
    id_price_list INT IDENTITY(1,1) PRIMARY KEY,
    price_value   DECIMAL(18,2) NOT NULL,
    goods_id      INT NOT NULL,
    promotions_id INT NULL,
    CONSTRAINT FK_price_goods FOREIGN KEY (goods_id)     REFERENCES dbo.goods      (id_goods),
    CONSTRAINT FK_price_promo FOREIGN KEY (promotions_id)REFERENCES dbo.promotions (id_promotions)
);

/* ----------  PAY-OUTS TO STAFF  ---------- */
CREATE TABLE dbo.earning_payments (
    id_earning_payments  INT IDENTITY(1,1) PRIMARY KEY,
    earning_amount       DECIMAL(18,2),
    earning_date         DATE,
    earning_comment      NVARCHAR(45),
    employee_id          INT NOT NULL,
    reason_type_id       INT NOT NULL,
    CONSTRAINT FK_ep_emp    FOREIGN KEY (employee_id)    REFERENCES dbo.employee    (id_employee),
    CONSTRAINT FK_ep_reason FOREIGN KEY (reason_type_id) REFERENCES dbo.reason_type (id_reason_type)
);

/* ----------  REPORTS  ---------- */
CREATE TABLE dbo.reports (
    id_reports    INT IDENTITY(1,1) PRIMARY KEY,
    id_user       INT NULL,          -- adjust when real user table exists
    report_date   DATETIME2,
    report_link   NVARCHAR(MAX),
    user_type_id  INT NOT NULL,
    CONSTRAINT FK_reports_ut FOREIGN KEY (user_type_id) REFERENCES dbo.user_type (id_user_type)
);

/* ----------  HELPER INDICES  ---------- */
CREATE INDEX IX_operations_date       ON dbo.operations      (operation_date);
CREATE INDEX IX_operation_list_goods  ON dbo.operation_list  (goods_id);
CREATE INDEX IX_payments_date         ON dbo.payments        (payment_date);
CREATE INDEX IX_price_list_goods      ON dbo.price_list      (goods_id);
GO
