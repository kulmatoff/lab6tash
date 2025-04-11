-- Create database and set context
--CREATE DATABASE baias;
USE baias;

-- Table: Client_Type
CREATE TABLE dbo.Client_Type (
    Client_Type_ID INT NOT NULL PRIMARY KEY,
    Client_Type VARCHAR(45) NOT NULL
);

-- Table: Contact_Type
CREATE TABLE dbo.Contact_Type (
    Contact_Type_ID INT NOT NULL PRIMARY KEY,
    Contact_Type_Name VARCHAR(45) NOT NULL
);

-- Table: Contacts
CREATE TABLE dbo.Contacts (
    Contacts_ID INT NOT NULL PRIMARY KEY,
    Contact_Info VARCHAR(45) NULL,
    Contact_Type_ID INT NOT NULL,
    CONSTRAINT fk_Contacts_Contact_Type1 FOREIGN KEY (Contact_Type_ID)
        REFERENCES dbo.Contact_Type(Contact_Type_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Table: District
CREATE TABLE dbo.District (
    District_ID INT NOT NULL PRIMARY KEY,
    District VARCHAR(45) NOT NULL
);

-- Table: Client
CREATE TABLE dbo.Client (
    Client_ID INT NOT NULL PRIMARY KEY,
    First_Name VARCHAR(45) NOT NULL,
    Last_Name VARCHAR(45) NOT NULL,
    Client_Type_ID INT NOT NULL,
    Contacts_ID INT NOT NULL,
    District_ID INT NOT NULL,
    Discount FLOAT NULL,
    Registration_Date VARCHAR(45) NULL,
    Workplace VARCHAR(45) NULL,
    Position VARCHAR(45) NULL,
    Passport_Number VARCHAR(45) NULL,
    Login VARCHAR(45) NULL,
    Password VARCHAR(100) NULL,
    CONSTRAINT fk_Client_Client_Type1 FOREIGN KEY (Client_Type_ID)
        REFERENCES dbo.Client_Type(Client_Type_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_Client_Contacts1 FOREIGN KEY (Contacts_ID)
        REFERENCES dbo.Contacts(Contacts_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_Client_District1 FOREIGN KEY (District_ID)
        REFERENCES dbo.District(District_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Table: Order_Type
CREATE TABLE dbo.Order_Type (
    Order_Type_ID INT NOT NULL PRIMARY KEY,
    Order_Type VARCHAR(45) NOT NULL
);

-- Table: Discount_Type
CREATE TABLE dbo.Discount_Type (
    Discount_Type_ID INT NOT NULL PRIMARY KEY,
    Event_Name VARCHAR(45) NOT NULL
);

-- Table: Event_Type
CREATE TABLE dbo.Event_Type (
    Event_Type_ID INT NOT NULL PRIMARY KEY,
    Event_Type_Name VARCHAR(100) NULL
);

-- Table: Events
CREATE TABLE dbo.Events (
    Event_ID INT NOT NULL PRIMARY KEY,
    Event_Name VARCHAR(45) NULL,
    Event_Type_ID INT NOT NULL,
    Comment VARCHAR(45) NULL,
    CONSTRAINT fk_Events_Event_Type1 FOREIGN KEY (Event_Type_ID)
        REFERENCES dbo.Event_Type(Event_Type_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Table: Discount
CREATE TABLE dbo.Discount (
    Discount_ID INT NOT NULL PRIMARY KEY,
    Discount_Value FLOAT NOT NULL,
    Discount_Type_ID INT NOT NULL,
    Event_ID INT NOT NULL,
    CONSTRAINT fk_Discount_Discount_Type1 FOREIGN KEY (Discount_Type_ID)
        REFERENCES dbo.Discount_Type(Discount_Type_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_Discount_Events1 FOREIGN KEY (Event_ID)
        REFERENCES dbo.Events(Event_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Table: Order_Status
CREATE TABLE dbo.Order_Status (
    Order_Status_ID INT NOT NULL PRIMARY KEY,
    Order_Status VARCHAR(45) NOT NULL
);

-- Table: Position
CREATE TABLE dbo.Position (
    Position_ID INT NOT NULL PRIMARY KEY,
    Position_Name VARCHAR(45) NOT NULL
);

-- Table: Employee
CREATE TABLE dbo.Employee (
    Employee_ID INT NOT NULL PRIMARY KEY,
    First_Name VARCHAR(45) NOT NULL,
    Last_Name VARCHAR(45) NOT NULL,
    Registration_Date DATE NULL,
    Phone VARCHAR(45) NULL,
    Login VARCHAR(45) NULL,
    Password VARCHAR(45) NULL,
    Position_ID INT NOT NULL,
    CONSTRAINT fk_Employee_Position1 FOREIGN KEY (Position_ID)
        REFERENCES dbo.Position(Position_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Table: Order_
CREATE TABLE dbo.Order_ (
    Order_ID INT NOT NULL PRIMARY KEY,
    Client_ID INT NOT NULL,
    Order_Type_ID INT NOT NULL,
    Discount_ID INT NOT NULL,
    Order_Status_ID INT NOT NULL,
    Order_Date DATE NULL,
    Invoice_Number VARCHAR(45) NULL,
    Comment VARCHAR(45) NULL,
    Employee_ID INT NOT NULL,
    CONSTRAINT fk_Order_Client1 FOREIGN KEY (Client_ID)
        REFERENCES dbo.Client(Client_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_Order_Order_Type1 FOREIGN KEY (Order_Type_ID)
        REFERENCES dbo.Order_Type(Order_Type_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_Order_Discount1 FOREIGN KEY (Discount_ID)
        REFERENCES dbo.Discount(Discount_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_Order_Order_Status1 FOREIGN KEY (Order_Status_ID)
        REFERENCES dbo.Order_Status(Order_Status_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_Order_Employee1 FOREIGN KEY (Employee_ID)
        REFERENCES dbo.Employee(Employee_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Table: Payment_Type
CREATE TABLE dbo.Payment_Type (
    Payment_Type_ID INT NOT NULL PRIMARY KEY,
    Payment_Type VARCHAR(45) NOT NULL
);

-- Table: Payment
CREATE TABLE dbo.Payment (
    Payment_ID INT NOT NULL PRIMARY KEY,
    Payment_Type_ID INT NOT NULL,
    Amount INT NULL,
    Date_ DATE NULL,
    Comment VARCHAR(45) NULL,
    Order_ID INT NOT NULL,
    CONSTRAINT fk_Payment_Payment_Type1 FOREIGN KEY (Payment_Type_ID)
        REFERENCES dbo.Payment_Type(Payment_Type_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_Payment_Order1 FOREIGN KEY (Order_ID)
        REFERENCES dbo.Order_(Order_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Table: Category
CREATE TABLE dbo.Category (
    Category_ID INT NOT NULL PRIMARY KEY,
    Category_Name VARCHAR(100) NOT NULL
);

-- Table: Product
CREATE TABLE dbo.Product (
    Product_ID INT NOT NULL PRIMARY KEY,
    Product_Name VARCHAR(45) NOT NULL,
    Product_Description VARCHAR(45) NOT NULL,
    Registration_Date DATETIME NOT NULL,
    Category_ID INT NOT NULL,
    Photo VARCHAR(45) NULL,
    CONSTRAINT fk_Product_Category1 FOREIGN KEY (Category_ID)
        REFERENCES dbo.Category(Category_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Table: Supply_Type
CREATE TABLE dbo.Supply_Type (
    Supply_Type_ID INT NOT NULL PRIMARY KEY,
    Supply_Type VARCHAR(45)
);

-- Table: Supplier
CREATE TABLE dbo.Supplier (
    Supplier_ID INT NOT NULL PRIMARY KEY,
    Company_Name VARCHAR(45) NULL,
    Registration_Date DATETIME NULL,
    Comment VARCHAR(45) NULL
);

-- Table: Supply
CREATE TABLE dbo.Supply (
    Supply_ID INT NOT NULL PRIMARY KEY,
    Company_Name VARCHAR(45) NOT NULL,
    Supply_Date DATE NOT NULL,
    Supplier_Name VARCHAR(45) NOT NULL,
    Comment VARCHAR(45) NOT NULL,
    Supply_Type_ID INT NOT NULL,
    Invoice_Number INT NULL,
    Supplier_ID INT NOT NULL,
    CONSTRAINT fk_Supply_Supply_Type1 FOREIGN KEY (Supply_Type_ID)
        REFERENCES dbo.Supply_Type(Supply_Type_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_Supply_Supplier1 FOREIGN KEY (Supplier_ID)
        REFERENCES dbo.Supplier(Supplier_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Table: Warehouse
CREATE TABLE dbo.Warehouse (
    Warehouse_ID INT NOT NULL PRIMARY KEY,
    Warehouse_Name VARCHAR(45) NULL
);

-- Table: Supply_List
CREATE TABLE dbo.Supply_List (
    Supply_List_ID INT NOT NULL PRIMARY KEY,
    Quantity INT NOT NULL,
    Price INT NOT NULL,
    Supply_ID INT NOT NULL,
    Warehouse_ID INT NOT NULL,
    Comment VARCHAR(45) NULL,
    Product_ID INT NOT NULL,
    CONSTRAINT fk_Supply_List_Supply1 FOREIGN KEY (Supply_ID)
        REFERENCES dbo.Supply(Supply_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_Supply_List_Warehouse1 FOREIGN KEY (Warehouse_ID)
        REFERENCES dbo.Warehouse(Warehouse_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_Supply_List_Product1 FOREIGN KEY (Product_ID)
        REFERENCES dbo.Product(Product_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Table: Payout_Type
CREATE TABLE dbo.Payout_Type (
    Payout_Type_ID INT NOT NULL PRIMARY KEY,
    Payout_Type_Name VARCHAR(45) NULL
);

-- Table: Salary
CREATE TABLE dbo.Salary (
    Salary_ID INT NOT NULL PRIMARY KEY,
    Salary_Amount INT NOT NULL,
    Salary_Date VARCHAR(45) NULL,
    Comment VARCHAR(45) NULL,
    Bonus INT NULL,
    Payout_Type_ID INT NOT NULL,
    Employee_ID INT NOT NULL,
    CONSTRAINT fk_Salary_Payout_Type1 FOREIGN KEY (Payout_Type_ID)
        REFERENCES dbo.Payout_Type(Payout_Type_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_Salary_Employee1 FOREIGN KEY (Employee_ID)
        REFERENCES dbo.Employee(Employee_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Table: Order_Details
CREATE TABLE dbo.Order_Details (
    Order_Details_ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Supply_List_ID INT NOT NULL,
    Order_ID INT NOT NULL,
    Quantity INT NULL,
    Discounted_Price INT NULL,
    CONSTRAINT fk_Order_Details_Supply_List1 FOREIGN KEY (Supply_List_ID)
        REFERENCES dbo.Supply_List(Supply_List_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_Order_Details_Order1 FOREIGN KEY (Order_ID)
        REFERENCES dbo.Order_(Order_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Table: Price_List
CREATE TABLE dbo.Price_List (
    Price_List_ID INT NOT NULL PRIMARY KEY,
    Comment VARCHAR(45) NOT NULL,
    Price INT NOT NULL,
    Modified_Date DATETIME NULL,
    Product_ID INT NOT NULL,
    CONSTRAINT fk_Price_List_Product1 FOREIGN KEY (Product_ID)
        REFERENCES dbo.Product(Product_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Table: Report
CREATE TABLE dbo.Report (
    Report_ID INT NOT NULL PRIMARY KEY,
    Date_and_Time DATETIME NOT NULL,
    Form_Name VARCHAR(45) NULL,
    Report_Name VARCHAR(45) NULL
);

-- Table: Tax
CREATE TABLE dbo.Tax (
    Tax_ID INT NOT NULL PRIMARY KEY,
    Tax_Rate FLOAT NULL,
    Name_ VARCHAR(45) NULL,
    Comment VARCHAR(45) NULL
);

-- Table: Supply_Payment
CREATE TABLE dbo.Supply_Payment (
    Supply_Payment_ID INT NOT NULL PRIMARY KEY,
    Amount INT NULL,
    Payment_Type_ID INT NOT NULL,
    Supply_ID INT NOT NULL,
    Date_ DATETIME NULL,
    Comments VARCHAR(145) NULL,
    CONSTRAINT fk_Supply_Payment_Payment_Type1 FOREIGN KEY (Payment_Type_ID)
        REFERENCES dbo.Payment_Type(Payment_Type_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_Supply_Payment_Supply1 FOREIGN KEY (Supply_ID)
        REFERENCES dbo.Supply(Supply_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Table: Product_WriteOff
CREATE TABLE dbo.Product_WriteOff (
    Product_WriteOff_ID INT NOT NULL PRIMARY KEY,
    Product_ID INT NOT NULL,
    Comment VARCHAR(45) NULL,
    Date_ DATE NULL,
    Quantity INT NULL,
    CONSTRAINT fk_Product_WriteOff_Product FOREIGN KEY (Product_ID)
        REFERENCES dbo.Product(Product_ID)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);
