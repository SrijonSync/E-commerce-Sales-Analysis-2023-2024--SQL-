
#  E-Commerce SQL Queries (Othoba.com)

## Project Overview

#### Objective

Othoba is a leading e-commerce platform in Bangladesh, offering a wide range of products, from electronics to fashion and groceries. Since its launch in 2017, it has gained popularity for its competitive pricing, reliable delivery services, and a user-friendly shopping experience. Catering to both B2C and B2B customers, Othoba has built a strong reputation for customer satisfaction and efficient logistics, making it one of the most trusted online shopping destinations in Bangladesh.

#### Data Source

🔴Confidential e-commerce database containing order details, customer transactions, delivery records, and profitability metrics.

## Analysis Areas

#### General Business Performance (Orders, Revenue, AOV)

#### Customer Behavior & Trends (Repeat Customers, Peak Order Times)

#### Order Fulfillment & Logistics (Delivery Delays, Late Shipments)

#### Profitability & Revenue Optimization (Top Categories, Margin Analysis)

#### Order Cancellations & Payment Issues (COD vs. Online, Refund Trends)

#### Fraud Detection & Risk Analysis (Suspicious Orders, High-Risk Transactions)


## SQL Queries for Analysis

### Creating Table
```sql
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
```

---

## **General Business Performance**

### Total Number of Orders per Year
```sql
SELECT COUNT(DISTINCT SubOrderId), Year AS total_orders
FROM othoba_sales
GROUP BY Year;
```

### Earliest and Latest Order Date
```sql
SELECT MIN(OrderCreatedOn) AS start_date, MAX(OrderCreatedOn) AS end_date
FROM othoba_sales;
```

### Average Order Value (AOV) per Year
```sql
SELECT year, ROUND(SUM(TotalSellingPrice)/COUNT(DISTINCT SubOrderId), 2) AS AVG_ODR_VALUE
FROM othoba_sales GROUP BY year;
```

### Total Revenue per Year
```sql
SELECT SUM(totalsellingprice), Year AS Total_revenue
FROM othoba_sales
WHERE FinalOrderStatus = 'Sales' GROUP BY Year;
```

### Best-Performing Product Categories (2023 & 2024)
```sql
SELECT CATEGORY, SUM(totalsellingprice) AS TOTAL_REV
FROM othoba_sales
WHERE B2C_B2B = 'Others' AND Year= '2023' AND FinalOrderStatus='Sales'
GROUP BY CATEGORY
ORDER BY TOTAL_REV DESC;
```
```sql
SELECT CATEGORY, SUM(totalsellingprice) AS TOTAL_REV
FROM othoba_sales
WHERE B2C_B2B = 'Others' AND Year= '2024' AND FinalOrderStatus='Sales'
GROUP BY CATEGORY
ORDER BY TOTAL_REV DESC;
```

---

## **Customer Behavior & Trends**

### Top 25 Customers Based on Total Spending
```sql
SELECT mobilenumber, ShippingFullName,ShippingDivision, SUM(totalsellingprice) AS total_spent
FROM othoba_sales
WHERE B2C_B2B = 'Others' AND FinalOrderStatus = 'Sales'
GROUP BY mobilenumber, ShippingFullName, ShippingDivision
ORDER BY total_spent DESC
LIMIT 25;
```

### Repeat Customer Rate
```sql
SELECT
 (COUNT(DISTINCT CASE WHEN order_count > 1 THEN mobilenumber END) * 100.0 / COUNT(DISTINCT mobilenumber)) AS repeat_customer_rate
FROM (
    SELECT mobilenumber, COUNT(SubOrderId) AS order_count
    FROM othoba_sales
    GROUP BY mobilenumber
) AS customer_orders;
```

---

## **Order Fulfillment & Logistics**

### Average Delivery Time per Shipping Division
```sql
SELECT ShippingDivision,
       AVG(EXTRACT(DAY FROM (DeliveredDate - ShippedDate))) AS avg_delivery_time
FROM othoba_sales
WHERE FinalOrderStatus = 'Sales' AND DeliveredDate IS NOT NULL
GROUP BY ShippingDivision
ORDER BY avg_delivery_time DESC;
```

### Most Late Deliveries by Shipping Division
```sql
SELECT
    ShippingDivision,
    COUNT(*) AS LateOrders
FROM othoba_sales
WHERE DeliveredDate > OrderPaidOn  
ORDER BY LateOrders DESC;
```

---

## **Order Cancellations & Payment Issues**

### Cancellation Rate per Category
```sql
SELECT Category, COUNT(DISTINCT SubOrderId) AS Cancel
FROM othoba_sales
WHERE FinalOrderStatus = 'Cancel'
GROUP BY Category
ORDER BY Cancel DESC;
```

### Top 5 Reasons for Order Cancellations
```sql
SELECT OrderCancelReason, COUNT(DISTINCT SubOrderID) AS Reason_Cancel
FROM Othoba_sales
WHERE FinalOrderStatus = 'Cancel'
GROUP BY OrderCancelReason
ORDER BY Reason_Cancel DESC
LIMIT 5;
```

### Customers with Multiple Shipping Addresses but Same Phone Number
```sql
SELECT
    ShippingPhoneNumber,ShippingFullName,
    COUNT(DISTINCT ShippingStateProvince) AS UniqueAddresses,
    COUNT(*) AS OrderCount
FROM othoba_sales
GROUP BY ShippingPhoneNumber, ShippingFullName
HAVING COUNT(DISTINCT ShippingStateProvince) > 1
ORDER BY OrderCount DESC;
```

---
#  **Final Recommendations**  
✅ **Reduce COD dependency** by offering **discounts on prepaid payments**.  
✅ **Improve delivery speed** by **partnering with better logistics providers**.  
✅ **Boost customer retention** with **personalized marketing campaigns**.  
✅ **Strengthen fraud detection** with **AI-based risk analysis**.  

---  



## Author
[@SrijonSync](https://github.com/SrijonSync)




