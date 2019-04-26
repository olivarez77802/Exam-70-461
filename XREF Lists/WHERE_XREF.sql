/*
WHERE XREF - Different ways of using WHERE Clause

1. Finding Rows containing a value with WildCard
2. Finding Rows that are in a List of Values
3. Finding Rows that have a value between values
4. INSERT using WHERE
5. DELETE using WHERE
6. JOIN using WHERE. Differences between WHERE and ON
7. VIEWS using WHERE
8. HAVING used with WHERE
9. WHERE used in DERIVED Query
10. WHERE used in SubQuery
11. WHERE used with a SCALAR UDF (User defined function)
https://docs.microsoft.com/en-us/sql/t-sql/queries/where-transact-sql?view=sql-server-2017

TOP XREF - Filters similar to a WHERE Clause. 
1. TOP and Parentheses
2. TOP with a variable
3. TOP with TIES
4. OFFSET and FETCH
5. OFFSET AND FETCH - SELECT NULL
6. OFFSET and FETCH Variables

**********************************************
Finding Rows containing a value with WildCard
**********************************************

SELECT EmployeeKey, LastName
FROM DimEmployee
WHERE LastName LIKE ('%Smi%');

*********************************************
Finding Rows that are in a List of Values
*********************************************

SELECT EmployeeKey, LastName
FROM DimEmployee
WHERE LastName IN ('Smith', 'Godfrey', 'Johnson');

*************************************************
Finding Rows that have a value between values
*************************************************
SELECT EmployeeKey, LastName
FROM DimEmployee
WHERE EmployeeKey Between 100 and 200;

SELECT orderid, unitprice, qty
FROM Sales.Orderdetails
WHERE qty BETWEEN @Lowqty AND @Highqty
*************************************************
INSERT using WHERE
*************************************************
INSERT INTO TABLE1
SELECT * FROM TABLE2
WHERE AGE = 18;

INSERT tbl_A (col, col2)  
SELECT col, col2   
FROM tbl_B   
WHERE NOT EXISTS (SELECT col FROM tbl_A A2 WHERE A2.col = tbl_B.col);  

******************
DELETE using WHERE
******************
DELETE FROM CUSTOMERS
WHERE ID = 6;

******************************************************
6. JOIN using WHERE. Differences between WHERE and ON
******************************************************

SELECT E.UIN, E.SSN, NAME, A.ADDRESS, A.STATE
FROM EMP  AS E
JOIN ADDRESS AS A
ON (E.UIN = A.UIN)
WHERE A.STATE = 'TX'

“What’s the difference between the ON and the WHERE clauses, and does it matter if you specify your predicate
in one or the other?” The answer is that for inner joins it doesn’t matter. Both clauses perform the same filtering
purpose. Both filter only rows for which the predicate evaluates to true and discard rows for which the predicate
evaluates to false or unknown. In terms of logical query processing, the WHERE is evaluated right after the FROM, 
so conceptually it is equivalent to concatenating the predicates with an AND operator. SQL Server knows this, 
and therefore can internally rearrange the order in which it evaluates the predicates in practice, and it does 
so based on cost estimates.

SELECT
  S.companyname AS supplier, S.country,
  P.productid, P.productname, P.unitprice
FROM Production.Suppliers AS S
  INNER JOIN Production.Products AS P
    ON S.supplierid = P.supplierid
WHERE S.country = N'Japan';

-- Is the same as 

SELECT
  S.companyname AS supplier, S.country,
  P.productid, P.productname, P.unitprice
FROM Production.Suppliers AS S
  INNER JOIN Production.Products AS P
    ON S.supplierid = P.supplierid
    AND S.country = N'Japan';

For many people, though, it’s intuitive to specify the predicate that matches columns from both sides in the ON clause,
and predicates that filter columns from only one side in the WHERE clause. But again, with inner joins it doesn’t matter. 
In the discussion of outer joins in the next section, you will see that, with those, ON and WHERE play different roles; 
you need to figure out, according to your needs, which is the appropriate clause for each of your predicates.

-- Example of OUTER JOIN using WHERE Clause
SELECT
  S.companyname AS supplier, S.country,
  P.productid, P.productname, P.unitprice
FROM Production.Suppliers AS S
  LEFT OUTER JOIN Production.Products AS P    <-- Will return all of Table S
    ON S.supplierid = P.supplierid            <-- Will return matches and Table S that do not have Products.
WHERE S.country = N'Japan';

It is very important to understand that, with outer joins, the ON and WHERE clauses play very different roles,
and therefore, they aren’t interchangeable.   The WHERE clause still plays a simple filtering role.
However, the ON clause doesn’t play a simple filtering role; rather, it’s more a matching role.
In other words, a row in the preserved side will be returned whether the ON predicate finds a match for it or not. 
Because it’s a matching predicate (as opposed to a filter), the join won’t discard suppliers; instead, 
it only determines which products get matched to each supplier. 

*****************
WHERE using VIEWS
*****************
CREATE VIEW view_name AS
SELECT column_names(s)
FROM table_name
WHERE condition 
https://www.w3schools.com/sql/sql_quickref.asp

************************
8. HAVING used with WHERE
************************
--
-- HAVING will always be used with an Aggregate Function and with the GROUP BY clause
-- If a column name does not appear in the GROUP BY list nor is it contained in an
-- aggregate function, it's not allowed in the HAVING, SELECT, and ORDER BY clauses.
--
SELECT Column_name, aggregrate_function(columnname)
FROM table_name
WHERE column_name operator value
GROUP BY column_name
HAVING aggregrate_function(column_name) operator value

****************************
WHERE used in DERIVED Query
****************************
Select DeptName, TotalEmployees
from
   (
     Select DeptName, DepartmentId, COUNT(*) as TotalEmployees
	 from tblEmployee
	 join tblDepartment
	 on tblEmployee.DepartmentId = tblDepartment.DeptId
	 group by DeptName, DepartmentId

    )
as EmployeeCount
Where TotalEmployees >= 2

-- Derived Query #2
SELECT sub.*
FROM (
      SELECT *
	  FROM tutorial.sf_crime
	  WHERE day_of_week = 'Friday'
	  ) sub
WHERE sub.resolution = 'NONE'

************************
WHERE used with SubQuery
SQL EXISTS Operator - https://www.w3schools.com/sql/sql_exists.asp
************************
SELECT C.Firstname,
       C.Lastname,
	   C.EmailAddress
FROM PersonContact AS C
WHERE C.ContactID IN (SELECT ContactID
                      FROM Sales.SalesOderHeader);

-- EXIST Example
SELECT C.Firstname,
       C.Lastname,
	   C.EmailAddress
FROM PersonContact AS C
WHERE EXIST IN (SELECT soh.ContactID
                FROM Sales.SalesOderHeader AS soh
				WHERE soh.Contactid = c.Contactid);
--
INSERT tbl_A (col, col2)  
SELECT col, col2   
FROM tbl_B   
WHERE NOT EXISTS (SELECT col FROM tbl_A A2 WHERE A2.col = tbl_B.col);  

****************************
WHERE used with a Scalar UDF
****************************
A scalar UDF in the WHERE clause that restricts a result set is executed once
for every row in the referenced table.
See WorkWithFunctions.sql

************************
1. TOP and Parentheses
************************

T-SQL supports specifying the number of rows to filter using the TOP option in SELECT queries without parentheses,
but that’s only for backward-compatibility reasons. The correct syntax is with parentheses.
SELECT TOP (3) orderid, orderdate, custid, empid
FROM Sales.Orders;

*************************
2. TOP with Variable
*************************

DECLARE @n AS BIGINT = 5;

SELECT TOP (@n) orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

************************
3. TOP with TIES
************************
SELECT TOP (3) WITH TIES orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

************************
4. OFFSET and FEECH
************************
The OFFSET and FETCH clauses appear right after the ORDER BY clause, and in fact, in T-SQL, 
they require an ORDER BY clause to be present. You first specify the OFFSET clause indicating
how many rows you want to skip (0 if you don’t want to skip any); you then optionally specify
the FETCH clause indicating how many rows you want to filter. For example, the following query
defines ordering based on order date descending, followed by order ID descending; it then skips 50
rows and fetches the next 25 rows.

SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC, orderid DESC
OFFSET 50 ROWS FETCH NEXT 25 ROWS ONLY;

**************************
5. SELECT NULL
**************************
As mentioned earlier, the OFFSET-FETCH option requires an ORDER BY clause. But what if you need to filter a certain number 
of rows based on arbitrary order? To do so, you can specify the expression (SELECT NULL) in the ORDER BY clause, as follows.

SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY (SELECT NULL)
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;

******************************
6. OFFSET and FETCH Variables
******************************
DECLARE @pagesize AS BIGINT = 25, @pagenum AS BIGINT = 3;

SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC, orderid DESC
OFFSET (@pagenum - 1) * @pagesize ROWS FETCH NEXT @pagesize ROWS ONLY;

*/