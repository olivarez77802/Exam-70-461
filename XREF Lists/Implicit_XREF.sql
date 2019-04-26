/*
Implicit XREF

1. GROUP BY
2. JOIN
3. CROSS JOIN
4. UNION and UNION ALL

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
-- aggregate function, it's not allowed in the HAVING, SELECT, and ORDER BY clauses.

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

*/