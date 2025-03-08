--Othoba E-commerce Data Analysis

---Creating Table
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


--General Business Analysis

---What is the total number of orders placed in each year? 

SELECT COUNT(DISTINCT SubOrderId), Year AS total_orders
FROM othoba_sales
GROUP BY Year;

---What is the earliest and latest order date in the dataset? 

SELECT MIN(OrderCreatedOn) AS start_date, MAX(OrderCreatedOn) AS end_date
FROM othoba_sales;

---What is the average order value (AOV) for each year? 
SELECT year, ROUND(SUM(TotalSellingPrice)/COUNT(DISTINCT SubOrderId), 2) AS AVG_ODR_VALUE
FROM othoba_sales group by year;


---What is the total revenue generated in each year? 
SELECT SUM(totalsellingprice), Year AS Total_revenue
FROM othoba_sales
WHERE FinalOrderStatus = 'Sales' group by Year;


----What are the best-performing product categories in 2023 and 2024? 
SELECT CATEGORY, SUM(totalsellingprice) AS TOTAL_REV
FROM othoba_sales
WHERE B2C_B2B = 'Others' and Year= '2023' and FinalOrderStatus='Sales'
GROUP BY CATEGORy 
ORDER BY TOTAL_REV DESC;
----
SELECT CATEGORY, SUM(totalsellingprice) AS TOTAL_REV
FROM othoba_sales
WHERE B2C_B2B = 'Others' and Year= '2024' and FinalOrderStatus='Sales'
GROUP BY CATEGORy 
ORDER BY TOTAL_REV DESC;


---Customer Behavior & Trends

----Who are the top 25 customers based on total spending? 
SELECT mobilenumber, ShippingFullName,ShippingDivision, SUM(totalsellingprice) AS total_spent
FROM othoba_sales 
WHERE B2C_B2B = 'Others' AND FinalOrderStatus = 'Sales'
GROUP BY mobilenumber, ShippingFullName, ShippingDivision
ORDER BY total_spent DESC
LIMIT 25;


---What is the repeat customer rate?
SELECT
 (COUNT(DISTINCT CASE WHEN order_count > 1 THEN mobilenumber END) * 100.0 / COUNT(DISTINCT mobilenumber)) AS repeat_customer_rate
FROM (
    SELECT mobilenumber, COUNT(SubOrderId) AS order_count
    FROM othoba_sales
    GROUP BY mobilenumber
) AS customer_orders;



--What is the most popular order time (hour of the day)?
SELECT EXTRACT(HOUR FROM OrderCreatedOn) AS order_hour, COUNT(SubOrderId) AS order_count  
FROM othoba_sales where Year='2024'  
GROUP BY order_hour  
ORDER BY order_count DESC  
LIMIT 5;
-----
SELECT EXTRACT(HOUR FROM OrderCreatedOn) AS order_hour, COUNT(SubOrderId) AS order_count  
FROM othoba_sales where Year='2023'  
GROUP BY order_hour  
ORDER BY order_count DESC  
LIMIT 5;

----Weekly Most order Days

SELECT day_of_week, total_sales
FROM (
    SELECT TO_CHAR(OrderCreatedOn, 'Day') AS day_of_week, SUM(totalsellingprice) AS total_sales
    FROM othoba_sales where Year = '2023'
    GROUP BY day_of_week
) AS subquery
ORDER BY 
  CASE 
    WHEN day_of_week = 'Monday' THEN 1
    WHEN day_of_week = 'Tuesday' THEN 2
    WHEN day_of_week = 'Wednesday' THEN 3
    WHEN day_of_week = 'Thursday' THEN 4
    WHEN day_of_week = 'Friday' THEN 5
    WHEN day_of_week = 'Saturday' THEN 6
    WHEN day_of_week = 'Sunday' THEN 7
  END;
------Weekly Most order Days
SELECT day_of_week, total_sales
FROM (
    SELECT TO_CHAR(OrderCreatedOn, 'Day') AS day_of_week, SUM(totalsellingprice) AS total_sales
    FROM othoba_sales where Year = '2024'
    GROUP BY day_of_week
) AS subquery
ORDER BY 
  CASE 
    WHEN day_of_week = 'Monday' THEN 1
    WHEN day_of_week = 'Tuesday' THEN 2
    WHEN day_of_week = 'Wednesday' THEN 3
    WHEN day_of_week = 'Thursday' THEN 4
    WHEN day_of_week = 'Friday' THEN 5
    WHEN day_of_week = 'Saturday' THEN 6
    WHEN day_of_week = 'Sunday' THEN 7
  END;
  
---What percentage of customers are one-time buyers vs. repeat buyers?
SELECT 
Mobilenumber,
 COUNT(*) AS TotalOrders,
 CASE 
 WHEN COUNT(*) = 1 THEN 'One-Time Buyer'
   ELSE 'Repeat Customer'
 END AS CustomerType
FROM othoba_sales
GROUP BY Mobilenumber
ORDER BY TotalOrders DESC;


---Order Fulfillment & Logistics

--What is the average delivery time per shipping division? 
SELECT ShippingDivision, 
       AVG(EXTRACT(DAY FROM (DeliveredDate - ShippedDate))) AS avg_delivery_time
FROM othoba_sales
WHERE FinalOrderStatus = 'Sales' AND DeliveredDate IS NOT NULL
GROUP BY ShippingDivision
ORDER BY avg_delivery_time DESC;

--Which shipping divisions have the most late deliveries? 
SELECT 
    ShippingDivision,
    COUNT(*) AS LateOrders
FROM othoba_sales
WHERE DeliveredDate > OrderPaidOn  
ORDER BY LateOrders DESC;

--What percentage of orders were on-time vs. delayed? 
SELECT 
    CASE 
     WHEN DeliveredDate > OrderPaidOn THEN 'Late'
     ELSE 'On-Time'
    END AS DeliveryStatus,
    COUNT(DISTINCT SubOrderId) AS DistinctOrderCount,
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN OrderStatus = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledOrders
FROM othoba_sales
GROUP BY DeliveryStatus;

---Profitability & Revenue Optimization

--Which product categories have the highest and lowest profit margins? 
WITH ranked_products AS (
 SELECT category, ProductName, SUM(totalsellingprice) AS revenue,
 RANK() OVER (PARTITION BY category ORDER BY SUM(totalsellingprice) DESC) AS rank
  FROM othoba_sales where FinalOrderStatus='Sales'
   GROUP BY category, ProductName
)
SELECT category, ProductName, revenue
FROM ranked_products
WHERE rank <= 1;

----What is the best Selling Category by Season?
select case
when month in ('November', 'December','January') then 'Fall'
when month in ('February', 'March','April') then 'Spring'
when month in ('May', 'June','July','August', 'Spetember','October') then 'Summer'
end as season,
 Category,
Count(Distinct SubOrderId) as total_order
From Othoba_sales
where FinalOrderStatus = 'Sales' and Year='2023'
Group By Season, Category
Order by Season, total_order DESC limit 5;

--What are the most profitable products in terms of margin? 
WITH ranked_products AS (
  SELECT category, ProductName, COUNT( Quantity) AS unit,
    RANK() OVER (PARTITION BY category ORDER BY COUNT(Quantity) DESC) AS rank
    FROM othoba_sales 
    GROUP BY category, ProductName
)
SELECT category, ProductName, unit
FROM ranked_products
WHERE rank <= 1
order by unit DESC;

--How has revenue trended over time?

SELECT Month,
 SUM(total_price) OVER (ORDER BY Month) AS cumulative_revenue
FROM (
  SELECT Month, SUM(totalsellingprice) AS total_price
  FROM othoba_sales  
  GROUP BY Month
) AS daily_sales
ORDER BY Month DESC;


--Order Cancellations & Payment Issues

--What is the cancellation rate of categories?
SELECT Category, COUNT(DISTINCT SubOrderId) AS Cancel
FROM othoba_sales
WHERE FinalOrderStatus = 'Cancel'
GROUP BY Category 
ORDER BY Cancel DESC;

--What are the top 5 reasons customers cancel orders? 
SELECT  OrderCancelReason, Count(DISTINCT SubOrderID)
as Reason_Cancel from Othoba_sales
Where FinalOrderStatus = 'Cancel'
Group by  OrderCancelReason
Order by  Reason_Cancel desc LIMIT 5;


--Which payment methods have the highest failed transactions? 
SELECT 
PaymentMethod,
COUNT(*) AS TotalTransactions,
SUM(CASE WHEN PaymentStatus = 'Voided' THEN 1 ELSE 0 END) AS FailedTransactions
FROM othoba_sales
GROUP BY PaymentMethod
ORDER BY FailedTransactions DESC;

--What are the top 10 suspicious customers based on failed payments and cancellations? 
SELECT Mobilenumber, ShippingFullName, 
 COUNT(DISTINCT SubOrderId) AS total_orders, 
COUNT(CASE WHEN PaymentStatus IN ('Partially Paid', 'Pending', 'Voided') THEN 1 END) AS unpaid_orders,
COUNT(CASE WHEN FinalOrderStatus = 'Cancel' THEN 1 END) AS canceled_orders
FROM othoba_sales
GROUP BY mobilenumber, ShippingFullName
HAVING COUNT(CASE WHEN PaymentStatus IN ('Partially Paid', 'Pending', 'Voided') THEN 1 END) > 3 
   AND COUNT(CASE WHEN FinalOrderStatus = 'Cancel' THEN 1 END) > 3
ORDER BY unpaid_orders DESC limit 10;

----How many orders had the same phone number but multiple shipping addresses? 
SELECT 
    ShippingPhoneNumber,ShippingFullName, 
    COUNT(DISTINCT ShippingStateProvince) AS UniqueAddresses, 
    COUNT(*) AS OrderCount
FROM othoba_sales
GROUP BY ShippingPhoneNumber, ShippingFullName
HAVING COUNT(DISTINCT ShippingStateProvince) > 1
ORDER BY OrderCount DESC;

----
SELECT * 
FROM othoba_sales
WHERE TotalSellingPrice > (SELECT AVG(TotalSellingPrice) + 3 * STDDEV(TotalSellingPrice) FROM othoba_sales);








