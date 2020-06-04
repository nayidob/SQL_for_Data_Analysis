#PostgreSQL Environment Setup

# SQL
/* 
Structured Data Language
ERD -> Entity Relationship Diagram
NoSQL -> Not only SQL (i.e MongoDB)
*/

/*
Database Normalization
When creating a database, it is really important to think about how data will be stored. 
This is known as normalization, and it is a huge part of most SQL classes. If you are in 
charge of setting up a new database, it is important to have a thorough understanding of 
database normalization.

There are essentially three ideas that are aimed at database normalization:

Are the tables storing logical groupings of the data?
Can I make changes in a single location, rather than in many tables for the same information?
Can I access and manipulate data quickly and efficiently?
*/

## JOIN
/* 
We use ON clause to specify a JOIN condition which is a 
logical statement to combine the table in FROM and JOIN statements.
*/
SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

# Pull specific columns
SELECT accounts.name, orders.occurred_at
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

#Pull all the columns
SELECT *
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

# Example
SELECT orders.standard_qty, orders.gloss_qty, 
       orders.poster_qty,  accounts.website, 
       accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id

/*
PK stands for primary key. A primary key exists in every table, 
and it is a column that has a unique value for every row.

Keys
Primary Key (PK)
A primary key is a unique column in a particular table. This is 
the first column in each of our tables. Here, those columns are 
all called id, but that doesn't necessarily have to be the name. 
It is common that the primary key is the first column in our tables 
in most databases.

Foreign Key (FK)
A foreign key is a column in one table that is a primary key in a 
different table. We can see in the Parch & Posey ERD that the 
foreign keys are:

region_id
account_id
sales_rep_id
Each of these is linked to the primary key of another table.
*/

# In the ON, we will ALWAYs have the FK (left) equal to the PK (right)

ON region.id = sales_reps.region_id


# Multiple JOIN
SELECT web_events.channel, accounts.name, orders.total
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id

# Alias
Select t1.column1 aliasname, t2.column2 aliasname2
FROM tablename AS t1
JOIN tablename2 AS t2
# Alias
SELECT col1 + col2 total, col3


# Aliasing
SELECT region.name region_name, 
		sales_reps.name sales_rep_name, 
		accounts.name account_name
FROM region
JOIN sales_reps
ON sales_reps.region_id = region.id
JOIN accounts
ON accounts.sales_rep_id = sales_reps.id
ORDER BY accounts.name;

# The same code qith Alias
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;

# If there is not matching information in the JOINed table, 
# then you will have columns with empty cells. These empty 
# cells introduce a new data type called NULL

LEFT OUTER JOIN = LEFT JOIN

FULL OUTER JOIN = OUTER JOIN


SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100;

## SELECT DISTINCT
SELECT DISTINCT a.name, w.channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.id = '1001';

# Does not matter the order of the DATES
SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
ORDER BY o.occurred_at DESC;

SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;





