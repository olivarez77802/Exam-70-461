
/*
Distinct versus Duplicates
See also 
QueryDataByUsingSelectStatement.sql
WorkWithData\ImplementAggregateQueries

1. UNION - Distinct rows
2. UNION ALL - Duplicate rows
3. INTERSECT - Distinct rows
4. EXCEPT - Distict rows
5a. DISTINCT - Removes Duplicates
5b. COUNT
6. GROUP BY - Removes Duplicates
7. ROW_NUMBER() (Used with Partition) - Can be used to remove duplicates

-------------------
4. EXCEPT
-------------------
See QueryDataByUsingSelect.sql

-------------------
5a. DISTINCT
-------------------
DISTINCT (Does remove duplicates)

Note! - The bad thing about this method is that you cannnot bring in other supplemental fields, same short coming as GROUP BY
Think of the logical order of SQL (FROM, WHERE,GROUP BY,HAVING,SELECT,ORDER BY).  When you do a DISTINCT SQL in the background 
basically has to do an implicit 'GROUP BY' and 'ORDER BY'.  So it makes sense the columns are limited to what would be listed in 
the 'GROUP BY' and 'ORDER BY'.

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

-----------------------
5b. COUNT
-----------------------
https://docs.microsoft.com/en-us/sql/t-sql/functions/count-transact-sql?view=sql-server-ver15

COUNT(*) returns the number of items in a group. This includes NULL values and duplicates.

COUNT(ALL expression) evaluates expression for each row in a group, and returns the number of nonnull values.

COUNT(DISTINCT expression) evaluates expression for each row in a group, and returns the number of unique, nonnull values.

----------------
6. GROUP BY
----------------
GROUP BY (Also removes duplicates remove duplicates, in addition it will sort by group by column(s))
https://www.databasejournal.com/features/mysql/article.php/3911786/Eliminating-Duplicate-Rows-from-MySQL-Result-Sets.htm

Note!  The shortcoming of this method is that you can't bring in other misc fields, all of the fields have to be specified
in either the GROUP BY clause or be an aggregrate.

SELECT shipperid, COUNT(*) AS numorders
FROM Sales.Orders
GROUP BY shipperid;
- Using an explicit GROUP BY clause, you can group the rows based on a specified grouping set
of expressions.  For Example, the following query groups the rows by shipper ID and counts
the number of rows (orders, in this case) per each distinct group.

--------------------------------------
7. ROW_NUMBER() (Used with PARTITION)
--------------------------------------
Below can be found in spGetEmployeesAsOf.   The nice thing about this method is that you can get other supplemental fields, unlike
the 'GROUP BY' and 'DISTINCT' fields. 

SELECT UIN,TimeDimKey,EIN, WorkerDimKey, ROW_NUMBER() OVER (PARTITION BY UIN ORDER BY TimeDimKey DESC) AS RowNumber
INTO #EmployeeNewLatest
FROM dbo.vEmployeeNew

DELETE FROM #EmployeeNewLatest 
WHERE  RowNumber > 1 


*/