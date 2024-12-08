# Walmart-sales-Data-analysis
Project Overview
This project aims to perform in-depth analysis of Walmart's sales data using SQL queries. The analysis covers various business problems, from identifying payment methods to calculating profit margins and analyzing revenue changes between years. The main objective is to extract meaningful insights from the dataset to support decision-making.
Business Problems Solved
Q1: Find Different Payment Methods and Number of Transactions, Number of Quantity Sold
This query identifies the different payment methods used and provides the count of transactions and total quantity sold for each payment method.
SELECT 
  payment_method, 
  COUNT(*) AS transaction, 
  SUM(quantity) AS quantity
FROM walmart
GROUP BY payment_method;

