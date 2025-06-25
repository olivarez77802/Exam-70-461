WHERE XREF - Different ways OF USING WHERE Clause

1. Finding ROWS containing A value WITH WildCard
2. Finding ROWS that ARE IN A LIST OF VALUES
3. Finding ROWS that have A value BETWEEN VALUES
4. INSERT using WHERE
5. DELETE using WHERE
6. JOIN USING WHERE. Differences BETWEEN WHERE AND ON
7. VIEWS USING WHERE
8. HAVING USED WITH WHERE
9. WHERE USED IN DERIVED Query
10. WHERE USED IN SubQuery
11. WHERE USED WITH a SCALAR UDF (USER defined FUNCTION)
https://docs.microsoft.com/en-us/SQL/t-SQL/queries/WHERE-transact-SQL?VIEW=SQL-SERVER-2017

TOP XREF - Filters similar TO A WHERE Clause.   - See Bottom.

1. TOP AND Parentheses
2. TOP WITH a variable
3. TOP WITH TIES
4. OFFSET AND FETCH
5. OFFSET AND FETCH - SELECT NULL
6. OFFSET AND FETCH Variables

**********************************************
1. Finding ROWS containing A value WITH WildCard
**********************************************

SELECT EmployeeKey, LastName
FROM DimEmployee
WHERE LastName LIKE ('%Smi%');

*********************************************
2. Finding Rows that are in a List of Values
*********************************************

SELECT EmployeeKey, LastName
FROM DimEmployee
WHERE LastName IN ('Smith', 'Godfrey', 'Johnson');

*************************************************
3. Finding Rows that have a value between values
*************************************************
SELECT EmployeeKey, LastName
FROM DimEmployee
WHERE EmployeeKey Between 100 and 200;

SELECT orderid, unitprice, qty
FROM Sales.Orderdetails
WHERE qty BETWEEN @Lowqty AND @Highqty

The BETWEEN operator is inclusive: begin and end values are included.
https://www.w3schools.com/sql/sql_between.asp

More info on BETWEEN can be found in DATES.sql

*************************************************
4. INSERT using WHERE
*************************************************
INSERT INTO TABLE1
SELECT * FROM TABLE2
WHERE AGE = 18;

INSERT tbl_A (col, col2)  
SELECT col, col2   
FROM tbl_B   
WHERE NOT EXISTS (SELECT col FROM tbl_A A2 WHERE A2.col = tbl_B.col);  

***************
* Work Example
***************
PRINT ('Number OF Victoria records already in dbo.SysMailCode') 
--
-- Create Table Variable
--
DECLARE @TSysMailCd TABLE (TbMcMailCd VARCHAR(05))
INSERT INTO @TSysMailCd
(
    TbMcMailCd
)
SELECT TbMcMailCd
FROM dbo.SYSMailCode
WHERE TbMcMailCd LIKE 'V%'


PRINT ('Victoria records added to dbo.SysMailCode')
INSERT INTO dbo.SYSMailCode
(
    TbCampusCd,
    TbMcMailCd,
    TbMcDesc,
    TbMcAddressLine_1,
    TbMcAddressLine_2,
    TbMcCity,
    TbMcState,
    TbMcZip,
    TbMcCntry,
    TbMcPhone,
    TbMcPhoneExt,
    TbMcDept
  )
  SELECT '**' AS TbCampusCd, 
       TbDptDept AS TbMcMailCd,
	   TbDptDeptName AS TBMcDesc,
	   NULL AS TbMcAddressLine_1, 
       NULL AS TbMcAddressLine_2, 
       NULL AS TbMcCity, 
       NULL AS TbMcState,
       NULL AS TbMcZip, 
       NULL AS TbMcCntry, 
       NULL AS TbMcPhone, 
       NULL AS TbMcPhoneExt, 
       NULL AS TbMcDept 
FROM dbo.SYSDepartment (NOLOCK) SDept
WHERE TbCampusCd = '31'
      AND LEFT(TbDptDept, 1) = 'V' 
-- Check records to see if they already exist
AND  SDept.TbDptDept NOT IN (SELECT TbMcMailCd FROM @TSysMailCd)

********

******************
5. DELETE using WHERE
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
7. WHERE using VIEWS
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
9 . WHERE used in DERIVED Query
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
10.  WHERE used with SubQuery
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
WHERE EXISTS (SELECT soh.ContactID
                FROM Sales.SalesOderHeader AS soh
				WHERE soh.Contactid = c.Contactid)
ORDER BY C.Lastname
--
INSERT tbl_A (col, col2)  
SELECT col, col2   
FROM tbl_B   
WHERE NOT EXISTS (SELECT col FROM tbl_A A2 WHERE A2.col = tbl_B.col);  

****************************
11. WHERE used with a Scalar UDF
****************************
A scalar UDF in the WHERE clause that restricts a result set is executed once
for every row in the referenced table.
See WorkWithFunctions.sql


*******************************************************************************

TOP XREF - Filters similar to a WHERE Clause. 
1. TOP and Parentheses
2. TOP with a variable
3. TOP with TIES
4. OFFSET and FETCH
5. OFFSET AND FETCH - SELECT NULL
6. OFFSET and FETCH Variables


************************
1. TOP and Parentheses
************************

T-SQL supports specifying the number of rows to filter using the TOP option in SELECT queries without parentheses,
but that’s only for backward-compatibility reasons. The correct syntax is with parentheses.
SELECT TOP (3) orderid, orderdate, custid, empid
FROM Sales.Orders;

See NULL_XREF.sql (6.Sorting).  Best Practice is to use ORDER BY with TOP

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

Must be used with the order by clause.
If you (order by id) then the result set will include all matching (or ties) to id

https://www.youtube.com/watch?v=fgKrP9LwZiM

USE ADVENTUREWORKS2014
SELECT TOP(10) PERCENT WITH TIES  
pp.FirstName, pp.LastName, e.JobTitle, e.Gender, r.Rate  
FROM Person.Person AS pp   
    INNER JOIN HumanResources.Employee AS e  
        ON pp.BusinessEntityID = e.BusinessEntityID  
    INNER JOIN HumanResources.EmployeePayHistory AS r  
        ON r.BusinessEntityID = e.BusinessEntityID  
ORDER BY Rate DESC;  

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

Using OFFSET and FETCH to Filter Query
* Provides opportunity to return a window of results
* Use OFFSET to specify number of rows to skip before query
* Use FETCH to specify number of rows to return after Query
* Requires ORDER BY
* Use OFFSET in ORDER BY without FETCH
* However, use FETCH only with OFFSET
* OFFSET and FETCH cannot be used in same query as TOP


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