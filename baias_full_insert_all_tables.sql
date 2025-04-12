INSERT INTO Category VALUES
(1, 'Flowers'),
(2, 'Trees');

INSERT INTO Contact_Type VALUES
(1, 'Phone'),
(2, 'Email');

INSERT INTO Client_Type VALUES
(1, 'Retail'),
(2, 'Wholesale');

INSERT INTO District VALUES
(1, 'North'),
(2, 'South');

INSERT INTO Position VALUES
(1, 'Administrator'),
(2, 'Seller'),
(3, 'Purchasing Manager'),
(4, 'Accountant');

INSERT INTO Contacts VALUES
(1, 'contact1@example.com', 2),
(2, 'contact2@example.com', 1),
(3, 'contact3@example.com', 2),
(4, 'contact4@example.com', 1),
(5, 'contact5@example.com', 2),
(6, 'contact6@example.com', 1),
(7, 'contact7@example.com', 2),
(8, 'contact8@example.com', 1),
(9, 'contact9@example.com', 2),
(10, 'contact10@example.com', 1);

INSERT INTO Client VALUES
(1, 'Name1', 'Surname1', 1, 1, 1, 0.05, '2023-01-01', 'Company1', 'Manager', 'P1Num', 'client1', 'client'),
(2, 'Name2', 'Surname2', 1, 2, 1, 0.05, '2023-01-02', 'Company2', 'Manager', 'P2Num', 'client2', 'client'),
(3, 'Name3', 'Surname3', 1, 3, 1, 0.05, '2023-01-03', 'Company3', 'Manager', 'P3Num', 'client3', 'client'),
(4, 'Name4', 'Surname4', 1, 4, 1, 0.05, '2023-01-04', 'Company4', 'Manager', 'P4Num', 'client4', 'client'),
(5, 'Name5', 'Surname5', 1, 5, 1, 0.05, '2023-01-05', 'Company5', 'Manager', 'P5Num', 'client5', 'client'),
(6, 'Name6', 'Surname6', 1, 6, 2, 0.05, '2023-01-06', 'Company6', 'Manager', 'P6Num', 'client6', 'client'),
(7, 'Name7', 'Surname7', 1, 7, 2, 0.05, '2023-01-07', 'Company7', 'Manager', 'P7Num', 'client7', 'client'),
(8, 'Name8', 'Surname8', 1, 8, 2, 0.05, '2023-01-08', 'Company8', 'Manager', 'P8Num', 'client8', 'client'),
(9, 'Name9', 'Surname9', 1, 9, 2, 0.05, '2023-01-09', 'Company9', 'Manager', 'P9Num', 'client9', 'client'),
(10, 'Name10', 'Surname10', 1, 10, 2, 0.05, '2023-01-10', 'Company10', 'Manager', 'P10Num', 'client10', 'client');

INSERT INTO Employee VALUES
(1, 'EName1', 'ESurname1', '2023-01-02', '0700123001', 'emp1', 'emp', 1),
(2, 'EName2', 'ESurname2', '2023-01-03', '0700123002', 'emp2', 'emp', 2),
(3, 'EName3', 'ESurname3', '2023-01-04', '0700123003', 'emp3', 'emp', 3),
(4, 'EName4', 'ESurname4', '2023-01-05', '0700123004', 'emp4', 'emp', 4),
(5, 'EName5', 'ESurname5', '2023-01-06', '0700123005', 'emp5', 'emp', 1),
(6, 'EName6', 'ESurname6', '2023-01-07', '0700123006', 'emp6', 'emp', 2),
(7, 'EName7', 'ESurname7', '2023-01-08', '0700123007', 'emp7', 'emp', 3),
(8, 'EName8', 'ESurname8', '2023-01-09', '0700123008', 'emp8', 'emp', 4),
(9, 'EName9', 'ESurname9', '2023-01-10', '0700123009', 'emp9', 'emp', 1),
(10, 'EName10', 'ESurname10', '2023-01-11', '0700123010', 'emp10', 'emp', 2);

INSERT INTO Warehouse VALUES
(1, 'Warehouse1'),
(2, 'Warehouse2'),
(3, 'Warehouse3'),
(4, 'Warehouse4'),
(5, 'Warehouse5'),
(6, 'Warehouse6'),
(7, 'Warehouse7'),
(8, 'Warehouse8'),
(9, 'Warehouse9'),
(10, 'Warehouse10');

INSERT INTO Supplier VALUES
(1, 'Supplier1', '2022-01-02', 'Good'),
(2, 'Supplier2', '2022-01-03', 'Good'),
(3, 'Supplier3', '2022-01-04', 'Good'),
(4, 'Supplier4', '2022-01-05', 'Good'),
(5, 'Supplier5', '2022-01-06', 'Good'),
(6, 'Supplier6', '2022-01-07', 'Good'),
(7, 'Supplier7', '2022-01-08', 'Good'),
(8, 'Supplier8', '2022-01-09', 'Good'),
(9, 'Supplier9', '2022-01-10', 'Good'),
(10, 'Supplier10', '2022-01-11', 'Good');

INSERT INTO Supply_Type VALUES
(1, 'Local'),
(2, 'Import');

INSERT INTO Supply VALUES
(1, 'Company1', '2023-01-02', 'Supplier1', 'OK', 2, 10001, 1),
(2, 'Company2', '2023-01-03', 'Supplier2', 'OK', 1, 10002, 2),
(3, 'Company3', '2023-01-04', 'Supplier3', 'OK', 2, 10003, 3),
(4, 'Company4', '2023-01-05', 'Supplier4', 'OK', 1, 10004, 4),
(5, 'Company5', '2023-01-06', 'Supplier5', 'OK', 2, 10005, 5),
(6, 'Company6', '2023-01-07', 'Supplier6', 'OK', 1, 10006, 6),
(7, 'Company7', '2023-01-08', 'Supplier7', 'OK', 2, 10007, 7),
(8, 'Company8', '2023-01-09', 'Supplier8', 'OK', 1, 10008, 8),
(9, 'Company9', '2023-01-10', 'Supplier9', 'OK', 2, 10009, 9),
(10, 'Company10', '2023-01-11', 'Supplier10', 'OK', 1, 100010, 10);

INSERT INTO Product VALUES
(1, 'Product1', 'Desc1', '2023-01-01 10:00:00', 1, NULL),
(2, 'Product2', 'Desc2', '2023-01-02 10:00:00', 1, NULL),
(3, 'Product3', 'Desc3', '2023-01-03 10:00:00', 1, NULL),
(4, 'Product4', 'Desc4', '2023-01-04 10:00:00', 1, NULL),
(5, 'Product5', 'Desc5', '2023-01-05 10:00:00', 1, NULL),
(6, 'Product6', 'Desc6', '2023-01-06 10:00:00', 2, NULL),
(7, 'Product7', 'Desc7', '2023-01-07 10:00:00', 2, NULL),
(8, 'Product8', 'Desc8', '2023-01-08 10:00:00', 2, NULL),
(9, 'Product9', 'Desc9', '2023-01-09 10:00:00', 2, NULL),
(10, 'Product10', 'Desc10', '2023-01-10 10:00:00', 2, NULL);

INSERT INTO Supply_List VALUES
(1, 10, 100 + 1, 1, 1, NULL, 1),
(2, 10, 100 + 2, 2, 2, NULL, 2),
(3, 10, 100 + 3, 3, 3, NULL, 3),
(4, 10, 100 + 4, 4, 4, NULL, 4),
(5, 10, 100 + 5, 5, 5, NULL, 5),
(6, 10, 100 + 6, 6, 6, NULL, 6),
(7, 10, 100 + 7, 7, 7, NULL, 7),
(8, 10, 100 + 8, 8, 8, NULL, 8),
(9, 10, 100 + 9, 9, 9, NULL, 9),
(10, 10, 100 + 10, 10, 10, NULL, 10);

INSERT INTO Price_List VALUES
(1, 'Seasonal', 201, '2023-02-01 10:00:00', 1),
(2, 'Seasonal', 202, '2023-02-02 10:00:00', 2),
(3, 'Seasonal', 203, '2023-02-03 10:00:00', 3),
(4, 'Seasonal', 204, '2023-02-04 10:00:00', 4),
(5, 'Seasonal', 205, '2023-02-05 10:00:00', 5),
(6, 'Seasonal', 206, '2023-02-06 10:00:00', 6),
(7, 'Seasonal', 207, '2023-02-07 10:00:00', 7),
(8, 'Seasonal', 208, '2023-02-08 10:00:00', 8),
(9, 'Seasonal', 209, '2023-02-09 10:00:00', 9),
(10, 'Seasonal', 210, '2023-02-10 10:00:00', 10);

INSERT INTO Order_Status VALUES
(1, 'Pending'),
(2, 'Completed'),
(3, 'Cancelled');

INSERT INTO Order_Type VALUES
(1, 'Online'),
(2, 'In-Store');

INSERT INTO Discount_Type VALUES
(1, 'Event1'),
(2, 'Event2'),
(3, 'Event3'),
(4, 'Event4'),
(5, 'Event5'),
(6, 'Event6'),
(7, 'Event7'),
(8, 'Event8'),
(9, 'Event9'),
(10, 'Event10');

INSERT INTO Event_Type VALUES
(1, 'Type1'),
(2, 'Type2'),
(3, 'Type3'),
(4, 'Type4'),
(5, 'Type5'),
(6, 'Type6'),
(7, 'Type7'),
(8, 'Type8'),
(9, 'Type9'),
(10, 'Type10');

INSERT INTO Events VALUES
(1, 'Event1', 1, 'None'),
(2, 'Event2', 2, 'None'),
(3, 'Event3', 3, 'None'),
(4, 'Event4', 4, 'None'),
(5, 'Event5', 5, 'None'),
(6, 'Event6', 6, 'None'),
(7, 'Event7', 7, 'None'),
(8, 'Event8', 8, 'None'),
(9, 'Event9', 9, 'None'),
(10, 'Event10', 10, 'None');

INSERT INTO Discount VALUES
(1, 0.1 * 1, 1, 1),
(2, 0.1 * 2, 2, 2),
(3, 0.1 * 3, 3, 3),
(4, 0.1 * 4, 4, 4),
(5, 0.1 * 5, 5, 5),
(6, 0.1 * 6, 6, 6),
(7, 0.1 * 7, 7, 7),
(8, 0.1 * 8, 8, 8),
(9, 0.1 * 9, 9, 9),
(10, 0.1 * 10, 10, 10);

INSERT INTO Order_ VALUES
(1, 1, 1, 1, 2, '2023-03-01', 'INV1', 'None', 1),
(2, 2, 1, 1, 3, '2023-03-02', 'INV2', 'None', 2),
(3, 3, 1, 1, 1, '2023-03-03', 'INV3', 'None', 3),
(4, 4, 1, 1, 2, '2023-03-04', 'INV4', 'None', 4),
(5, 5, 1, 1, 3, '2023-03-05', 'INV5', 'None', 5),
(6, 6, 1, 1, 1, '2023-03-06', 'INV6', 'None', 6),
(7, 7, 1, 1, 2, '2023-03-07', 'INV7', 'None', 7),
(8, 8, 1, 1, 3, '2023-03-08', 'INV8', 'None', 8),
(9, 9, 1, 1, 1, '2023-03-09', 'INV9', 'None', 9),
(10, 10, 1, 1, 2, '2023-03-10', 'INV10', 'None', 10);

INSERT INTO Order_Details (Supply_List_ID, Order_ID, Quantity, Discounted_Price)
VALUES 
(1, 1, 2, 150),
(2, 2, 2, 150),
(3, 3, 2, 150),
(4, 4, 2, 150),
(5, 5, 2, 150),
(6, 6, 2, 150),
(7, 7, 2, 150),
(8, 8, 2, 150),
(9, 9, 2, 150),
(10, 10, 2, 150);

INSERT INTO Payment_Type VALUES
(1, 'Card'),
(2, 'Cash');

INSERT INTO Payment VALUES
(1, 1, 100 * 1, '2023-03-01', 'OK', 1),
(2, 1, 100 * 2, '2023-03-02', 'OK', 2),
(3, 1, 100 * 3, '2023-03-03', 'OK', 3),
(4, 1, 100 * 4, '2023-03-04', 'OK', 4),
(5, 1, 100 * 5, '2023-03-05', 'OK', 5),
(6, 1, 100 * 6, '2023-03-06', 'OK', 6),
(7, 1, 100 * 7, '2023-03-07', 'OK', 7),
(8, 1, 100 * 8, '2023-03-08', 'OK', 8),
(9, 1, 100 * 9, '2023-03-09', 'OK', 9),
(10, 1, 100 * 10, '2023-03-10', 'OK', 10);

INSERT INTO Payout_Type VALUES
(1, 'Bank Transfer'),
(2, 'Cash');

INSERT INTO Salary VALUES
(1, 1000 + 10, '2023-03-01', 'Monthly', 100, 1, 1),
(2, 1000 + 20, '2023-03-02', 'Monthly', 100, 1, 2),
(3, 1000 + 30, '2023-03-03', 'Monthly', 100, 1, 3),
(4, 1000 + 40, '2023-03-04', 'Monthly', 100, 1, 4),
(5, 1000 + 50, '2023-03-05', 'Monthly', 100, 1, 5),
(6, 1000 + 60, '2023-03-06', 'Monthly', 100, 1, 6),
(7, 1000 + 70, '2023-03-07', 'Monthly', 100, 1, 7),
(8, 1000 + 80, '2023-03-08', 'Monthly', 100, 1, 8),
(9, 1000 + 90, '2023-03-09', 'Monthly', 100, 1, 9),
(10, 1000 + 100, '2023-03-10', 'Monthly', 100, 1, 10);

INSERT INTO Tax VALUES
(1, 6, 'Tax1', 'Standard'),
(2, 7, 'Tax2', 'Standard'),
(3, 8, 'Tax3', 'Standard'),
(4, 9, 'Tax4', 'Standard'),
(5, 10, 'Tax5', 'Standard'),
(6, 11, 'Tax6', 'Standard'),
(7, 12, 'Tax7', 'Standard'),
(8, 13, 'Tax8', 'Standard'),
(9, 14, 'Tax9', 'Standard'),
(10, 15, 'Tax10', 'Standard');

INSERT INTO Supply_Payment VALUES
(1, 100 * 1, 1, 1, '2023-03-01', 'Paid'),
(2, 100 * 2, 1, 2, '2023-03-02', 'Paid'),
(3, 100 * 3, 1, 3, '2023-03-03', 'Paid'),
(4, 100 * 4, 1, 4, '2023-03-04', 'Paid'),
(5, 100 * 5, 1, 5, '2023-03-05', 'Paid'),
(6, 100 * 6, 1, 6, '2023-03-06', 'Paid'),
(7, 100 * 7, 1, 7, '2023-03-07', 'Paid'),
(8, 100 * 8, 1, 8, '2023-03-08', 'Paid'),
(9, 100 * 9, 1, 9, '2023-03-09', 'Paid'),
(10, 100 * 10, 1, 10, '2023-03-10', 'Paid');

INSERT INTO Product_WriteOff VALUES
(1, 1, 'Issue', '2023-03-01', 1),
(2, 2, 'Issue', '2023-03-02', 2),
(3, 3, 'Issue', '2023-03-03', 3),
(4, 4, 'Issue', '2023-03-04', 4),
(5, 5, 'Issue', '2023-03-05', 5),
(6, 6, 'Issue', '2023-03-06', 6),
(7, 7, 'Issue', '2023-03-07', 7),
(8, 8, 'Issue', '2023-03-08', 8),
(9, 9, 'Issue', '2023-03-09', 9),
(10, 10, 'Issue', '2023-03-10', 10);

INSERT INTO Report VALUES
(1, '2023-03-01 12:00:00', 'Form1', 'Report1'),
(2, '2023-03-02 12:00:00', 'Form2', 'Report2'),
(3, '2023-03-03 12:00:00', 'Form3', 'Report3'),
(4, '2023-03-04 12:00:00', 'Form4', 'Report4'),
(5, '2023-03-05 12:00:00', 'Form5', 'Report5'),
(6, '2023-03-06 12:00:00', 'Form6', 'Report6'),
(7, '2023-03-07 12:00:00', 'Form7', 'Report7'),
(8, '2023-03-08 12:00:00', 'Form8', 'Report8'),
(9, '2023-03-09 12:00:00', 'Form9', 'Report9'),
(10, '2023-03-10 12:00:00', 'Form10', 'Report10');
