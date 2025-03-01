-- Database Schema: Othoba Sales Table
CREATE TABLE Othoba_sales (
    SubOrderId VARCHAR(50),
    OrderShippingExclTax DECIMAL(10, 2),
    ShipmentBy VARCHAR(50),
    ShippingStatus VARCHAR(50),
    OrderStatus VARCHAR(50),
    FinalOrderStatus VARCHAR(50),
    PaymentStatus VARCHAR(50),
    PreShipmentStatus VARCHAR(50),
    OrderUpdateStatus VARCHAR(50),
    ShippedDate TIMESTAMP,
    DeliveredDate TIMESTAMP,
    ShippingFullName VARCHAR(300),
    ShippingDivision VARCHAR(300),
    ShippingStateProvince VARCHAR(50),
    OrderVia VARCHAR(50),
    ShippingPhoneNumber VARCHAR(20),
    MobileNumber VARCHAR(20),
    OrderCreatedOn TIMESTAMP,
    Month VARCHAR(20),
    Year INT,
    PaymentMethod VARCHAR(50),
    OrderPaidOn TIMESTAMP,
    OrderCancelReason VARCHAR(50),
    SLNo INT,
    ProductName VARCHAR(400),
    ProductAttribute VARCHAR(255),
    SKU VARCHAR(50),
    Vendor VARCHAR(100),
    VendorGroup VARCHAR(100),
    DeliveryChannelType VARCHAR(100),
    PaymentCondition VARCHAR(50),
    Supplier VARCHAR(50),
    Quantity INT,
    RegularPrice DECIMAL(10, 2),
    RegularPrice2 DECIMAL(10, 2),
    UnitSellingPrice DECIMAL(10, 2),
    UnitSellingPrice2 DECIMAL(10, 2),
    TotalSellingPrice DECIMAL(10, 2),
    TotalSellingPrice2 DECIMAL(10, 2),
    UnitCostPrice DECIMAL(10, 2),
    UnitCostPrice2 DECIMAL(10, 2),
    TotalCostPrice DECIMAL(10, 2),
    TotalCostPrice2 DECIMAL(10, 2),
    Commission DECIMAL(10, 2),
    Profit DECIMAL(10, 2),
    SalesPerson VARCHAR(100),
    Category VARCHAR(100),
    B2C_B2B VARCHAR(50)
);

-- Sales Analysis Queries

-- 1. Total Orders per Year
SELECT COUNT(DISTINCT SubOrderId) AS total_orders, Year 
FROM othoba_sales
GROUP BY Year;

-- 2. Order Timeline
SELECT MIN(OrderCreatedOn) AS start_date, MAX(OrderCreatedOn) AS end_date
FROM othoba_sales;

-- 3. Average Order Value (AOV)
SELECT Year, ROUND(SUM(TotalSellingPrice) / COUNT(DISTINCT SubOrderId), 2) AS avg_order_value
FROM othoba_sales 
GROUP BY Year;

-- 4. Total Revenue
SELECT SUM(TotalSellingPrice) AS total_revenue, Year
FROM othoba_sales
WHERE FinalOrderStatus = 'Sales'
GROUP BY Year;

-- 5. Best-Performing Product Category
SELECT Category, SUM(TotalSellingPrice) AS total_revenue
FROM othoba_sales
WHERE B2C_B2B = 'Others' AND Year = '2023' AND FinalOrderStatus = 'Sales'
GROUP BY Category 
ORDER BY total_revenue DESC;

-- 6. Top 25 Customers by Spending
SELECT MobileNumber, ShippingFullName, ShippingDivision, SUM(TotalSellingPrice) AS total_spent
FROM othoba_sales 
WHERE B2C_B2B = 'Others' AND FinalOrderStatus = 'Sales'
GROUP BY MobileNumber, ShippingFullName, ShippingDivision
ORDER BY total_spent DESC
LIMIT 25;

-- 7. Repeat Customer Rate
SELECT (COUNT(DISTINCT CASE WHEN order_count > 1 THEN MobileNumber END) * 100.0 / COUNT(DISTINCT MobileNumber)) AS repeat_customer_rate
FROM (
    SELECT MobileNumber, COUNT(SubOrderId) AS order_count
    FROM othoba_sales
    GROUP BY MobileNumber
) AS customer_orders;

-- 8. Most Popular Order Time (Hour of the Day)
SELECT EXTRACT(HOUR FROM OrderCreatedOn) AS order_hour, COUNT(SubOrderId) AS order_count  
FROM othoba_sales WHERE Year = '2024'  
GROUP BY order_hour  
ORDER BY order_count DESC  
LIMIT 5;

-- 9. Most Orders by Day of the Week
SELECT day_of_week, total_sales
FROM (
    SELECT TO_CHAR(OrderCreatedOn, 'Day') AS day_of_week, SUM(TotalSellingPrice) AS total_sales
    FROM othoba_sales WHERE Year = '2023'
    GROUP BY day_of_week
) AS subquery
ORDER BY 
  CASE day_of_week
    WHEN 'Monday' THEN 1
    WHEN 'Tuesday' THEN 2
    WHEN 'Wednesday' THEN 3
    WHEN 'Thursday' THEN 4
    WHEN 'Friday' THEN 5
    WHEN 'Saturday' THEN 6
    WHEN 'Sunday' THEN 7
  END;

-- 10. Revenue Over Time
SELECT Month, SUM(total_price) OVER (ORDER BY Month) AS cumulative_revenue
FROM (
    SELECT Month, SUM(TotalSellingPrice) AS total_price
    FROM othoba_sales  
    GROUP BY Month
) AS daily_sales
ORDER BY Month DESC;

-- 11. Ranking Top Products by Revenue within Categories
WITH ranked_products AS (
    SELECT Category, ProductName, SUM(TotalSellingPrice) AS revenue,
    RANK() OVER (PARTITION BY Category ORDER BY SUM(TotalSellingPrice) DESC) AS rank
    FROM othoba_sales WHERE FinalOrderStatus = 'Sales'
    GROUP BY Category, ProductName
)
SELECT Category, ProductName, revenue
FROM ranked_products
WHERE rank <= 1;

-- 12. Category-Wise Order Cancellations
SELECT Category, COUNT(DISTINCT SubOrderId) AS cancel_count
FROM othoba_sales
WHERE FinalOrderStatus = 'Cancel'
GROUP BY Category 
ORDER BY cancel_count DESC;

-- 13. Top 5 Reasons for Order Cancellations
SELECT OrderCancelReason, COUNT(DISTINCT SubOrderId) AS reason_cancel
FROM othoba_sales
WHERE FinalOrderStatus = 'Cancel'
GROUP BY OrderCancelReason
ORDER BY reason_cancel DESC
LIMIT 5;

-- 14. Best-Selling Category by Season
SELECT 
    CASE
        WHEN Month IN ('November', 'December', 'January') THEN 'Fall'
        WHEN Month IN ('February', 'March', 'April') THEN 'Spring'
        WHEN Month IN ('May', 'June', 'July', 'August', 'September', 'October') THEN 'Summer'
    END AS season,
    Category,
    COUNT(DISTINCT SubOrderId) AS total_order
FROM othoba_sales
WHERE FinalOrderStatus = 'Sales' AND Year = '2023'
GROUP BY season, Category
ORDER BY season, total_order DESC
LIMIT 5;

-- 15. Fraudulent Order Detection
SELECT MobileNumber, ShippingFullName, 
    COUNT(DISTINCT SubOrderId) AS total_orders, 
    COUNT(CASE WHEN PaymentStatus IN ('Partially Paid', 'Pending', 'Voided') THEN 1 END) AS unpaid_orders, 
    COUNT(CASE WHEN FinalOrderStatus = 'Cancel' THEN 1 END) AS canceled_orders
FROM othoba_sales
GROUP BY MobileNumber, ShippingFullName
HAVING COUNT(CASE WHEN PaymentStatus IN ('Partially Paid', 'Pending', 'Voided') THEN 1 END) > 3 
AND COUNT(CASE WHEN FinalOrderStatus = 'Cancel' THEN 1 END) > 3
ORDER BY unpaid_orders DESC
LIMIT 10;
