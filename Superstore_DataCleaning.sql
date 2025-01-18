#Data Cleaning
#Check for Missing Values 
SELECT * From Orders;
SELECT * From Customers;
SELECT * From Sales;
SELECT * From Products;
SELECT * From Regions;

-- Check for missing values in the Orders table
SELECT * 
FROM Orders
WHERE OrderDate IS NULL OR ShipDate IS NULL OR CustomerID IS NULL;

-- Check for missing values in the Sales table
SELECT * 
FROM Sales
WHERE SalesAmount IS NULL OR Profit IS NULL OR OrderID IS NULL;

-- Check for missing values in the Products table
SELECT * 
FROM Products
WHERE ProductName IS NULL OR Category IS NULL;

-- Check for missing values in the Regions table
SELECT * 
FROM Regions
WHERE RegionName IS NULL OR Country IS NULL OR PostalCode IS NULL;

#Validate Logical Consistency

-- Validate that ShipDate is not earlier than OrderDate in the Orders table
SELECT *
FROM Orders
WHERE ShipDate < OrderDate;

-- Validate numeric fields in the Sales table
SELECT *
FROM Sales
WHERE SalesAmount < 0 OR Profit < 0 OR Discount < 0 OR Discount > 1;

-- Flag rows with negative profit to analyze losses separately
ALTER TABLE Sales ADD COLUMN IsLoss BOOLEAN DEFAULT 0;
UPDATE Sales
SET IsLoss = 1
WHERE Profit < 0;

SELECT * FROM Sales where Isloss = 1;

SELECT * FROM Sales where Discount > 1;

#Check for duplicates
-- Check for duplicate rows in Customers table
SELECT CustomerID, COUNT(*)
FROM Customers
GROUP BY CustomerID
HAVING COUNT(*) > 1;

-- Check for duplicate rows in Orders table
SELECT OrderID, COUNT(*)
FROM Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;

-- Check for duplicate rows in Products table
SELECT ProductID, COUNT(*)
FROM Products
GROUP BY ProductID
HAVING COUNT(*) > 1;

-- Check for duplicate rows in Sales table
SELECT OrderID, ProductID, COUNT(*)
FROM Sales
GROUP BY OrderID, ProductID
HAVING COUNT(*) > 1;

DELETE FROM Sales
WHERE (OrderID, ProductID) IN (
    SELECT OrderID, ProductID
    FROM (
        SELECT OrderID, ProductID, ROW_NUMBER() OVER (PARTITION BY OrderID, ProductID ORDER BY SalesAmount DESC) AS row_num
        FROM Sales
    ) subquery
    WHERE row_num > 1
);

-- Ensure dates are in the correct format (YYYY-MM-DD)
UPDATE Orders
SET OrderDate = STR_TO_DATE(OrderDate, '%Y-%m-%d'),
    ShipDate = STR_TO_DATE(ShipDate, '%Y-%m-%d');
    
