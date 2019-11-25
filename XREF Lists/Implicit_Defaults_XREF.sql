/*
Implicit or Default XREF

1. GROUP BY
2. JOIN
3. CROSS JOIN
4. UNION and UNION ALL
5. PIVOT (Determining Grouping Element)
6. Views
7. Manage Transactions Default

--------------
1. GROUP BY
---------------
SELECT COUNT(*) AS numorders
FROM Sales.Orders
- Because there is no explicit GROUP BY clause, all rows queried from the Sales.Orders table 
are arranged in one group, and then the COUNT(*) function counts the number of rows in that
group.   Grouped queries return one result row per group, and because the query defines only
one group, it returns only one row in the result set.

SELECT shipperid, COUNT(*) AS numorders
FROM Sales.Orders
GROUP BY shipperid;
- Using an explicit GROUP BY clause, you can group the rows based on a specified grouping set
of expressions.  For Example, the following query groups the rows by shipper ID and counts
the number of rows (orders, in this case) per each distinct group.

-- If a column name does not appear in the GROUP BY list nor is it contained in an
-- aggregate function, it's not allowed in the SELECT, HAVING, and ORDER BY clauses.

The below SELECT will error out, since it does not have S.companyname in the GROUP BY 
or use it in an aggregate function.
SELECT S.shipperid, S.companyname, COUNT(*) AS numorders
FROM Sales.Shippers AS S
  JOIN Sales.Orders AS O
    ON S.shipperid = O.shipperid
GROUP BY S.shipperid;

-- Works..First and Optimal Solution, added to GROUP BY 
SELECT S.shipperid, S.companyname,
  COUNT(*) AS numorders
FROM Sales.Shippers AS S
  INNER JOIN Sales.Orders AS O
    ON S.shipperid = O.shipperid
GROUP BY S.shipperid, S.companyname;

-- Also Works.. Second solution, added to an aggregate
SELECT S.shipperid,
  MAX(S.companyname) AS companyname,
  COUNT(*) AS numorders
FROM Sales.Shippers AS S
  INNER JOIN Sales.Orders AS O
    ON S.shipperid = O.shipperid
GROUP BY S.shipperid;

-- Third solution, using a CTE
WITH C AS
(
  SELECT shipperid, COUNT(*) AS numorders
  FROM Sales.Orders
  GROUP BY shipperid
)
SELECT S.shipperid, S.companyname, numorders
FROM Sales.Shippers AS S
  INNER JOIN C
    ON S.shipperid = C.shipperid;

------------------
2. JOIN
------------------
INNER JOIN is the same as JOIN
LEFT OUTER JOIN is the same as LEFT JOIN
RIGHT OUTER JOIN is the same as RIGHT JOIN
FULL OUTER JOIN is the same as FULL JOIN

--------------------
3. CROSS JOIN
--------------------
The Nums table has 100,000 rows. According to logical query processing, the first step in the processing of the query is
evaluating the FROM clause. The cross join operates in the FROM clause, performing a Cartesian product between the two 
instances of Nums, yielding a table with 10,000,000,000 rows (not to worry, that’s only conceptually). Then the WHERE 
clause filters only the rows where the column D.n is less than or equal to 7, and the column S.n is less than or equal to 3. 
After applying the filter, the result has 21 qualifying rows. The SELECT clause then returns D.n naming it theday, and 
S.n naming it shiftno.

Fortunately, SQL Server doesn’t have to follow logical query processing literally as long as it can return the correct result. 
That’s what optimization is all about—returning the result as fast as possible. SQL Server knows that with a cross join followed 
by a filter it can evaluate the filters first (which is especially efficient when there are indexes to support the filters),
and then match the remaining rows.

------------------------
4. UNION and UNION ALL
------------------------
The UNION operator returns distinct rows.  When the unified sets are disjoint, there are no duplicates to remove, but the
SQL Server Optimizer may not realize it.  Trying to remove duplicates even when there are none involves extra cost. So
when the sets are disjoint, it's important to use the UNION ALL operator and not UNION.

----------
5. PIVOT  - Implicitly identifying grouping element.
----------
Pivot Syntax
SELECT <NonPivot>,             -- Grouping Column    -- Vertical Column   -- Y Column
       <FirstPivotedColumn>,   -- Spreading Column   -- Horizontal Column -- X Column 
	   ...                     -- Aggregation Column 
FROM <Table containing data>
   PIVOT (FUNCTION(<data column>)      -- Aggregate Function
      FOR <List of pivoted columns> )  -- Spreading Column 
	     AS <alias>

-- OR
WITH CTE
AS (
SELECT Y, X, Aggregate(Z) AS A
FROM Table
GROUP BY X, Y
)
SELECT Y, X-value, x-value, x-value, .. FROM CTE AS P
PIVOT (Aggregate(A) FOR X IN (X-value, X-value, X-value, ...)) AS PVT;

If you look carefully at the specification of the PIVOT operator, you will notice that you
indicate the aggregation and spreading elements, but not the grouping element. The grouping 
element is identified by elimination—it’s what’s left from the queried table besides the
aggregation and spreading elements. This is why it is recommended to prepare a table expression
for the pivot operator returning only the three elements that should be involved in the pivoting
task.

---------------
6. VIEWS
---------------
When you query from a regular nonmaterialized view, the SQL Server Query Optimizer combines
your outer query with the query embedded in the view and processes the combined query.  As
a result, when you look at the query plans based on queries that select from views, you will
see the referenced underlying tables of the view in the query plan; the view itself will not be
an object in the query plan.

-----------------------
7. Manage Transactions
-----------------------
1. SQL's default Isolation Level is 'READ COMMITED'.  This means read only committed data.

2. AUTOCOMMIT is the default transaction management mode.

3. SET IMPLICIT_TRANSACTIONS OFF is the default.  When OFF, each of the preceding T-SQL statements is bounded by an 
   unseen BEGIN TRANSACTION and unseen COMMIT TRANSACTION statement.  When OFF, we say the transaction mode is AUTOCOMMIT.
   https://docs.microsoft.com/en-us/sql/t-sql/statements/set-implicit-transactions-transact-sql?view=sql-server-ver15

4. SET XACT_ABORT OFF  is the default.    Means the entire batch will not fail.  SET XACT_ABORT ON will rollback the entire batch.
 

See also ManageTransactions.sql and SET_XREF.sql for more info.

*/