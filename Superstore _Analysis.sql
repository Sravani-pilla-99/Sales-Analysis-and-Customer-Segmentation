# Sales Performance 

-- Top 10 products by total revenue and profit
SELECT 
    p.ProductName,                      
    SUM(s.SalesAmount) AS TotalRevenue, 
    SUM(s.Profit) AS TotalProfit       
FROM 
    Sales s
JOIN 
    Products p
ON 
    s.ProductID = p.ProductID           
GROUP BY 
    p.ProductName                       
ORDER BY 
    TotalRevenue DESC                   
LIMIT 10;    

SELECT 
    p.ProductName, 
    SUM(s.SalesAmount) AS TotalRevenue, 
    SUM(s.Profit) AS TotalProfit,
    (SUM(s.SalesAmount) / (SELECT SUM(SalesAmount) FROM Sales)) * 100 AS RevenueContributionPercentage
FROM 
    Sales s
JOIN 
    Products p ON s.ProductID = p.ProductID
GROUP BY 
    p.ProductName
ORDER BY 
    TotalRevenue DESC
LIMIT 10;


-- Total revenue and profit by category
SELECT 
    p.Category,                        
    SUM(s.SalesAmount) AS TotalRevenue, 
    SUM(s.Profit) AS TotalProfit        
FROM 
    Sales s
JOIN 
    Products p
ON 
    s.ProductID = p.ProductID           
GROUP BY 
    p.Category                          
ORDER BY 
    TotalRevenue DESC;  

SELECT 
    p.Category, 
    SUM(s.SalesAmount) AS TotalRevenue, 
    SUM(s.Profit) AS TotalProfit,
    (SUM(s.SalesAmount) / (SELECT SUM(SalesAmount) FROM Sales)) * 100 AS RevenueContributionPercentage,
    (SUM(s.Profit) / (SELECT SUM(Profit) FROM Sales)) * 100 AS ProfitContributionPercentage
FROM 
    Sales s
JOIN 
    Products p ON s.ProductID = p.ProductID
GROUP BY 
    p.Category
ORDER BY 
    TotalRevenue DESC;

-- Total revenue by region 
SELECT 
    c.Region AS RegionName,            
    SUM(s.SalesAmount) AS TotalRevenue, 
    SUM(s.Profit) AS TotalProfit        
FROM 
    Sales s
JOIN 
    Orders o ON s.OrderID = o.OrderID    
JOIN 
    Customers c ON o.CustomerID = c.CustomerID 
GROUP BY 
    c.Region                             
ORDER BY 
    TotalRevenue DESC;     
    
    
-- Monthly and Yearly Revenue Trends

-- Monthly revenue trends
SELECT 
    DATE_FORMAT(o.OrderDate, '%Y-%m') AS Month, 
    SUM(s.SalesAmount) AS TotalRevenue          
FROM 
    Sales s
JOIN 
    Orders o ON s.OrderID = o.OrderID           
GROUP BY 
    DATE_FORMAT(o.OrderDate, '%Y-%m')           
ORDER BY 
    Month;      
    

-- Yearly revenue trends
SELECT 
    YEAR(o.OrderDate) AS Year,        
    SUM(s.SalesAmount) AS TotalRevenue 
FROM 
    Sales s
JOIN 
    Orders o ON s.OrderID = o.OrderID  
GROUP BY 
    YEAR(o.OrderDate)                  
ORDER BY 
    Year;                              

-- Profitability Analysis

-- Products with the highest and lowest profit margins
SELECT 
    p.ProductName,                         
    SUM(s.Profit) / SUM(s.SalesAmount) AS ProfitMargin,
    SUM(s.SalesAmount) AS TotalRevenue,    
    SUM(s.Profit) AS TotalProfit           
FROM 
    Sales s
JOIN 
    Products p ON s.ProductID = p.ProductID 
GROUP BY 
    p.ProductName                           
HAVING 
    SUM(s.SalesAmount) > 0                 
ORDER BY 
    ProfitMargin DESC                      
LIMIT 10;                                  

SELECT 
    p.Category, 
    SUM(s.Profit) / SUM(s.SalesAmount) AS ProfitMargin, 
    SUM(s.SalesAmount) AS TotalRevenue, 
    SUM(s.Profit) AS TotalProfit
FROM 
    Sales s
JOIN 
    Products p ON s.ProductID = p.ProductID
GROUP BY 
    p.Category
ORDER BY 
    ProfitMargin DESC;


-- Most and least profitable regions
SELECT 
    c.Region AS RegionName,                
    SUM(s.Profit) AS TotalProfit,          
    SUM(s.SalesAmount) AS TotalRevenue,  
    SUM(s.Profit) / SUM(s.SalesAmount) AS ProfitMargin
FROM 
    Sales s
JOIN 
    Orders o ON s.OrderID = o.OrderID       
JOIN 
    Customers c ON o.CustomerID = c.CustomerID 
GROUP BY 
    c.Region                                
ORDER BY 
    TotalProfit DESC;                      

-- Discount Impact Analysis
-- Correlation Between Discounts and Sales Volume

SELECT 
    ROUND(Discount, 2) AS DiscountRange, 
    COUNT(*) AS NumberOfTransactions,   
    SUM(Quantity) AS TotalQuantity,     
    SUM(SalesAmount) AS TotalRevenue    
FROM 
    Sales
GROUP BY 
    ROUND(Discount, 2)                  
ORDER BY 
    DiscountRange;

-- Do Higher Discounts Lead to Losses?
SELECT 
    ROUND(Discount, 2) AS DiscountRange, 
    SUM(SalesAmount) AS TotalRevenue,    
    SUM(Profit) AS TotalProfit,          
    AVG(Profit) AS AvgProfitPerTransaction 
FROM 
    Sales
GROUP BY 
    ROUND(Discount, 2)                   
ORDER BY 
    DiscountRange;
    
-- Shipping Insights
-- Which shipping modes are the most commonly used and profitable?
-- Analyze shipping modes by usage and profitability
SELECT 
    o.ShipMode,                          
    COUNT(*) AS TotalOrders,             
    SUM(s.SalesAmount) AS TotalRevenue,  
    SUM(s.Profit) AS TotalProfit         
FROM 
    Orders o
JOIN 
    Sales s ON o.OrderID = s.OrderID     
GROUP BY 
    o.ShipMode                           
ORDER BY 
    TotalOrders DESC;                    

-- Are there delays in shipping that might impact customer satisfaction?

SELECT 
    o.ShipMode,                          
    COUNT(*) AS DelayedOrders,           
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DelayPercentage, 
    AVG(DATEDIFF(o.ShipDate, o.OrderDate)) AS AvgShippingDays 
FROM 
    Orders o
WHERE 
    DATEDIFF(o.ShipDate, o.OrderDate) > 0 
GROUP BY 
    o.ShipMode                          
ORDER BY 
    DelayedOrders DESC;   
                       

    
-- Quarterly Sales Trends
SELECT 
    QUARTER(o.OrderDate) AS Quarter,
    YEAR(o.OrderDate) AS Year,
    SUM(s.SalesAmount) AS TotalRevenue,
    SUM(s.Profit) AS TotalProfit
FROM 
    Sales s
JOIN 
    Orders o ON s.OrderID = o.OrderID
GROUP BY 
    Year, Quarter
ORDER BY 
    Year, Quarter;
    
-- Unprofitable Products
SELECT 
    p.ProductName, 
    SUM(s.Profit) AS TotalProfit
FROM 
    Sales s
JOIN 
    Products p ON s.ProductID = p.ProductID
GROUP BY 
    p.ProductName
HAVING 
    TotalProfit < 0
ORDER BY 
    TotalProfit ASC;
    
-- Customer Retention Analysis
SELECT 
    c.CustomerID,
    c.CustomerName,
    COUNT(o.OrderID) AS OrderCount,
    SUM(s.SalesAmount) AS TotalRevenue
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
JOIN 
    Sales s ON o.OrderID = s.OrderID
GROUP BY 
    c.CustomerID, c.CustomerName
HAVING 
    OrderCount > 1
ORDER BY 
    TotalRevenue DESC;

-- Customer Segmentation
-- Calculate Recency, Frequency, and Monetary Value for each customer
SELECT 
    c.CustomerID,
    c.CustomerName,
    DATEDIFF(CURDATE(), MAX(o.OrderDate)) AS Recency, 
    COUNT(o.OrderID) AS Frequency,                   
    SUM(s.SalesAmount) AS MonetaryValue              
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
JOIN 
    Sales s ON o.OrderID = s.OrderID
GROUP BY 
    c.CustomerID, c.CustomerName
ORDER BY 
    Recency ASC; 

-- Assigning R,F,M scores 
SELECT 
    CustomerID,
    CustomerName,
    Recency,
    NTILE(4) OVER (ORDER BY Recency ASC) AS RecencyScore, -- Lower Recency = Higher Score
    Frequency,
    NTILE(4) OVER (ORDER BY Frequency DESC) AS FrequencyScore, -- Higher Frequency = Higher Score
    MonetaryValue,
    NTILE(4) OVER (ORDER BY MonetaryValue DESC) AS MonetaryScore -- Higher Monetary Value = Higher Score
FROM 
    (SELECT 
    c.CustomerID,
    c.CustomerName,
    DATEDIFF(CURDATE(), MAX(o.OrderDate)) AS Recency, 
    COUNT(o.OrderID) AS Frequency,                   
    SUM(s.SalesAmount) AS MonetaryValue              
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
JOIN 
    Sales s ON o.OrderID = s.OrderID
GROUP BY 
    c.CustomerID, c.CustomerName
ORDER BY 
    Recency ASC
) rfm_metrics;

SELECT 
    CustomerID,
    CustomerName,
    RecencyScore,
    FrequencyScore,
    MonetaryScore,
    CASE 
        WHEN RecencyScore = 4 AND FrequencyScore = 4 AND MonetaryScore = 4 THEN 'Best Customers'
        WHEN RecencyScore <= 2 AND FrequencyScore <= 2 AND MonetaryScore <= 2 THEN 'Lost Customers'
        WHEN RecencyScore >= 3 AND FrequencyScore >= 3 THEN 'Loyal Customers'
        WHEN RecencyScore <= 2 AND MonetaryScore >= 3 THEN 'At Risk'
        WHEN FrequencyScore >= 3 AND MonetaryScore >= 3 THEN 'Big Spenders'
        ELSE 'Other'
    END AS CustomerSegment
FROM 
    (SELECT 
    CustomerID,
    CustomerName,
    Recency,
    NTILE(4) OVER (ORDER BY Recency ASC) AS RecencyScore, -- Lower Recency = Higher Score
    Frequency,
    NTILE(4) OVER (ORDER BY Frequency DESC) AS FrequencyScore, -- Higher Frequency = Higher Score
    MonetaryValue,
    NTILE(4) OVER (ORDER BY MonetaryValue DESC) AS MonetaryScore -- Higher Monetary Value = Higher Score
FROM 
    (SELECT 
    c.CustomerID,
    c.CustomerName,
    DATEDIFF(CURDATE(), MAX(o.OrderDate)) AS Recency, 
    COUNT(o.OrderID) AS Frequency,                   
    SUM(s.SalesAmount) AS MonetaryValue              
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
JOIN 
    Sales s ON o.OrderID = s.OrderID
GROUP BY 
    c.CustomerID, c.CustomerName
ORDER BY 
    Recency ASC
) rfm_metrics)rfm;

