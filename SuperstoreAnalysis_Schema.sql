
-- Database: Superstore
CREATE DATABASE Superstore;

-- Switch to the newly created database
USE Superstore;

-- Table: Customers
CREATE TABLE Customers (
    CustomerID VARCHAR(20) PRIMARY KEY,
    CustomerName VARCHAR(100),
    Segment VARCHAR(50),
    Region VARCHAR(50)
);

-- Table: Orders
CREATE TABLE Orders (
    OrderID VARCHAR(20) PRIMARY KEY,
    OrderDate DATE,
    ShipDate DATE,
    ShipMode VARCHAR(50),
    CustomerID VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Table: Products
CREATE TABLE Products (
    ProductID VARCHAR(20) PRIMARY KEY,
    Category VARCHAR(50),
    SubCategory VARCHAR(50),
    ProductName VARCHAR(200)
);

-- Table: Sales
CREATE TABLE Sales (
    SalesID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID VARCHAR(20),
    ProductID VARCHAR(20),
    Quantity INT,
    Discount DECIMAL(5, 2),
    SalesAmount DECIMAL(10, 2),
    Profit DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Table: Regions
CREATE TABLE Regions (
    RegionID INT AUTO_INCREMENT PRIMARY KEY,
    RegionName VARCHAR(50),
    Country VARCHAR(50),
    State VARCHAR(50),
    City VARCHAR(50),
    PostalCode INT
);
