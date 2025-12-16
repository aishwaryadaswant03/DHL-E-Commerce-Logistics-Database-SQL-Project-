create database DHL_ecommerce_Logistics;
use DHL_ecommerce_Logistics;

-- seller table
create table Seller(
s_id int primary key auto_increment, 
Name varchar(50) not null,
email varchar(50) unique not null,  
phone int unique not null,
address varchar (50));

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    PhoneNo VARCHAR(15),
    Address VARCHAR(100)
);

-- Package Table
create table Package(
Packageid int primary key Auto_increment,
weight decimal(6,2) not null,
dimensions varchar(50),
contentdescription varchar(50),
value decimal (10,2),
status varchar(50) default 'In transit');

-- shipment table

CREATE TABLE Shipment (
    ShipmentID INT PRIMARY KEY AUTO_INCREMENT,
    SenderID INT,
    ReceiverID INT,
    PackageID INT,
    PickupDate DATE,
    DeliveryDate DATE,
    CurrentLocation VARCHAR(100),
    FOREIGN KEY (SenderID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (ReceiverID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (PackageID) REFERENCES Package(PackageID));
    
    -- Employee Table
    CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Role VARCHAR(50),
    PhoneNo VARCHAR(15),
    BranchLocation VARCHAR(100));
    
    -- Payment Table
    
    create table payment(
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    ShipmentID INT,
    PaymentDate DATE,
    Amount DECIMAL(10,2),
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (ShipmentID) REFERENCES Shipment(ShipmentID)
);

-- branch Table

CREATE TABLE Branch (
    BranchID INT PRIMARY KEY AUTO_INCREMENT,
    BranchName VARCHAR(100),
    Location VARCHAR(100),
    ManagerID INT,
    FOREIGN KEY (ManagerID) REFERENCES Employee(EmployeeID)
);

INSERT INTO Customer (Name, Email, PhoneNo, Address) VALUES
('Amit Sharma','amit@mail.com','9876543210','Mumbai'),
('Priya Verma','priya@mail.com','9123456789','Delhi'),
('John Doe','john@mail.com','9988776655','Chennai'),
('Sara Ali','sara@mail.com','9998887776','Kolkata');

INSERT INTO Package (Weight, Dimensions, ContentDescription, Value, Status) VALUES
(2.5,'20x15x10','Documents',1500.00,'Delivered'),
(5.0,'30x25x20','Electronics',4500.00,'In Transit'),
(1.2,'15x10x5','Gift',800.00,'Dispatched');

INSERT INTO Employee (Name, Role, PhoneNo, BranchLocation) VALUES
('Rohit Kumar','Driver','9988776655','Mumbai'),
('Neha Singh','Manager','9876501234','Delhi'),
('Vikram Rao','Dispatcher','9123459876','Chennai');
    
 INSERT INTO Branch (BranchName, Location, ManagerID) VALUES
('DHL Mumbai','Mumbai',1),
('DHL Delhi','Delhi',2),
('DHL Chennai','Chennai',3);

INSERT INTO Shipment (SenderID, ReceiverID, PackageID, PickupDate, DeliveryDate, CurrentLocation)
VALUES
(1,2,1,'2025-10-10','2025-10-12','Delivered'),
(3,4,2,'2025-10-15',NULL,'Hyderabad'),
(2,1,3,'2025-10-18',NULL,'Chennai');

INSERT INTO Payment (ShipmentID, PaymentDate, Amount, PaymentMethod)
VALUES
(1,'2025-10-11',1200.00,'UPI'),
(2,'2025-10-16',2200.00,'Credit Card');


-- Total revenue collected by DHL
   SELECT SUM(Amount) AS TotalRevenue FROM Payment;

-- 1. Data Retrieval Queries

-- List all packages with their current status
SELECT PackageID, ContentDescription, Status FROM Package;

-- Display all customers from Mumbai
SELECT * FROM Customer WHERE Address = 'Mumbai';

-- 2. Filtering and Sorting

-- Find packages with value greater than 2000
SELECT * FROM Package WHERE Value > 2000;

-- Show shipments not yet delivered
SELECT * FROM Shipment WHERE DeliveryDate IS NULL;

-- 3. Aggregation Queries

-- Find total payment amount received
SELECT SUM(Amount) AS TotalPayments FROM Payment;

-- Count number of shipments delivered vs in transit
SELECT Status, COUNT(*) AS Count
FROM Package
GROUP BY Status;

-- 4.  Update and Delete Queries
-- Update package status after delivery
UPDATE Package
SET Status = 'Delivered'
WHERE PackageID = 2;

-- Change branch location name
UPDATE Branch
SET Location = 'New Delhi'
WHERE BranchName = 'DHL Delhi';

-- 5 . Subqueries

-- Find customers who have sent at least one shipment
SELECT Name 
FROM Customer
WHERE CustomerID IN (SELECT SenderID FROM Shipment);

-- 6. Useful Admin/Report Queries

-- Generate a daily payment report
SELECT PaymentDate, SUM(Amount) AS TotalCollected
FROM Payment
GROUP BY PaymentDate;

-- find top 2 highest-value packages
SELECT * FROM Package ORDER BY Value DESC LIMIT 2;

-- 7. Advanced / Combined Queries

-- Find employees who are not managers
SELECT * FROM Employee
WHERE EmployeeID NOT IN (SELECT ManagerID FROM Branch);

-- Count shipments handled per sender
SELECT SenderID, COUNT(*) AS TotalShipments
FROM Shipment
GROUP BY SenderID;

-- 8 Using JOINS

-- Show payment details along with shipment and package info
SELECT p.PaymentID, p.Amount, p.PaymentMethod, s.ShipmentID, pkg.ContentDescription
FROM Payment p
JOIN Shipment s ON p.ShipmentID = s.ShipmentID
JOIN Package pkg ON s.PackageID = pkg.PackageID;

-- List each branch with its manager's name
SELECT b.BranchName, b.Location, e.Name AS ManagerName
FROM Branch b
JOIN Employee e ON b.ManagerID = e.EmployeeID;