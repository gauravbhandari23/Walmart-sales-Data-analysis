# Walmart-sales-Data-analysis
Project Overview
This project aims to perform in-depth analysis of Walmart's sales data using SQL queries. The analysis covers various business problems, from identifying payment methods to calculating profit margins and analyzing revenue changes between years. The main objective is to extract meaningful insights from the dataset to support decision-making.
Business Problems Solved

Q1: Find Different Payment Methods and Number of Transactions, Number of Quantity Sold

This query identifies the different payment methods used and provides the count of transactions and total quantity sold for each payment method.
```sql
SELECT 
  payment_method, 
  COUNT(*) AS transaction, 
  SUM(quantity) AS quantity
FROM walmart
GROUP BY payment_method;
```

Q2: Identify the Highest-Rated Category in Each Branch

This query calculates the highest-rated category in each branch based on the average rating, ranking the categories, and selecting the top-rated ones.


```sql
SELECT * 
FROM (
  SELECT 
    branch, 
    category, 
    AVG(rating) AS avg_Rating, 
    RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS ranks
  FROM walmart
  GROUP BY branch, category
) AS subquery
WHERE ranks = 1;
```

Q3: Identify the Busiest Day for Each Branch Based on the Number of Transactions

This query identifies the busiest day (highest number of transactions) for each branch.

```sql
SELECT 
  branch,
  day_name,
  no_transaction,
  transaction_rank
FROM (
  SELECT 
    branch,
    DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%y'), '%W') AS day_name,
    COUNT(*) AS no_transaction,
    RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS transaction_rank
  FROM walmart
  GROUP BY branch, day_name
) AS ranked_transactions
WHERE transaction_rank = 1
ORDER BY branch;
```

Q4: Calculate the Total Quantity of Items Sold per Payment Method

This query calculates the total quantity of items sold for each payment method.

```sql
SELECT payment_method, SUM(quantity)
FROM walmart
GROUP BY payment_method;
```

Q5: Determine the Average, Minimum, and Maximum Rating of Products by Category for Each City

This query calculates the average, minimum, and maximum product ratings for each category in different cities.

```sql
SELECT city, category, MIN(rating), MAX(rating), AVG(rating)
FROM walmart
GROUP BY city, category;
```

Q6: Calculate the Total Profit for Each Category

This query calculates the total profit for each category using the formula (unit_price * quantity * profit_margin).
```sql
SELECT category, ROUND(SUM(unit_price * quantity * profit_margin)) AS total_profit
FROM walmart
GROUP BY category
ORDER BY total_profit DESC;
```

Q7: Determine the Most Common Payment Method for Each Branch

This query identifies the most frequently used payment method for each branch.
```sql
WITH cte AS (
  SELECT branch, payment_method, COUNT(*) AS payment_method_used,
  RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS ranks
  FROM walmart
  GROUP BY branch, payment_method
)
SELECT * FROM cte
WHERE ranks = 1;
```

Q8: Categorize Sales into 3 Shifts: Morning, Afternoon, Evening

This query categorizes sales into three shifts: Morning, Afternoon, and Evening based on the time of the day.

```sql
SELECT 
  branch,
  CASE 
    WHEN EXTRACT(HOUR FROM TIME(STR_TO_DATE(time, '%H:%i:%s'))) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM TIME(STR_TO_DATE(time, '%H:%i:%s'))) < 18 THEN 'Afternoon'
    ELSE 'Evening'
  END AS time_of_day,
  COUNT(*)
FROM walmart
GROUP BY branch, time_of_day
ORDER BY branch;
```
Q9: Identify the 5 Branches with the Highest Decrease Ratio in Revenue (2022 vs 2023)

This query calculates the decrease ratio in revenue for each branch comparing 2022 and 2023 sales.
```sql
WITH revenue_2022 AS (
  SELECT branch, SUM(total) AS revenue
  FROM walmart
  WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2022
  GROUP BY branch
),
revenue_2023 AS (
  SELECT branch, SUM(total) AS revenue
  FROM walmart
  WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2023
  GROUP BY branch
)
SELECT 
  ls.branch,
  ls.revenue AS last_year_revenue,
  cs.revenue AS current_year_revenue,
  CAST((ls.revenue - cs.revenue) / ls.revenue * 100 AS DECIMAL(10,2)) AS decrease_ratio
FROM revenue_2022 AS ls
JOIN revenue_2023 AS cs
ON ls.branch = cs.branch
WHERE ls.revenue > cs.revenue
ORDER BY decrease_ratio DESC
LIMIT 5;
```
