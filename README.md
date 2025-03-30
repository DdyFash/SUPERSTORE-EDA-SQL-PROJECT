# Superstore SQL Data Analysis Project

## Overview
This project explores the `Superstore` dataset using SQL queries to extract valuable business insights. The dataset contains information about orders, customers, sales, and shipping details. The analysis covers key aspects such as total sales, profits, customer loyalty, and month-over-month trends.

---

## SQL Queries and Insights

### 1. Retrieve Total Sales and Profit by Category
```sql
SELECT
    CATEGORY,
    SUM(SALES) TOTAL_SALES,
    SUM(PROFIT) TOTAL_PROFITS
FROM SUPERSTORE
GROUP BY CATEGORY;
```
**Insight:** This query helps identify which product categories generate the highest revenue and profitability.

### 2. Find the Top 5 Most Profitable Products
```sql
SELECT TOP 5
    PRODUCT_NAME,
    SUM(PROFIT) TOTAL_PROFIT
FROM SUPERSTORE
GROUP BY PRODUCT_NAME
ORDER BY SUM(PROFIT) DESC;
```
**Insight:** Understanding the most profitable products can guide inventory and marketing strategies.

### 3. Get the Total Number of Orders Placed in Each Region
```sql
SELECT
    REGION,
    COUNT(ORDER_ID) noOrders
FROM SUPERSTORE
GROUP BY REGION
ORDER BY COUNT(ORDER_ID) DESC;
```
**Insight:** This analysis helps identify high-demand regions for targeted sales strategies.

### 4. Find the Top 5 Customers with the Highest Number of Orders
```sql
SELECT TOP 5
    CUSTOMER_ID,
    CUSTOMER_NAME,
    COUNT(ORDER_ID) noOrders
FROM SUPERSTORE
GROUP BY CUSTOMER_NAME, CUSTOMER_ID
ORDER BY COUNT(ORDER_ID) DESC;
```
**Insight:** Recognizing top customers allows businesses to personalize engagement strategies.

### 5. Calculate the Average Discount Given per Sub-Category
```sql
SELECT
    SUB_CATEGORY,
    ROUND(AVG(DISCOUNT),3) AS AVG_DISCOUNT
FROM SUPERSTORE
GROUP BY SUB_CATEGORY;
```
**Insight:** Helps in evaluating discount strategies across different product sub-categories.

### 6. List All Orders Where Profit is Negative (Loss-Making Orders)
```sql
SELECT *
FROM SUPERSTORE
WHERE PROFIT < 0;
```
**Insight:** Identifies loss-making transactions for further investigation and strategy adjustments.

### 7. Find the Top 5 Cities with the Highest Sales Revenue
```sql
SELECT TOP 5
    CITY,
    ROUND(SUM(SALES),2) AS REVENUE
FROM SUPERSTORE
GROUP BY CITY
ORDER BY SUM(SALES) DESC;
```
**Insight:** Useful for geographical market analysis and expansion plans.

### 8. Get the Total Quantity Sold for Each Shipping Mode
```sql
SELECT
    SHIP_MODE,
    SUM(QUANTITY) AS TOTAL_QUANTITY_SOLD
FROM SUPERSTORE
GROUP BY SHIP_MODE
ORDER BY SUM(QUANTITY) DESC;
```
**Insight:** Analyzes the efficiency and popularity of different shipping modes.

### 9. Find the Top 5 Months with the Highest Sales in All Years
```sql
SELECT TOP 5
    DATENAME(MONTH, ORDER_DATE) AS Month,
    YEAR(ORDER_DATE) AS Year,
    ROUND(SUM(SALES),2) AS Revenue
FROM SUPERSTORE
WHERE YEAR(ORDER_DATE) BETWEEN 2011 AND 2013
GROUP BY YEAR(ORDER_DATE), DATENAME(MONTH, ORDER_DATE)
ORDER BY ROUND(SUM(SALES),2) DESC;
```
**Insight:** Identifies peak sales months for better seasonal planning.

### 10. Get the Top 5 States with the Highest Total Discount Applied
```sql
SELECT TOP 5
    STATE,
    ROUND(SUM(DISCOUNT),3) AS TOTAL_DISCOUNT
FROM SUPERSTORE
GROUP BY STATE
ORDER BY SUM(DISCOUNT) DESC;
```
**Insight:** Helps in reviewing discount policies across different regions.

### 11. Analyze Customer Loyalty by Ranking Customers Based on the Average Number of Days Between Orders
```sql
SELECT
    CUSTOMER_ID,
    AVG(dayUntilNextOrder) AS CustAVG
FROM (
    SELECT
        ORDER_ID,
        CUSTOMER_ID,
        ORDER_DATE AS CURRENTORDER,
        LEAD(ORDER_DATE) OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE) AS NEXT_ORDER,
        DATEDIFF(DAY, ORDER_DATE, LEAD(ORDER_DATE) OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE)) AS dayUntilNextOrder
    FROM SUPERSTORE
) T
GROUP BY CUSTOMER_ID;
```
**Insight:** Helps measure customer engagement and predict retention rates.

### 12. Month Over Month (MoM) Sales Analysis
```sql
SELECT
    ordermonth,
    Curtsales,
    Curtsales - Previousyear_sales AS MoM_change,
    ROUND(((Curtsales - Previousyear_sales) / Previousyear_sales) * 100,1) AS MoM_perc
FROM (
    SELECT
        SUM(sales) AS Curtsales,
        YEAR(order_date) AS ordermonth,
        LEAD(SUM(sales)) OVER(ORDER BY YEAR(order_date)) AS Previousyear_sales,
        LAG(SUM(sales)) OVER(ORDER BY YEAR(order_date)) AS Nextyear_sales
    FROM SUPERSTORE
    GROUP BY YEAR(order_date)
) T;
```
**Insight:** Provides insights into revenue growth trends over different years.

---

## Summary Report
This SQL analysis of the `Superstore` dataset revealed several key insights:
1. **Sales & Profitability:** The dataset highlights the best-performing categories, products, and regions.
2. **Customer Insights:** Top customers were identified based on order frequency and loyalty.
3. **Discount & Loss Analysis:** Loss-making orders and discount-heavy states were flagged for review.
4. **Shipping & Logistics:** Different shipping modes were evaluated based on total quantity sold.
5. **Seasonal Trends:** The highest revenue-generating months were determined for better planning.
6. **Month-over-Month Trends:** Yearly comparisons helped analyze business growth over time.

These insights can guide better decision-making in inventory management, pricing strategies, customer engagement, and logistics.

---

## How to Use
1. Clone this repository to your local machine.
2. Run the SQL scripts in Microsoft SQL Server Management Studio (SSMS) or any other compatible SQL tool.
3. Modify queries as needed for deeper analysis.

---

## Author
David Fashakin

