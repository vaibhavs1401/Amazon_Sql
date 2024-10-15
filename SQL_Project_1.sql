USE sql_project1;

CREATE TABLE retail_sales (
    transactions_id INT,	
    sale_date DATE,	
    sale_time TIME,	
    customer_id INT,
    gender VARCHAR(50), 
    age INT,
    category VARCHAR(50),
    quantity INT,
    price_per_unit INT,
    cogs FLOAT,
    total_sale INT
);

SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*) FROM retail_sales;

-- CHECK NULL Values
SELECT * FROM retail_sales 
WHERE transactions_id IS NULL

SELECT * FROM retail_sales 
WHERE sale_date IS NULL

SELECT * FROM retail_sales 
WHERE sale_time IS NULL

SELECT * FROM retail_sales 
WHERE customer_id IS NULL

SELECT * FROM retail_sales 
WHERE gender IS NULL

SELECT * FROM retail_sales 
WHERE age IS NULL

SELECT * FROM retail_sales 
WHERE category IS NULL

SELECT * FROM retail_sales 
WHERE quantity IS NULL

SELECT * FROM retail_sales 
WHERE price_per_unit IS NULL

SELECT * FROM retail_sales 
WHERE cogs IS NULL

SELECT * FROM retail_sales 
WHERE total_sale IS NULL

SELECT transactions_id, quantity, age, gender 
FROM retail_sales 
WHERE transactions_id = 679;


DELETE FROM retail_sales
WHERE transactions_id IS NULL
   OR quantity IS NULL
   OR age IS NULL
   OR gender IS NULL
   OR sale_time IS NULL
   OR sale_date IS NULL
   OR category IS NULL
   OR cogs IS NULL
   OR price_per_unit IS NULL
   OR total_sale IS NULL;


-- How many sales we have?

SELECT SUM(total_sale) as total_sale FROM retail_sales


-- Total customers
SELECT COUNT(customer_id) FROM retail_sales

-- UNIQUE CUSTOMERS

SELECT COUNT(DISTINCT customer_id) FROM retail_sales

-- Unique category

SELECT COUNT(DISTINCT category) FROM retail_sales

-- Which are they

SELECT DISTINCT category FROM retail_sales

-- Data Analaysis 

-- Q.1 Write a SQL Query to retreive all columns for sales made on '2022-11-05'

SELECT * FROM retail_sales WHERE sale_date = '2022-11-05'

-- Write a query to retreive all the transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

SELECT SUM(quantity) AS total_quantity
FROM retail_sales 
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  AND quantity >= 4;


-- Q.3 Write a SQL Query to calculate total sales for each category

SELECT SUM(total_sale) AS total_sales, 
       COUNT(transactions_id) AS total_orders, 
       category 
FROM retail_sales 
GROUP BY category;



-- Q.4 Find the average age of customers from beauty category

SELECT AVG(age) as Avg_Age 
FROM retail_sales WHERE category = 'Beauty'

SELECT ROUND(AVG(age), 2) as Avg_Age 
FROM retail_sales WHERE category = 'Beauty'


-- Q.5 Write a SQL query to find out all transactions where the total_sale is greater than 1000

SELECT * FROM retail_sales 
WHERE total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions transactions_id made by each gender in each category.

SELECT COUNT(*) as total_trans, category, gender FROM retail_sales
GROUP BY category, gender

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

SELECT
	YEAR (sale_date) as year,
    MONTH (sale_date) as month,
    AVG(total_sale) as avg_total_sales
FROM retail_sales
GROUP BY 1, 2
ORDER BY 1, 2

WITH MonthlySales AS (
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_total_sales
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT 
    year,
    month,
    avg_total_sales,
    RANK() OVER (PARTITION BY year ORDER BY avg_total_sales DESC) AS sales_rank
FROM MonthlySales
ORDER BY year, sales_rank;

SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    AVG(total_sale) AS avg_total_sales,
    RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS sales_rank
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY year, sales_rank;


SELECT * 
FROM (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_total_sales,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS sales_rank
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE sales_rank = 1
ORDER BY year, month;

SELECT year, month, avg_total_sales
FROM (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        ROUND(AVG(total_sale), 2) AS avg_total_sales,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS sales_rank
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE sales_rank = 1
ORDER BY year, month;


-- Q.8 Write a query to find the top 5 customers based on highest total sales 

SELECT customer_id, age, gender, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id, age, gender
ORDER BY total_sales DESC
LIMIT 5;


SELECT COUNT(DISTINCT customer_id) FROM retail_sales

-- Q.9 Write a query to find the number unqiue customers who purchased items from each category

SELECT COUNT(DISTINCT customer_id) as Unique_Customers, category 
FROM retail_sales
GROUP BY category 


-- Q.10 Write a SQL Query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening > 17) 


SELECT *, 
    CASE 
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) >= 12 AND HOUR(sale_time) < 17 THEN 'Afternoon' 
        WHEN HOUR(sale_time) >= 17 THEN 'Evening'
    END AS shift 
FROM retail_sales;


WITH Shift_Sales
AS
(  SELECT *, 
    CASE 
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) >= 12 AND HOUR(sale_time) < 17 THEN 'Afternoon' 
        WHEN HOUR(sale_time) >= 17 THEN 'Evening'
    END AS shift 
FROM retail_sales)
SELECT COUNT(transactions_id) as total_per_shift, shift 
FROM Shift_sales 
GROUP BY shift 


