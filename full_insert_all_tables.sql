/* ============================================================
   SEED DATA  – run on a *brand-new* flowers_db_2025 database
   ============================================================ */
USE flowers_db_2025;
GO
/*──────────────────────────────────────────────────────────────
  SECTION A – DICTIONARY TABLES  (unchanged from your draft)
──────────────────────────────────────────────────────────────*/
SET IDENTITY_INSERT dbo.contragent_type ON;
INSERT dbo.contragent_type (id_contragent_type, contragent_type) VALUES
(1,N'Client'), (2,N'Supplier');
SET IDENTITY_INSERT dbo.contragent_type OFF;
GO

SET IDENTITY_INSERT dbo.district ON;
INSERT dbo.district (id_district,district) VALUES
(1,N'North'), (2,N'South');
SET IDENTITY_INSERT dbo.district OFF;
GO

SET IDENTITY_INSERT dbo.positions ON;
INSERT dbo.positions (id_positions,position) VALUES
(1,N'Administrator'), (2,N'Seller'),
(3,N'Purchasing Manager'), (4,N'Accountant');
SET IDENTITY_INSERT dbo.positions OFF;
GO

SET IDENTITY_INSERT dbo.operation_type ON;
INSERT dbo.operation_type (id_operation_type,operation_type) VALUES
(1,N'Purchase'), (2,N'Sale');
SET IDENTITY_INSERT dbo.operation_type OFF;
GO

SET IDENTITY_INSERT dbo.operation_status ON;
INSERT dbo.operation_status (id_operation_status,operation_status) VALUES
(1,N'Completed'), (2,N'Pending'), (3,N'Cancelled');
SET IDENTITY_INSERT dbo.operation_status OFF;
GO

SET IDENTITY_INSERT dbo.payment_type ON;
INSERT dbo.payment_type (id_payment_type,payment_type) VALUES
(1,N'Cash'), (2,N'Card');
SET IDENTITY_INSERT dbo.payment_type OFF;
GO

SET IDENTITY_INSERT dbo.reason_type ON;
INSERT dbo.reason_type (id_reason_type,reason_type) VALUES
(1,N'Bonus'), (2,N'Penalty');
SET IDENTITY_INSERT dbo.reason_type OFF;
GO

SET IDENTITY_INSERT dbo.write_off_type ON;
INSERT dbo.write_off_type (id_write_off_type,write_off_type) VALUES
(1,N'Defect'), (2,N'Expired');
SET IDENTITY_INSERT dbo.write_off_type OFF;
GO

SET IDENTITY_INSERT dbo.goods_category ON;
INSERT dbo.goods_category (id_goods_category,goods_category) VALUES
(1,N'Flowers'), (2,N'Trees');
SET IDENTITY_INSERT dbo.goods_category OFF;
GO

SET IDENTITY_INSERT dbo.warehouse ON;
INSERT dbo.warehouse (id_warehouse,warehouse_name) VALUES
(1,N'Central WH'), (2,N'Backup WH');
SET IDENTITY_INSERT dbo.warehouse OFF;
GO

SET IDENTITY_INSERT dbo.event_type ON;
INSERT dbo.event_type (id_event_type,event_type) VALUES
(1,N'Seasonal'), (2,N'Clearance');
SET IDENTITY_INSERT dbo.event_type OFF;
GO

SET IDENTITY_INSERT dbo.user_type ON;
INSERT dbo.user_type (id_user_type,user_type) VALUES
(1,N'Admin'), (2,N'Employee'), (3,N'Client');
SET IDENTITY_INSERT dbo.user_type OFF;
GO

SET IDENTITY_INSERT dbo.taxes ON;
INSERT dbo.taxes (id_taxes,tax_name,tax_rate) VALUES
(1,N'VAT',12.00), (2,N'Import Duty',5.00);
SET IDENTITY_INSERT dbo.taxes OFF;
GO


/*──────────────────────────────────────────────────────────────
  SECTION B – MASTER DATA & DEMO TRANSACTIONS
──────────────────────────────────────────────────────────────*/
----------------------------------------------------------------
-- 1. CONTRAGENTS  (1 Client, 1 Supplier)
----------------------------------------------------------------
SET IDENTITY_INSERT dbo.contragent ON;
INSERT dbo.contragent (id_contragent,first_name,last_name,org_name,
                       passport_num,position,login_,pw,
                       reg_date,pers_discount,phone,
                       contragent_type_id,district_id_district)
VALUES
(1,N'Iris', N'Buyer',  N'-',            N'P-CL001',N'-',       N'cli1', N'p@ss',
     '2025-05-01',5.0,N'+996700111001',1,1),
(2,N'Green',N'Supply', N'GreenPlant LLC',N'P-SP001',N'Director',N'sup1', N'p@ss',
     '2025-05-01',0,  N'+996770222002',2,2);
SET IDENTITY_INSERT dbo.contragent OFF;
GO

----------------------------------------------------------------
-- 2. EMPLOYEES  (one record per position)
----------------------------------------------------------------
SET IDENTITY_INSERT dbo.employee ON;
INSERT dbo.employee (id_employee,first_name,last_name,reg_date,
                     emp_login,emp_password,emp_phone,
                     emp_month_salary,positions_id)
VALUES
(1,N'Anna',  N'Admin',   '2025-05-01',N'admin', N'admin123', N'+996555000001',1500,1),
(2,N'Sam',   N'Seller',  '2025-05-01',N'seller',N'sell123',  N'+996555000002', 900,2),
(3,N'Paul',  N'Buyer',   '2025-05-01',N'pmgr',  N'pmgr123',  N'+996555000003',1100,3),
(4,N'Claire',N'Account', '2025-05-01',N'acc',   N'acc123',   N'+996555000004',1200,4);
SET IDENTITY_INSERT dbo.employee OFF;
GO

----------------------------------------------------------------
-- 3. GOODS & PRICING
----------------------------------------------------------------
SET IDENTITY_INSERT dbo.goods ON;
INSERT dbo.goods (id_goods,goods_name,goods_comments,goods_category_id) VALUES
(1,N'Rose Bouquet',N'12 red roses',1),
(2,N'Apple Sapling',N'Dwarf variety',2);
SET IDENTITY_INSERT dbo.goods OFF;
GO

INSERT dbo.promotions (promotion_name,discount_value,promotion_comment,
                       promotion_date_start,promotion_date_end,event_type_id)
VALUES
(N'Spring-Sale',10.00,N'-10 % in May','2025-05-01','2025-05-31',1);

INSERT dbo.price_list (price_value,goods_id,promotions_id) VALUES
(25.00,1,NULL),
(15.00,2,1);
GO

----------------------------------------------------------------
-- 4. PURCHASE  (OP 1)  +  SUPPLIER PAYMENT
----------------------------------------------------------------
SET IDENTITY_INSERT dbo.operations ON;
INSERT dbo.operations (id_operations,operation_date,doc_num,comments,
                       contragent_id,operation_type_id,
                       employee_id,operation_status_id)
VALUES
(1,'2025-05-05',N'PO-0001',N'Initial stock',2,1,3,1);
SET IDENTITY_INSERT dbo.operations OFF;

SET IDENTITY_INSERT dbo.operation_list ON;
INSERT dbo.operation_list (id_operation_list,quantity,price_with_discount,
                           operations_id,goods_id,warehouse_id)
VALUES
(1,20,18.00,1,1,1),          -- 20 bouquets @18
(2,10, 8.00,1,2,1);          -- 10 saplings  @8
SET IDENTITY_INSERT dbo.operation_list OFF;

SET IDENTITY_INSERT dbo.payments ON;
INSERT dbo.payments (id_payments,payment_date,payment_sum,payment_comments,
                     operations_id,payment_type_id)
VALUES
(1,'2025-05-06',360.00,N'Full payment',1,1);
SET IDENTITY_INSERT dbo.payments OFF;
GO

----------------------------------------------------------------
-- 5. SALE  (OP 2)  +  CLIENT PAYMENT
----------------------------------------------------------------
SET IDENTITY_INSERT dbo.operations ON;
INSERT dbo.operations (id_operations,operation_date,doc_num,comments,
                       contragent_id,operation_type_id,
                       employee_id,operation_status_id)
VALUES
(2,'2025-05-07',N'SO-0001',N'Walk-in sale',1,2,2,1);
SET IDENTITY_INSERT dbo.operations OFF;

SET IDENTITY_INSERT dbo.operation_list ON;
INSERT dbo.operation_list (id_operation_list,quantity,price_with_discount,
                           operations_id,goods_id,warehouse_id)
VALUES
(3,2,25.00,2,1,1),          -- 2 bouquets @25
(4,1,13.50,2,2,1);          -- 1 sapling @15 –10 % promo
SET IDENTITY_INSERT dbo.operation_list OFF;

SET IDENTITY_INSERT dbo.payments ON;
INSERT dbo.payments (id_payments,payment_date,payment_sum,payment_comments,
                     operations_id,payment_type_id)
VALUES
(2,'2025-05-07',63.50,N'POS terminal',2,2);
SET IDENTITY_INSERT dbo.payments OFF;
GO

----------------------------------------------------------------
-- 6. WRITE-OFF (damage)  – refers to purchase line 1
----------------------------------------------------------------
SET IDENTITY_INSERT dbo.write_off_list ON;
INSERT dbo.write_off_list (id_write_off_list,write_off_amount,operation_list_id,
                           write_off_type_id,write_off_date,write_off_comments)
VALUES
(1,18.00,1,1,'2025-05-08',N'Broken stem');
SET IDENTITY_INSERT dbo.write_off_list OFF;
GO

----------------------------------------------------------------
-- 7. PAYOUTS  – bonus for every employee type
----------------------------------------------------------------
SET IDENTITY_INSERT dbo.earning_payments ON;
INSERT dbo.earning_payments (id_earning_payments,earning_amount,earning_date,
                             earning_comment,employee_id,reason_type_id)
VALUES
(1,200.00,'2025-05-08',N'Admin monthly',     1,1),
(2,120.00,'2025-05-08',N'Seller bonus',      2,1),
(3,150.00,'2025-05-08',N'PurchMgr bonus',    3,1),
(4,180.00,'2025-05-08',N'Accountant bonus',  4,1);
SET IDENTITY_INSERT dbo.earning_payments OFF;
GO

----------------------------------------------------------------
-- 8. SAMPLE REPORT ROW
----------------------------------------------------------------
SET IDENTITY_INSERT dbo.reports ON;
INSERT dbo.reports (id_reports,id_user,report_date,report_link,user_type_id) VALUES
(1,1,'2025-05-09',N'/reports/daily-sales-2025-05-09.pdf',1);
SET IDENTITY_INSERT dbo.reports OFF;
GO

/*──────────────────────────────────────────────────────────────
  Done!  ► All stored-procedures now return at least one row.
──────────────────────────────────────────────────────────────*/
