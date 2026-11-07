
USE [Project Data];
GO

/* =========================================================
   SALES PERFORMANCE ANALYSIS
   Database: Project Data
   Tool: SQL Server Management Studio
   ========================================================= */


/* =========================================================
   SECTION 1: BASIC DATA EXPLORATION
   ========================================================= */

-- 1. View products and prices
SELECT 
    ProductName,
    UnitPrice
FROM Product;


-- 2. Products with price >= 50
SELECT 
    ProductName,
    UnitPrice
FROM Product
WHERE UnitPrice >= 50;


-- 3. Products between 50 and 100
SELECT 
    ProductName,
    UnitPrice
FROM Product
WHERE UnitPrice > 50
  AND UnitPrice < 100
ORDER BY UnitPrice;


-- 4. Highest-priced products
SELECT 
    ProductName,
    UnitPrice
FROM Product
ORDER BY UnitPrice DESC;


-- 5. Unique customer countries
SELECT DISTINCT 
    Country
FROM Customers;


-- 6. Top 5 most expensive products
SELECT TOP 5
    ProductName,
    UnitPrice
FROM Product
ORDER BY UnitPrice DESC;


/* =========================================================
   SECTION 2: ORDERS & CUSTOMERS ANALYSIS
   ========================================================= */

-- 7. Orders that have not been shipped
SELECT 
    OrderID,
    OrderDate,
    ShippedDate
FROM Orders
WHERE ShippedDate IS NULL;


-- 8. Number of unshipped orders
SELECT 
    COUNT(*) AS UnshippedOrders
FROM Orders
WHERE ShippedDate IS NULL;


-- 9. Number of orders per customer
SELECT 
    CustomerID,
    COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY CustomerID;


-- 10. Customers with more than 10 orders
SELECT 
    CustomerID,
    COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 10;


-- 11. Customers and their orders
SELECT 
    c.CompanyName,
    c.CustomerID,
    o.OrderID
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.CustomerID = o.CustomerID;


/* =========================================================
   SECTION 3: PRODUCT ANALYSIS
   ========================================================= */

-- 12. Number of products per category
SELECT 
    CategoryID,
    COUNT(*) AS ProductCount
FROM Product
GROUP BY CategoryID;


-- 13. Products with prices above 20
SELECT 
    ProductName,
    UnitPrice
FROM Product
WHERE UnitPrice > 20
ORDER BY UnitPrice DESC;


-- 14. Product price classification
SELECT 
    ProductName,
    UnitPrice,
    CASE
        WHEN UnitPrice >= 50 THEN 'Expensive'
        WHEN UnitPrice >= 20 THEN 'Medium'
        ELSE 'Cheap'
    END AS ProductCategory
FROM Product;


/* =========================================================
   SECTION 4: SUBQUERY ANALYSIS
   ========================================================= */

-- 15. Products priced above the average product price
SELECT 
    ProductName,
    UnitPrice
FROM Product
WHERE UnitPrice > (
    SELECT AVG(UnitPrice)
    FROM Product
);


/* =========================================================
   SECTION 5: SALES ANALYSIS
   ========================================================= */

-- Sales calculation:
-- Sales = Quantity * UnitPrice * (1 - Discount)


-- 16. Total sales per order
WITH OrderSales AS (
    SELECT 
        OrderID,
        SUM(
            Quantity * UnitPrice * (1 - Discount)
        ) AS TotalSales
    FROM OrdersDetails
    GROUP BY OrderID
)
SELECT 
    OrderID,
    TotalSales
FROM OrderSales
ORDER BY TotalSales DESC;


-- 17. Orders with sales greater than 2000
WITH OrderSales AS (
    SELECT 
        OrderID,
        SUM(
            Quantity * UnitPrice * (1 - Discount)
        ) AS TotalSales
    FROM OrdersDetails
    GROUP BY OrderID
)
SELECT 
    OrderID,
    TotalSales
FROM OrderSales
WHERE TotalSales > 2000
ORDER BY TotalSales DESC;


-- 18. Total sales per product
WITH ProductSales AS (
    SELECT 
        ProductID,
        SUM(
            Quantity * UnitPrice * (1 - Discount)
        ) AS TotalSales
    FROM OrdersDetails
    GROUP BY ProductID
)
SELECT 
    ProductID,
    TotalSales
FROM ProductSales
ORDER BY TotalSales DESC;


/* =========================================================
   SECTION 6: TOP CUSTOMERS
   ========================================================= */

-- 19. Top 5 customers by total purchases
SELECT TOP 5
    c.CompanyName,
    SUM(
        od.Quantity * od.UnitPrice * (1 - od.Discount)
    ) AS TotalPurchases
FROM Customers AS c
JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
JOIN OrdersDetails AS od
    ON o.OrderID = od.OrderID
GROUP BY 
    c.CompanyName,
    c.CustomerID
ORDER BY TotalPurchases DESC;


/* =========================================================
   SECTION 7: YEARLY SALES PERFORMANCE
   ========================================================= */

-- 20. Total sales by year
SELECT 
    YEAR(o.OrderDate) AS SalesYear,
    SUM(
        od.Quantity * od.UnitPrice * (1 - od.Discount)
    ) AS TotalSales
FROM Orders AS o
JOIN OrdersDetails AS od
    ON o.OrderID = od.OrderID
GROUP BY YEAR(o.OrderDate)
ORDER BY SalesYear;


/* =========================================================
   SECTION 8: TOP PRODUCT IN EACH CATEGORY
   ========================================================= */

-- 21. Calculate product sales by category
WITH ProductSales AS (
    SELECT 
        cat.CategoryName,
        p.ProductID,
        p.ProductName,
        SUM(
            od.Quantity * od.UnitPrice * (1 - od.Discount)
        ) AS TotalSales
    FROM Categories AS cat
    JOIN Product AS p
        ON cat.CategoryID = p.CategoryID
    JOIN OrdersDetails AS od
        ON p.ProductID = od.ProductID
    GROUP BY 
        cat.CategoryName,
        p.ProductID,
        p.ProductName
),

-- Rank products inside each category
RankedProducts AS (
    SELECT 
        CategoryName,
        ProductID,
        ProductName,
        TotalSales,
        RANK() OVER (
            PARTITION BY CategoryName
            ORDER BY TotalSales DESC
        ) AS ProductRank
    FROM ProductSales
)

-- Top product from each category
SELECT 
    CategoryName,
    ProductName,
    TotalSales
FROM RankedProducts
WHERE ProductRank = 1
ORDER BY CategoryName;


/* =========================================================
   SECTION 9: WINDOW FUNCTIONS
   ========================================================= */

-- 22. Rank products by total sales
WITH ProductSales AS (
    SELECT 
        ProductID,
        SUM(
            Quantity * UnitPrice * (1 - Discount)
        ) AS TotalSales
    FROM OrdersDetails
    GROUP BY ProductID
)
SELECT 
    ProductID,
    TotalSales,
    RANK() OVER (
        ORDER BY TotalSales DESC
    ) AS SalesRank
FROM ProductSales
ORDER BY SalesRank;


/* =========================================================
   SECTION 10: DATA QUALITY CHECKS
   ========================================================= */

-- 23. Check duplicate OrderIDs in Orders
SELECT 
    OrderID,
    COUNT(*) AS [RowCount]
FROM Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;


-- 24. Check duplicate OrderID + ProductID combinations
-- in OrdersDetails
SELECT 
    OrderID,
    ProductID,
    COUNT(*) AS DuplicateCount
FROM OrdersDetails
GROUP BY OrderID, ProductID
HAVING COUNT(*) > 1;

-- 25. Check missing ShippedDate
SELECT 
    COUNT(*) AS MissingShipDates
FROM Orders
WHERE ShippedDate IS NULL;


-- 26. Check orders with no matching customer
SELECT 
    o.OrderID,
    o.CustomerID
FROM Orders AS o
LEFT JOIN Customers AS c
    ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;


/* =========================================================
   SECTION 11: DATE FILTERING / PERFORMANCE
   ========================================================= */

-- 27. Orders placed during 1997
SELECT 
    OrderID,
    OrderDate
FROM Orders
WHERE OrderDate >= '19970101'
  AND OrderDate < '19980101'
ORDER BY OrderDate;
```
