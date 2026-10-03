-- Customer & Sales Analytics | MySQL
-- Database: customer_sales | Table: orders
USE customer_sales;

-- 1. DATA QUALITY
SELECT COUNT(*) AS Total_Rows FROM orders;

SELECT COUNT(*) AS Total_Rows,
       COUNT(Order_ID) AS Order_ID_Count,
       COUNT(Customer_ID) AS Customer_ID_Count,
       COUNT(Order_Date) AS Order_Date_Count,
       COUNT(Sales) AS Sales_Count,
       COUNT(Profit) AS Profit_Count
FROM orders;

SELECT Order_ID, COUNT(*) AS Order_Count
FROM orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS Invalid_Rows
FROM orders
WHERE Quantity <= 0 OR Sales <= 0 OR Profit <= 0;

-- 2. OVERALL BUSINESS SUMMARY
SELECT COUNT(*) AS Total_Orders,
       COUNT(DISTINCT Customer_ID) AS Total_Customers,
       SUM(Quantity) AS Total_Quantity,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit,
       ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Profit_Margin
FROM orders;

-- 3. CUSTOMER ANALYSIS
SELECT Customer_ID, Customer_Name, COUNT(*) AS Total_Orders,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit
FROM orders
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Sales DESC;

SELECT Customer_ID, Customer_Name, COUNT(*) AS Total_Orders,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit
FROM orders
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;

SELECT Customer_ID, Customer_Name, COUNT(*) AS Total_Orders,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit,
       ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Profit_Margin
FROM orders
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Profit DESC
LIMIT 10;

SELECT Customer_ID, Customer_Name, COUNT(*) AS Total_Orders,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit
FROM orders
GROUP BY Customer_ID, Customer_Name
HAVING COUNT(*) > 1
ORDER BY Total_Orders DESC, Total_Sales DESC;

SELECT CASE
         WHEN Total_Orders = 1 THEN 'One-time'
         WHEN Total_Orders BETWEEN 2 AND 4 THEN 'Regular'
         ELSE 'Frequent'
       END AS Customer_Type,
       COUNT(*) AS Number_of_Customers,
       ROUND(SUM(Total_Sales),2) AS Total_Sales,
       ROUND(SUM(Total_Profit),2) AS Total_Profit
FROM (
    SELECT Customer_ID, COUNT(*) AS Total_Orders,
           SUM(Sales) AS Total_Sales,
           SUM(Profit) AS Total_Profit
    FROM orders
    GROUP BY Customer_ID
) AS Customer_Summary
GROUP BY Customer_Type
ORDER BY Total_Sales DESC;

-- 4. SEGMENT ANALYSIS
SELECT Segment, COUNT(*) AS Total_Orders,
       COUNT(DISTINCT Customer_ID) AS Total_Customers,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit,
       ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Profit_Margin
FROM orders
GROUP BY Segment
ORDER BY Total_Sales DESC;

SELECT Segment, COUNT(*) AS Total_Orders,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(AVG(Sales),2) AS Average_Order_Value,
       ROUND(SUM(Profit),2) AS Total_Profit
FROM orders
GROUP BY Segment
ORDER BY Average_Order_Value DESC;

-- 5. REGION ANALYSIS
SELECT Region, COUNT(*) AS Total_Orders,
       COUNT(DISTINCT Customer_ID) AS Total_Customers,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit,
       ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Profit_Margin
FROM orders
GROUP BY Region
ORDER BY Total_Sales DESC;

-- 6. CATEGORY ANALYSIS
SELECT Category, COUNT(*) AS Total_Orders,
       COUNT(DISTINCT Customer_ID) AS Total_Customers,
       SUM(Quantity) AS Total_Quantity,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit,
       ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Profit_Margin
FROM orders
GROUP BY Category
ORDER BY Total_Sales DESC;

-- 7. PRODUCT ANALYSIS
SELECT Product, Category, COUNT(*) AS Total_Orders,
       SUM(Quantity) AS Total_Quantity,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit,
       ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Profit_Margin
FROM orders
GROUP BY Product, Category
ORDER BY Total_Sales DESC;

SELECT Product, Category,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit,
       ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Profit_Margin
FROM orders
GROUP BY Product, Category
HAVING SUM(Sales) > (
    SELECT AVG(Product_Sales)
    FROM (
        SELECT SUM(Sales) AS Product_Sales
        FROM orders
        GROUP BY Product
    ) AS Product_Summary
)
ORDER BY Profit_Margin ASC;

-- 8. MONTHLY SALES & CUSTOMER TREND
SELECT DATE_FORMAT(Order_Date,'%Y-%m') AS Sales_Month,
       COUNT(*) AS Total_Orders,
       SUM(Quantity) AS Total_Quantity,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit
FROM orders
GROUP BY DATE_FORMAT(Order_Date,'%Y-%m')
ORDER BY Sales_Month;

SELECT DATE_FORMAT(Order_Date,'%Y-%m') AS Sales_Month,
       COUNT(*) AS Total_Orders,
       COUNT(DISTINCT Customer_ID) AS Unique_Customers,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit
FROM orders
GROUP BY DATE_FORMAT(Order_Date,'%Y-%m')
ORDER BY Sales_Month;

-- 9. MONTHLY REGIONAL PERFORMANCE
SELECT DATE_FORMAT(Order_Date,'%Y-%m') AS Sales_Month,
       Region, COUNT(*) AS Total_Orders,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit
FROM orders
GROUP BY DATE_FORMAT(Order_Date,'%Y-%m'), Region
ORDER BY Sales_Month, Total_Sales DESC;

-- 10. PAYMENT METHOD
SELECT Payment_Mode, COUNT(*) AS Total_Orders,
       COUNT(DISTINCT Customer_ID) AS Total_Customers,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit,
       ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Profit_Margin
FROM orders
GROUP BY Payment_Mode
ORDER BY Total_Sales DESC;

-- 11. DISCOUNT IMPACT
SELECT Discount, COUNT(*) AS Total_Orders,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit,
       ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Profit_Margin
FROM orders
GROUP BY Discount
ORDER BY Discount;

-- 12. TOP 10 HIGH-VALUE ORDERS
SELECT Order_ID, Order_Date, Customer_ID, Customer_Name,
       Segment, Category, Product, Quantity,
       ROUND(Sales,2) AS Sales,
       ROUND(Profit,2) AS Profit,
       Discount, Payment_Mode
FROM orders
ORDER BY Sales DESC
LIMIT 10;

-- 13. CATEGORY × SEGMENT
SELECT Category, Segment, COUNT(*) AS Total_Orders,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit,
       ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Profit_Margin
FROM orders
GROUP BY Category, Segment
ORDER BY Category, Total_Sales DESC;

-- 14. REGION × SEGMENT
SELECT Region, Segment, COUNT(*) AS Total_Orders,
       COUNT(DISTINCT Customer_ID) AS Total_Customers,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit,
       ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Profit_Margin
FROM orders
GROUP BY Region, Segment
ORDER BY Region, Total_Sales DESC;
