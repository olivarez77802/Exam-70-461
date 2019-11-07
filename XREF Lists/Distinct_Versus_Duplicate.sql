/*
Distinct versus Duplicates
See also QueryDataByUsingSelectStatement.sql

1. UNION - Distinct rows
2. UNION ALL - Duplicate rows
3. INTERSECT - Distinct rows
4. EXCEPT - Distict rows
5. DISTINCT
6. GROUP BY

-------------------
5. DISTINCT
-------------------
SELECT DISTINCT - 
https://www.w3schools.com/sql/sql_distinct.asp
- Below query will give you DISTINCT country, region, and city (not just DISTINCT Country).
SELECT DISTINCT country, region, city
FROM HR.Employees;

With general set functions, you can work with distinct occurrences by specifying a DISTINCT clause before the expression, as follows.
SELECT shipperid, COUNT(DISTINCT shippeddate) AS numshippingdates
FROM Sales.Orders
GROUP BY shipperid;
Note that the DISTINCT option is available not only to the COUNT function, but also to other general set functions. However, 
it’s more common to use it with COUNT.

----------------
6. GROUP BY
----------------
SELECT shipperid, COUNT(*) AS numorders
FROM Sales.Orders
GROUP BY shipperid;
- Using an explicit GROUP BY clause, you can group the rows based on a specified grouping set
of expressions.  For Example, the following query groups the rows by shipper ID and counts
the number of rows (orders, in this case) per each distinct group.

*/