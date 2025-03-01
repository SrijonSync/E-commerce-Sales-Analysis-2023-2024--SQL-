## Project Overview

This SQL project focuses on analyzing sales, orders, and customer behavior using structured queries. It covers revenue analysis, customer segmentation, product performance, fraud detection, and order trends. The project is designed to provide actionable insights that drive business decisions, improve operational efficiency, and enhance customer engagement.

## Project Structure

# Othoba_SQL_Project/
│-- README.md  # Project Documentation
│-- sql_queries/
│   │-- create_table.sql  # Schema definition and table creation
│   │-- sales_analysis.sql  # Revenue, AOV, and order analysis
│   │-- customer_analysis.sql  # Customer segmentation and behavior
│   │-- product_analysis.sql  # Top-performing categories and products
│   │-- fraud_detection.sql  # Fraud pattern identification
│   │-- cancellations.sql  # Order cancellation insights
│-- sample_data/ (Optional)
│   │-- sample_orders.csv  # Sample dataset for testing
│-- reports/ (Optional)
│   │-- insights_summary.pdf  # Analytical findings and business insights

## Dataset Description

Order & Status Details: Order ID, Order Status, Payment Status, Shipping Information.

Customer Information: Customer Name, Contact Details, Geographic Location.

Product Attributes: Category, Vendor, SKU, Pricing Details.

Time-Based Attributes: Order Date, Shipment Date, Delivery Date.

Financial Metrics: Revenue, Profit, Commission, Discounts.

## Confidentiality Notice: The dataset used in this project is confidential. Sample data is provided solely for demonstration purposes.

Key Analytical Insights

### Sales & Revenue Performance

### Total Orders Per Year

### Average Order Value (AOV)

### Total Revenue by Year

### Revenue Trends Over Time

### Product & Customer Insights

### Best-Selling Product Categories

### Top 25 Customers by Spending

### Repeat Customer Rate

### Top Products by Revenue & Quantity

### Order Trends & Operational Efficiency

### Popular Order Times (Hourly Distribution)

### Weekly Sales Performance

### Best-Selling Categories by Season

### Division-Wise Average Delivery Time

### Cancellations & Fraud Detection

### Category-Wise Cancellations

### Top 5 Reasons for Order Cancellations

### Fraudulent Order Detection (Unpaid & Canceled Orders)

# Business Questions Addressed

#### Total orders

SELECT COUNT(DISTINCT SubOrderId), Year AS total_orders
FROM othoba_sales
GROUP BY Year;

#### Order Timeline

SELECT MIN(OrderCreatedOn) AS start_date, MAX(OrderCreatedOn) AS end_date
FROM othoba_sales;

#### What is the Average_Order_Value_(AOV)?

SELECT year, ROUND(SUM(TotalSellingPrice)/COUNT(DISTINCT SubOrderId), 2) AS AVG_ODR_VALUE
FROM othoba_sales group by year;

#### What is the total revenue?
SELECT SUM(totalsellingprice), Year AS Total_revenue
FROM othoba_sales
WHERE FinalOrderStatus = 'Sales' group by Year;

#### What are the Best-Performing Product Category?

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

#### SHow Top 25 Customers by Spending


SELECT mobilenumber, ShippingFullName,ShippingDivision, SUM(totalsellingprice) AS total_spent
FROM othoba_sales 
WHERE B2C_B2B = 'Others' AND FinalOrderStatus = 'Sales'
GROUP BY mobilenumber, ShippingFullName, ShippingDivision
ORDER BY total_spent DESC
LIMIT 25;


#### What is the Repeat_Customer_Rate?

SELECT
    (COUNT(DISTINCT CASE WHEN order_count > 1 THEN mobilenumber END) * 100.0 / COUNT(DISTINCT mobilenumber)) AS repeat_customer_rate
FROM (
    SELECT mobilenumber, COUNT(SubOrderId) AS order_count
    FROM othoba_sales
    GROUP BY mobilenumber
) AS customer_orders;



#### What is the most popular order time (hour of the day)?

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

#### In which days of the week most order comes?

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

#### Show Revenue Over Time

SELECT Month,
       SUM(total_price) OVER (ORDER BY Month) AS cumulative_revenue
FROM (
     SELECT Month, SUM(totalsellingprice) AS total_price
     FROM othoba_sales  
     GROUP BY Month
) AS daily_sales
ORDER BY Month DESC;


#### Ranking Top Products by Revenue within Categories

WITH ranked_products AS (
     SELECT category, ProductName, SUM(totalsellingprice) AS revenue,
    RANK() OVER (PARTITION BY category ORDER BY SUM(totalsellingprice) DESC) AS rank
     FROM othoba_sales where FinalOrderStatus='Sales'
     GROUP BY category, ProductName
)
SELECT category, ProductName, revenue
FROM ranked_products
WHERE rank <= 1;

#### RankingTopProductsbyQuantitywithinCategories

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




####  Which category faced most cancel order?
SELECT Category, COUNT(DISTINCT SubOrderId) AS Cancel
FROM othoba_sales
WHERE FinalOrderStatus = 'Cancel'
GROUP BY Category 
ORDER BY Cancel DESC;

#### Top 5 reasons for canceling order
SELECT  OrderCancelReason, Count(DISTINCT SubOrderID)
as Reason_Cancel from Othoba_sales
Where FinalOrderStatus = 'Cancel'
Group by  OrderCancelReason
Order by  Reason_Cancel desc LIMIT 5;


#### Best Selling Category by Season 

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

#### Division wise average delivery time 
SELECT ShippingDivision, 
       AVG(EXTRACT(DAY FROM (DeliveredDate - ShippedDate))) AS avg_delivery_time
FROM othoba_sales
WHERE FinalOrderStatus = 'Sales' AND DeliveredDate IS NOT NULL
GROUP BY ShippingDivision
ORDER BY avg_delivery_time DESC;

#### Farud Order Calcualtion

SELECT Mobilenumber, ShippingFullName, 
       COUNT(DISTINCT SubOrderId) AS total_orders, 
       COUNT(CASE WHEN PaymentStatus IN ('Partially Paid', 'Pending', 'Voided') THEN 1 END) AS unpaid_orders,  -- Fixed here
       COUNT(CASE WHEN FinalOrderStatus = 'Cancel' THEN 1 END) AS canceled_orders
FROM othoba_sales
GROUP BY mobilenumber, ShippingFullName
HAVING COUNT(CASE WHEN PaymentStatus IN ('Partially Paid', 'Pending', 'Voided') THEN 1 END) > 3 
   AND COUNT(CASE WHEN FinalOrderStatus = 'Cancel' THEN 1 END) > 3
ORDER BY unpaid_orders DESC limit 10;


## Tools & Technologies Used

Database Management: PostgreSQL 

Query Execution:  pgAdmin 

Data Visualization: Power BI 





License & Disclaimer

This project is intended for educational and analytical purposes only. The dataset is strictly confidential and should not be used for commercial applications.
