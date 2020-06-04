#PostgreSQL Environment Setup

# SQL
/* 
Structured Data Language
ERD -> Entity Relationship Diagram
NoSQL -> Not only SQL (i.e MongoDB)
*/

/*
NULL is not a value is a property of the cell
Notice that NULLs are different than a zero - they 
are cells where data does not exist.

NULLs frequently occur when performing a LEFT or
RIGHT JOIN. You saw in the last lesson - when some 
rows in the left table of a left join are not matched 
with rows in the right table, those rows will contain 
some NULL values in the result set.

NULLs can also occur from simply missing data in our database.
*/

## NULL
SELECT *
FROM accounts
WHERE primary_poc IS NULL

## COUNT
/* Number of rows in a table */
SELECT COUNT(*)
FROM accounts;

SELECT COUNT(accounts.id) AS count_id
FROM accounts;

## SUM
SELECT SUM(standard_qty) AS standard,
	   SUM(gloss_qty) AS gloss,
	   SUM(poster_qty) AS poster
FROM orders;
-- Alternative
SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS std_price_x_unit
FROM orders;

## MIN & MAX
/*They work similar to COUNT (numbers, letters, dates)*/
SELECT MIN(standard_qty) AS standard_min,
       MAX(standard_qty) AS standard_max
FROM orders;

##AVG
/*This aggregate function again ignores the NULL values 
in both the numerator and the denominator.

If you want to count NULLs as zero, you will need to use 
SUM and COUNT. However, this is probably not a good idea 
if the NULL values truly just represent unknown values for a cell.*/
SELECT AVG(standard_qty) AS standard_avg,
       AVG(poster_qty) AS poster_avg
FROM orders;
--> CALCULATE THE MEDIAN (future exercise)
# This approach returns two values, median has to be alculated manuallu
# The limit has to be set manually
SELECT *
FROM (SELECT total_amt_usd
	 FROM orders
	 ORDER BY total_amt_usd
	 LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

## GROUP BY
/*GROUP BY can be used to aggregate data within subsets of the data. 
For example, grouping for different accounts, different regions, or 
different sales representatives.

Any column in the SELECT statement that is not within an aggregator 
must be in the GROUP BY clause.

The GROUP BY always goes between WHERE and ORDER BY.

ORDER BY works like SORT in spreadsheet software.
*/


SELECT account_id,
	   SUM(standard_qty) AS standard_sum
FROM orders
GROUP BY account_id
ORDER BY account_id;


/*Excercises*/

/*Which account (by name) placed the earliest order? 
Your solution should have the account name and the date 
of the order.*/
SELECT a.name, o.occurred_at
FROM orders o
JOIN accounts a
ON o.account_id = a.id
ORDER BY o.occurred_at
LIMIT 1;

/*Find the total sales in usd for each account. You should 
include two columns - the total sales for each company's 
orders in usd and the company name.*/
SELECT a.name, 
       SUM(o.total_amt_usd) AS total
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY total DESC;

/*Via what channel did the most recent (latest) web_event 
occur, which account was associated with this web_event? 
Your query should return only three values - the date, 
channel, and account name.*/
SELECT w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id 
ORDER BY w.occurred_at DESC
LIMIT 1;

/*Find the total number of times each type of channel 
from the web_events was used. Your final table should 
have two columns - the channel and the number of times 
the channel was used.*/
SELECT channel, COUNT(channel) AS times
FROM web_events
GROUP BY channel;
-- Alternative
SELECT w.channel, COUNT(*)
FROM web_events w
GROUP BY w.channel

/*Who was the primary contact associated with the 
earliest web_event?*/
SELECT a.primary_poc
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at
LIMIT 1;
-- ** It is not necessary to show colums from all the tables

/*What was the smallest order placed by each account in 
terms of total usd. Provide only two columns - the account
name and the total usd. Order from smallest dollar amounts
to largest.*/
SELECT a.name, MIN(o.total_amt_usd) AS total
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY total;

/*Find the number of sales reps in each region. Your final
 table should have two columns - the region and the number of
 sales_reps. Order from fewest reps to most reps.*/
SELECT r.name, COUNT(s.id) AS num_reps
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
GROUP BY r.name
ORDER BY num_reps;

/*Determine the number of times a particular channel was used 
in the web_events table for each region. Your final table 
should have three columns - the region name, the channel, and 
the number of occurrences. Order your table with the highest 
number of occurrences first.*/
SELECT r.name, w.channel, COUNT(*) num_events
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name, w.channel
ORDER BY num_events DESC;


##DISTINCT
/*DISTINCT is always used in SELECT statements, and it provides 
the unique rows for all columns written in the SELECT statement. 
Therefore, you only use DISTINCT once in any particular SELECT 
statement.*/
SELECT DISTINCT column1, column2, column3
FROM table1;
-- would return the unique (or DISTINCT) rows across all three columns

## HAVING
/*HAVING is the “clean” way to filter a query that has been aggregated,
but this is also commonly done using a subquery. Essentially, any time 
you want to perform a WHERE on an element of your query that was 
created by an aggregate, you need to use HAVING instead.*/
SELECT account_id, 
       SUM(total_amt_usd) AS sum_total
FROM orders
GROUP BY 1
HAVING SUM(total_amt_usd) >= 250000;
-- HAVING replaces WHERE and should go after GROUP BY


## SUBQUERY
/*How many of the sales reps have more than 5 accounts that they manage?*/
SELECT COUNT(*) num_reps_above5
FROM(SELECT s.id, s.name, COUNT(*) num_accounts
     FROM accounts a
     JOIN sales_reps s
     ON s.id = a.sales_rep_id
     GROUP BY s.id, s.name
     HAVING COUNT(*) > 5
     ORDER BY num_accounts) AS Table1;


## DATES
/*DATE_TRUNC to get rid off (second, day, month, year)*/
SELECT DATE_TRUNC('day', occurred_at) AS day,
       SUM(standard_qty) AS standard_qty_sum
FROM orders
GROUP BY 1
ORDER BY 1;

/* DATE_PART extract day, month, year
dow = day of the week 0:Sunday 6:Saturday*/
SELECT DATE_PART('dow', occurred_at) AS day_of_week,
       SUM(total) AS total_qty
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

/*Example*/
/*In which month of which year did Walmart spend the most on 
gloss paper in terms of dollars?*/
SELECT DATE_TRUNC('month', o.occurred_at) ord_date, 
       SUM(o.gloss_amt_usd) tot_spent
FROM orders o 
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

## CASE Statement
-- Equivalent of IF ELSE in SQL
-- CASE goes in SELECT statement, which means, should be preceeded by a comma
SELECT id, account_id, occurred_at, channel,
       CASE WHEN channel = 'facebook' OR channel = 'direct' 
       THEN 'yes' ELSE 'no' END AS is_facebook
FROM web_events
ORDER BY occurred_at;

/*Creating manual bins*/
SELECT account_id, occurred_at, total,
       CASE WHEN total > 500 THEN 'Over 500'
            WHEN total > 300 AND total <= 500 THEN '301 - 500'
            WHEN total > 100 AND total <= 300 THEN '101 - 300'
            ELSE '100 or under' END AS total_group
FROM orders

/*Example: Dealing with division by 0*/
SELECT account_id, CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
                        ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
LIMIT 10;

/*Aggregation with CASE statement*/
SELECT CASE WHEN total > 500 THEN 'Over 500'
            ELSE '500 or under' END AS total_group,
       COUNT(*) AS order_count
FROM orders
GROUP BY 1;

/*Complete Example
We would like to identify top performing sales reps, which are sales reps 
associated with more than 200 orders or more than 750000 in total sales. 
The middle group has any rep with more than 150 orders or 500000 in sales. 
Create a table with the sales rep name, the total number of orders, total 
sales across all orders, and a column with top, middle, or low depending on 
this criteria. Place the top sales people based on dollar amount of sales 
first in your final table.*/
SELECT s.name, COUNT(*), SUM(o.total_amt_usd) total_spent, 
     CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
     WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
     ELSE 'low' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 3 DESC;