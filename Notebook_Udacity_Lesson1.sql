#PostgreSQL Environment Setup

/*
Open Terminal
Select User using:
psql -U postgres       (postgres is the username)


\list     To see all the databases

*/



# SQL
/* 
Structured Data Language
ERD -> Entity Relationship Diagram
NoSQL -> Not only SQL (i.e MongoDB)
*/

## SELECT
/* 
To select all the colums use
*/
SELECT *


### Limits

SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 15;

### Order by
# Always shuld go after FROM and before LIMIT
# By default it orders in ascending order A-Z
SELECT occurred_at, account_id, channel
FROM web_events
ORDER BY occurred_at
LIMIT 15;

# To use descending order include DESC
SELECT occurred_at, account_id, channel
FROM web_events
ORDER BY occurred_at DESC
LIMIT 15;

# Multiple ordering at the same time
SELECT occurred_at, account_id, channel
FROM web_events
ORDER BY account_id, occurred_at DESC #from the left one

# Multiple ordering at the same time
SELECT occurred_at, account_id, channel
FROM web_events
ORDER BY account_id DESC, occurred_at #from the left one


###Where
SELECT *
FROM orders
WHERE account_id = 4251
ORDER BY occurred_at
LIMIT 1000;

/*
> (greater than)
< (less than)
>= (greater than or equal to)
<= (less than or equal to)
= (equal to)
!= (not equal to)
*/

SELECT *
FROM accounts
WHERE name != 'United Technologies'


# Derived Columns

SELECT account_id, occurred_at,
	   gloss_qty + poster_qty AS nonstandard_qty

/*
* (Multiplication)
+ (Addition)
- (Subtraction)
/ (Division
*/

SELECT id, (standard_amt_usd/total_amt_usd)*100 AS std_percent, total_amt_usd
FROM orders
LIMIT 10;

/*
Introduction to Logical Operators

LIKE
This allows you to perform operations similar to using 
WHERE and =, but for cases when you might not know exactly what you are looking for.

IN
This allows you to perform operations similar to using
WHERE and =, but for more than one condition.

NOT
This is used with IN and LIKE to select all of the rows 
NOT LIKE or NOT IN a certain condition.

AND & BETWEEN
These allow you to combine operations where all combined 
conditions must be true.

OR
This allow you to combine operations where at least one of 
the combined conditions must be true.
*/


# Use LIKE to match a defined string
# Any number of characters before and after google
SELECT *
FROM web_events_full
WHERE referrer_url LIKE '%google%'  

# NOT LIKE
SELECT *
FROM web_events_full
WHERE referrer_url NOT LIKE '%google%' 

SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';

# Use IN
SELECT *
FROM accounts
WHERE name IN ('Walmart', 'Apple')

# NOT IN
SELECT *
FROM accounts
WHERE name NOT IN ('Walmart', 'Apple')

# AND
SELECT *
FROM orders
WHERE occurred_at >= '2016-04-01' AND occurred_at <= '2016-10-01'
ORDER BY occurred_at DESC;

#BETWEEN
# Exactly the same
# BETWEEN operator includes the begin and end values []
WHERE column >= 6 AND column <= 10
WHERE column BETWEEN 6 AND 10

/*Tricky for dates. Time 00:00:00 (i.e. midnight)*/
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;

# OR
SELECT account_id
FROM orders
WHERE standard_qty = 0 OR gloss_qty = 0 OR poster_qty = 0;

SELECT account_id
FROM orders
WHERE (standard_qty = 0 OR gloss_qty = 0 OR poster_qty = 0)
   AND occurred_at >= '2016-10-01'

# More examples
SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') 
           AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') 
           AND primary_poc NOT LIKE '%eana%');

SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);

/* 
Commands
You have already learned a lot about writing code in SQL! Let's take a moment to recap all that we have covered before moving on:

Statement  How to Use It	Other Details
SELECT	-- SELECT Col1, Col2, ...	Provide the columns you want
FROM	-- FROM Table	Provide the table where the columns exist
LIMIT	-- LIMIT 10	Limits based number of rows returned
ORDER BY-- ORDER BY Col	Orders table based on the column. Used with DESC.
WHERE	-- WHERE Col > 5	A conditional statement to filter your results
LIKE	-- WHERE Col LIKE '%me%'	Only pulls rows where column has 'me' within the text
IN	    -- WHERE Col IN ('Y', 'N')	A filter for only rows with column of 'Y' or 'N'
NOT	    -- WHERE Col NOT IN ('Y', 'N')	NOT is frequently used with LIKE and IN
AND	    -- WHERE Col1 > 5 AND Col2 < 3	Filter rows where two or more conditions must be true
OR	    -- WHERE Col1 > 5 OR Col2 < 3	Filter rows where at least one condition must be true
BETWEEN	-- WHERE Col BETWEEN 3 AND 5	Often easier syntax than using an AND
*/



