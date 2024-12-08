create database walmart;
use walmart;

select * from walmart;

-- Business Problems
-- Q1 find different payment method and number of transaction , number of qty sold
select 
 payment_method , count(*) as transaction, sum(quantity)as quantity
from walmart
group by payment_method;

-- Q2 identify the highest-rated category in each branch , displaying the branch catrgory

select * 
from(
	select 
	branch, 
	category,
	avg(rating)as avg_Rating,
	Rank() Over(partition by branch order by avg(rating) desc) as ranks
	from walmart 
	group by branch,category
    )as subquery
where ranks = 1;

-- Q3 Identify the bussiest day for each branch based on the number of transaction

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

-- Q4 calculate the total quantity of items sold per payment method . List payment_method and total_quantity
	
    select payment_method, sum(quantity)
    from walmart
    group by payment_method;
    
-- Q5 Determine the average,minimum,and maximum rating of products ccategory for each city. list the city , average-rating,min-rating,and max-rating

select city,category,min(rating),max(rating),avg(rating)
from walmart
group by city,category;


-- Q6 calculate the total profit for each category by considering total_profit as (unit_price * quantity * profit_margin). List category and total_profit, order from highest to lowesr profit

select category ,round(sum(unit_price*quantity*profit_margin))as total_profit
from walmart
group by category 
order by total_profit desc;

-- Q7 Determine the most common payment method for each branch . Display branch and the preferred_payment_mehtod
with cte as(
select branch , payment_method , count(*) as payment_method_used,
Rank() over (partition by branch order by count(*) Desc) as ranks
from walmart

group by branch,payment_method
)
select * from cte 
where ranks  = 1;


-- Q8 Categorize sales into 3 group Morning, Afternoon , Evening   -- Find out which of the shift and number of invoice

SELECT 
	branch,
    CASE 
        WHEN EXTRACT(HOUR FROM TIME(STR_TO_DATE(time, '%H:%i:%s'))) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM TIME(STR_TO_DATE(time, '%H:%i:%s'))) < 18 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day,
    count(*)
FROM walmart
group by branch ,time_of_day
order by branch ;


-- Q9 identify 5 branch with highest decrese ratio in revenue compare to last year (cy 2023 and ly 2022)

-- rdr = last_rev-cr_rev/last_rev *100
-- SELECT 
--     YEAR(STR_TO_DATE(date, '%d/%m/%Y')) AS year_value
-- FROM walmart

-- 2022 sales
with revenue_2022 as(
	select branch ,sum(total) as revenue
	from walmart
	where YEAR(STR_TO_DATE(date, '%d/%m/%Y'))=2022
	group by branch
    order by branch
    ),
revenue_2023 as(select branch ,sum(total) as revenue
	from walmart
	where YEAR(STR_TO_DATE(date, '%d/%m/%Y'))=2023
	group by branch
    order by branch)
    
    select ls.branch,
    ls.revenue as last_year_revenue,
    cs.revenue as current_year_revenue,
    CAST((ls.revenue - cs.revenue) / ls.revenue * 100 AS DECIMAL(10,2)) AS decrease_ratio
    
    from revenue_2022 as ls
    join revenue_2023 as cs
    on ls.branch = cs.branch
    where ls.revenue>cs.revenue
    order by decrease_ratio desc
    limit 5;









