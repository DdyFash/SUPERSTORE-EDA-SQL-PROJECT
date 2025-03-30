USE [GitProjects]
GO

SELECT [Row_ID]
      ,[Order_ID]
      ,[Order_Date]
      ,[Ship_Date]
      ,[Ship_Mode]
      ,[Customer_ID]
      ,[Customer_Name]
      ,[Segment]
      ,[Country]
      ,[City]
      ,[State]
      ,[Postal_Code]
      ,[Region]
      ,[Product_ID]
      ,[Category]
      ,[Sub_Category]
      ,[Product_Name]
      ,[Sales]
      ,[Quantity]
      ,[Discount]
      ,[Profit]
  FROM [dbo].[Superstore]

GO

SELECT * FROM SUPERSTORE
--SQL QUESTIONS TO EXPLORE THE SUPERSTORE DATASET

-- 1 Retrieve total sales and profit by category
SELECT 
	CATEGORY,
	SUM(SALES) TOTAL_SALES,
	SUM(PROFIT)TOTAL_PROFITS
FROM SUPERSTORE
GROUP BY CATEGORY;

--2 Find the top 5 most profitable products
SELECT TOP 5
	PRODUCT_NAME,
	SUM(PROFIT) TOTAL_PROFIT
FROM SUPERSTORE
GROUP BY PRODUCT_NAME
ORDER BY SUM(PROFIT) DESC;

--3 Get the total number of orders placed in each region
SELECT
	REGION,
	COUNT(ORDER_ID) noOrders
FROM SUPERSTORE
GROUP BY REGION
ORDER BY COUNT(ORDER_ID)DESC;

--4 Find the top 5 customer who has placed the highest number of orders
SELECT TOP 5
	CUSTOMER_ID ,
	CUSTOMER_NAME,
	COUNT(ORDER_ID) noOrders
FROM SUPERSTORE
GROUP BY CUSTOMER_NAME, CUSTOMER_ID
ORDER BY COUNT(ORDER_ID)DESC;

--5 Calculate the average discount given per sub-category
SELECT
	SUB_CATEGORY,
	ROUND(AVG(DISCOUNT),3)
FROM SUPERSTORE
GROUP BY SUB_CATEGORY;

--6 List all orders where profit is negative (i.e., loss-making orders)
SELECT *
FROM SUPERSTORE
WHERE PROFIT < 0;

--7 Find the TOP 5 city with the highest sales revenue
SELECT TOP 5
	CITY,
	ROUND(SUM(SALES),2)REVENUE
FROM SUPERSTORE
GROUP BY CITY
ORDER BY SUM(SALES) DESC;

--8 Get the total quantity sold for each ship mode
SELECT
	SHIP_MODE,
	SUM(QUANTITY) [TOTAL QUANTITY SOLD]
FROM SUPERSTORE
GROUP BY SHIP_MODE
ORDER BY SUM(QUANTITY) DESC;

-- 9 Find the top 5 month with the highest sales in all years
SELECT TOP 5
	DATENAME( MONTH,ORDER_DATE)[Month],
	Year(ORDER_DATE)[Year],
	ROUND(SUM(SALES),2) [Revenue]
FROM SUPERSTORE
WHERE YEAR(ORDER_DATE) between '2011' and '2013'
GROUP BY Year(ORDER_DATE), DATENAME( MONTH,ORDER_DATE)
ORDER BY ROUND(SUM(SALES),2) DESC;

-- 10 Get the top 5 states with the highest total discount applied
SELECT TOP 5
	[STATE],
	ROUND(SUM(DISCOUNT),3)[TOTAL DISCOUNT]
FROM SUPERSTORE
GROUP BY [STATE]
ORDER BY SUM(DISCOUNT) DESC;

-- 11 ANALYZE CUSTOMER LOYALTY BY RANKING CUSTOMERS BASED ON THE AVERGAE NUMBER OF DAYS BETWEEN ORDERS
SELECT
	CUSTOMER_ID,
	AVG(dayUntilNextOrder) CustAVG
FROM(
SELECT 
	ORDER_ID,
	CUSTOMER_ID,
	ORDER_DATE CURRENTORDER,
	LEAD(ORDER_DATE) OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE)NEXT_ORDER,
	DATEDIFF(DAY,ORDER_DATE,LEAD(ORDER_DATE) OVER(PARTITION BY CUSTOMER_ID ORDER BY ORDER_DATE))dayUntilNextOrder
FROM Superstore
)T
GROUP BY CUSTOMER_ID

-- 12 MONTH OVER MONTH ANALYSIS
Select	[ordermonth],
		Curtsales,
		 [Curtsales]- [Previousyear_sales] MoM_change,
		round((([Curtsales]- [Previousyear_sales])/ [Previousyear_sales]) *100,1)MoM_perc
		 from(
SELECT
	sum(sales)Curtsales,
	year(order_date)[ordermonth],
	Lead(sum(sales)) over(order by year(order_date))[Previousyear_sales],
	Lag(sum(sales)) over(order by year(order_date))[Nextyear_sales]
FROM Superstore
GROUP BY year(order_date))t

