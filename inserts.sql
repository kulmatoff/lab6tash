USE baias;
GO

-------------------------------------------
-- Insert Data into Lookup Tables
-------------------------------------------
-- Client_Type
INSERT INTO dbo.Client_Type (Client_Type_ID, Client_Type)
VALUES (1, 'Regular');
GO

-- Contact_Type
INSERT INTO dbo.Contact_Type (Contact_Type_ID, Contact_Type_Name)
VALUES 
  (1, 'Email'),
  (2, 'Phone');
GO

-- District
INSERT INTO dbo.District (District_ID, District)
VALUES 
  (1, 'Central'),
  (2, 'North');
GO

-- Position
INSERT INTO dbo.Position (Position_ID, Position_Name)
VALUES 
  (1, 'Administrator'),
  (2, 'Seller'),
  (3, 'Purchasing Manager'),
  (4, 'Accountant');
GO

-- Order_Type
INSERT INTO dbo.Order_Type (Order_Type_ID, Order_Type)
VALUES (1, 'Online');
GO

-- Discount_Type
INSERT INTO dbo.Discount_Type (Discount_Type_ID, Event_Name)
VALUES (1, 'Promo');
GO

-- Event_Type
INSERT INTO dbo.Event_Type (Event_Type_ID, Event_Type_Name)
VALUES (1, 'Seasonal');
GO

-- Events
INSERT INTO dbo.Events (Event_ID, Event_Name, Event_Type_ID, Comment)
VALUES (1, 'Spring Sale', 1, 'Discount 10%');
GO

-- Discount
INSERT INTO dbo.Discount (Discount_ID, Discount_Value, Discount_Type_ID, Event_ID)
VALUES (1, 10, 1, 1);
GO

-- Order_Status
INSERT INTO dbo.Order_Status (Order_Status_ID, Order_Status)
VALUES 
  (1, 'Active'),
  (2, 'Canceled');
GO

-- Payment_Type
INSERT INTO dbo.Payment_Type (Payment_Type_ID, Payment_Type)
VALUES 
  (1, 'Credit Card'),
  (2, 'Cash');
GO

-- Category
INSERT INTO dbo.Category (Category_ID, Category_Name)
VALUES 
  (1, 'Electronics'),
  (2, 'Clothing');
GO

-- Supply_Type
INSERT INTO dbo.Supply_Type (Supply_Type_ID, Supply_Type)
VALUES (1, 'Regular');
GO

-- Payout_Type
INSERT INTO dbo.Payout_Type (Payout_Type_ID, Payout_Type_Name)
VALUES (1, 'Monthly');
GO

-------------------------------------------
-- Insert Data for Contacts, Clients & Employees
-------------------------------------------

-- Contacts (for Client)
INSERT INTO dbo.Contacts (Contacts_ID, Contact_Info, Contact_Type_ID)
VALUES (1, 'client@example.com', 1);
GO

-- Client (login: client / password: client)
INSERT INTO dbo.Client 
  (Client_ID, First_Name, Last_Name, Client_Type_ID, Contacts_ID, District_ID, Discount, Registration_Date, Workplace, Position, Passport_Number, Login, Password)
VALUES 
  (1, 'Client', 'Client', 1, 1, 1, 0, '2025-04-11', 'ClientCorp', 'Customer', 'AA000111', 'client', 'client');
GO

-- Employees:
-- Administrator (login: admin / password: admin)
INSERT INTO dbo.Employee
  (Employee_ID, First_Name, Last_Name, Registration_Date, Phone, Login, Password, Position_ID)
VALUES 
  (1, 'Alice', 'Admin', '2025-04-11', '1111111111', 'admin', 'admin', 1);
GO

-- Seller (login: sales / password: sales)
INSERT INTO dbo.Employee
  (Employee_ID, First_Name, Last_Name, Registration_Date, Phone, Login, Password, Position_ID)
VALUES 
  (2, 'Bob', 'Sales', '2025-04-11', '2222222222', 'sales', 'sales', 2);
GO

-- Purchasing Manager (login: purchasing_manager / password: purchasing_manager)
INSERT INTO dbo.Employee
  (Employee_ID, First_Name, Last_Name, Registration_Date, Phone, Login, Password, Position_ID)
VALUES 
  (3, 'Charlie', 'PM', '2025-04-11', '3333333333', 'purchasing_manager', 'purchasing_manager', 3);
GO

-- Accountant (login: accountant / password: accountant)
INSERT INTO dbo.Employee
  (Employee_ID, First_Name, Last_Name, Registration_Date, Phone, Login, Password, Position_ID)
VALUES 
  (4, 'Diana', 'Accountant', '2025-04-11', '4444444444', 'accountant', 'accountant', 4);
GO
