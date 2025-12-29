--SQL Retail Sales Analysis - p1

CREATE DATABASE sql_project_p2;

--CREATE TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id	INT,
				gender	VARCHAR(15),
				age	INT,
				category VARCHAR(15),	
				quantity INT,	
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			);

SELECT * FROM retail_sales
LIMIT 10

SELECT 
	COUNT(*)
FROM retail_sales

-- DATA CLEANING
SELECT* FROM retail_sales
WHERE transactions_id IS NULL

SELECT* FROM retail_sales
WHERE sale_date IS NULL

SELECT* FROM retail_sales
WHERE sale_time IS NULL

SELECT* FROM retail_sales
WHERE customer_id IS NULL

SELECT* FROM retail_sales
WHERE gender IS NULL

SELECT* FROM retail_sales
WHERE age IS NULL



SELECT* FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL 
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL 
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--DATA EXPLORATION
-- HOW MANY SALES DO WE HAVE?
SELECT COUNT (*) AS total_sale FROM retail_sales

-- HOW MANY UNIQUE CUSTOMERS WE HAVE?
SELECT COUNT (DISTINCT customer_id) AS total_customer FROM retail_sales

--HOW MANY CATEGORY WE HAVE?
SELECT DISTINCT category FROM retail_sales

--DATA ANALYSIS & BUSSINESS KEY PROBLEMS & ANSWERS
	
--QUE1: WRITE A SQL QUERY TO RETRIEVE ALL COLUMNS FOR SALES MADE ON '2022-11-05'

SELECT 
* FROM retail_sales
WHERE sale_date = '2022-11-05';


--QUE2: WRITE A SQL QUERY TO RETRIEVE ALL TRANSACTIONS WHERE THE CATEGORY IS 'CLOTHING' AND THE QUANTITY SOLD IS MORE THAN 4 IN THE MONTH OF NOV-2022
SELECT 
 	  *
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
	AND
	quantity >= 4


--QUE3: WRITE A SQL QUERY TO CALCULATE THE TOTAL SALES (total_sale) FOR EACH CATEGORY?

SELECT
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
	FROM retail_sales
	GROUP BY 1

--QUE4: WRITE A SQL QUERY TO FIND THE AVERAGE AGE OF CUSTOMERS WHO PURCHASED ITEMS  FROM THE 'BEAUTY' CATEGORY?

SELECT
	ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

--QUE5: WRITE A SQL QUERY TO FIND ALL TRANSACTIONS WHERE THE total_sale IS GREATER THAN1000.	

SELECT *
FROM retail_sales
WHERE  total_sale > 1000

--QUE6: WRITE A SQL QUERY TO FIND THE TOTAL NUMBER OF TRANSACTIONS (transaction_id) MADE BY EACH GENDER IN EACH CATEGORY.

SELECT 
	category,
	gender,
	COUNT(*) as total_trans
FROM retail_sales
GROUP 
	BY 
	category,
	gender
ORDER BY 1

--QUE7: WRITE A SQL QUERY TO CALCULATE THE AVERAGE SALES OF EACH MONTH. FIND OUT THE  BEST SELLING MONTH IN EACH YEAR
SELECT * FROM
(
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY 1, 2
) AS t1
WHERE rank = 1;


--QUE8: WRITE A SQL QUERY TO FIND THE TOP 5 CUSTOMERS BASED ON THE HIGHEST TOTAL SALES
SELECT 
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--QUE9: WRITE A SQL QUERY TO FIND THE NUMBER OF UNIQUE CUSTOMERS WHO PURCHASED ITEMS FROM EACH CATEGORY.
SELECT 
	category,
	COUNT(DISTINCT customer_id) as unique_customer
FROM retail_sales	
GROUP BY category


-- Q.10 Write a SQL query to create each shift and the number of orders (Example: Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale AS
(
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

-- END OF PROJECT