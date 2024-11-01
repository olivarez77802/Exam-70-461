/*
See also ModifyData/CombineDatasets.sql
See also QueryDataByUsingSelect.sql

Implement sub-queries
 - Identify problematic elements in query plans; pivot and unpivot; apply operator; cte statement; with statement

1. SUBQUERY					 
2. APPLY Operator
3. CTE Statment
4. PIVOT

********************
SUBQUERY
********************

Subqueries can be self-contained�namely, independent of the outer query; or they can be correlated�namely,
having a reference to a column from the table in the outer query. In terms of the result of the subquery,
it can be scalar, multi-valued, or table-valued.

Note that if what�s supposed to be a scalar subquery returns in practice more than one value, the code
fails at run time. If the scalar subquery returns an empty set, it is converted to a NULL.

Note: Compare with derived table.  A derived table is basically q subquery, except it is always in the FROM Clause
of an SQL Statement.  The reason it is called a derived table is because it essentially functions as a table.
See XREF/Tables..


Subquery - Can be put on the WHERE or the FROM Line

A Query within a query 

Advantages - Uses
-- Breaks down complex logic
-- Simplifies reading
-- Sneak "in" operations otherwise not allowed. e.g use an aggregate function on a where clause
-- Allows you to use "ORDER BY" on a view with "TOP 1" which otherwise is not allowed on a view.

DisAdvantages - Can often be replaced by a join
-- Joins may perform faster
-- SQL Server will frequently rewrite subqueries as joins
Most readable query is frequently best

------------------------------------------------------------------------------- 
FROM Line
-- Create a 'dynamic' table
-- Useful for breaking down queries
-- Query must be aliased

SELECT p.Name,
       p.Listprice - ap.AverageListPrice AS DifferenceFromSubCategoryAverage
FROM Production.Product P
INNER JOIN (SELECT ProductSubcategoryID, AVG(Listprice) AS 'AverageListPrice'
            FROM Production.Product
			GROUP BY ProductSubcategoryID) AS ap
		ON P.SubcategoryID = ap.SubcategoryID

****************************************************************************************************************************

WHERE Line  - Most common place to put subquery
-- Useful for comparing values to other tables
-- Find orders containing a particular product category

Predicates used with subqueries
IN
-- Confirm column value exist in subquery
-- Similar to inner join

EXISTS
-- Returns true if subquery returns values
-- Frequently used with correlated queries.  Corelated subqueries - passes column from main (outer) query into subquery 
                                             to simulate join.

ALL
-- Compares column values to all items returned in a subquery
-- Subquery must return only one column

ANY OR SOME
-- Compares column value to any item returned by subquery
-- Subquery must return only one column value
-- ANY and SOME are identical

Examples

-- IN Example
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

PluralSight
https://app.pluralsight.com/player?course=sql-server-2012-querying-pt1&author=christopher-harrison&name=sql-server-2012-querying-pt1-m06&clip=0&mode=live

https://www.w3schools.com/sql/sql_exists.asp


******************
APPLY Operator
****************** 

Apply Operator

* The APPLY operator introduced in SQL Server 2005, is used to join a table to a table-valued
  function
* The Table Valued function on the right hand side of the APPLY operator gets called for each
  row from the left(also called outer table) table
* Cross Apply returns only matching rows (semantically equivalent to Inner Join)
* Outer Apply returns matching + non-matching rows (semantically equivalent to Left Outer Join).
  The unmatched columns of the table valued function will be set to NULL.

The APPLY operator is a powerful operator that you can use to apply a table expression given to
it as the right input to each row from a table expression given to it as the left input. What�s 
interesting about the APPLY operator as compared to a join is that the right table expression can
be correlated to the left table; in other words, the inner query in the right table expression 
can have a reference to an element from the left table. So conceptually, the right table expression
is evaluated separately for each left row. This means that you can replace the use of cursors in
some cases with the APPLY operator.

Cross Apply & Outer Apply Operator
https://www.youtube.com/watch?v=kVogo0AbatM

Examples

-------------------------------------------------------------------------------------
Error - Will give you an error.  Does not allow an Inner Join on a Phyiscal Table and
a Table Valued Function.  !!! Must use APPLY Operator
--------------------------------------------------------------------------------------

Select D.DepartmentName E.Name, E.Gender, E.Salary      
from Department D
Inner Join fn_GetEmployeesByDepartmentId (D.Id) E
on D.Id = E.DepartmentId

-----------------------
APPLY Operator - Works!
------------------------

Select D.DepartmentName, E.Name, E.Gender, E.Salary        <-- Left Table with Elements from Right Table
from Department D
Cross Apply fn_GetEmployeeByDeparmtmentId (D.Id) E         <-- Right Table using Elements from Left Table

-- on D.Id = E.DepartmentId   <-- Unlike Join - Not required

or if you also want non-matching rows use 'Outer Apply'

Select D.DepartmentName, E.Name, E.Gender, E.Salary
from Department D
Outer Apply fn_GetEmployeeByDeparmtmentId (D.Id) E

----------------------------------------------------------
APPLY OPERATOR Using CROSS APPLY - Note 2 'WHERE' Clauses
----------------------------------------------------------
SELECT S.supplierid, S.companyname AS supplier, A.*
FROM Production.Suppliers AS S
  CROSS APPLY (SELECT productid, productname, unitprice
               FROM Production.Products AS P
               WHERE P.supplierid = S.supplierid
               ORDER BY unitprice, productid
               OFFSET 0 ROWS FETCH FIRST 2 ROWS ONLY) AS A
WHERE S.country = N'Japan';

***************************
CTE
***************************

CTE - Common Table Expressions
https://docs.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql?view=sql-server-2017

A CTE can be thought of as a temporary result set that is defined within the execution
scope of a single SELECT, INSERT, UPDATE,DELETE, or CREATE VIEW Statement.  A CTE is similar
to a derived table in that it is not stored as an object and lasts only for the duration of 
the query.

A CTE can only be referenced by a SELECT, INSERT, UPDATE or DELETE statement that immediately
follows the CTE.  Must immediately follow or you will get an error if you try to use CTE

It is possible to use more than one CTE using the 'with' keyword.

If a CTE is created on one base table, then it is possible to UPDATE the CTE, which will in
turn update the underlying base table.

If a CTE is based on more than one table, and if the UPDATE affects only one base table, 
then the UPDATE is allowed.

if a CTE is based on multiple tables, and if the UPDATE statement affects more than 1 base
table, then the UPDATE is not allowed.

Microsoft DOC
https://docs.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql?view=sql-server-2017

See Rank for more examples using CTE's.


-- USE AdventureWorks2014
With ITBL(Gender, MaritalStatus, VAC_HOURS)
as
(
  SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS VAC_HOURS
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY ROLLUP(E.Gender, E.MaritalStatus) 
 )
 
--  Select 'Hello'  /* if you uncomment will get error. CTE must be used immediately. */

Select *
FROM ITBL  
WHERE VAC_HOURS > 0 

If you need to define multiple CTEs, you simply separate them by commas.

WITH C1 AS
(
  SELECT ...
  FROM T1
  WHERE ...
),
C2 AS 
(
  SELECT
  FROM  C1
  WHERE ...
)
SELECT ...
FROM C2
WHERE ...;

/*
*  Example
*/
WITH RESULT AS
(
SELECT PyCampusCd,PyFiscalYy,PyPayCycleAcctDt,Py920FteMoSal,RANK()  OVER (ORDER BY Py920FteMoSal DESC) AS Salary_Rank
FROM dbo.FRSPayrollDetail
WHERE PyFiscalYy = 2025
-- AND Py920FteMoSal IS NOT NULL
)
SELECT *
FROM RESULT
-- WHERE RESULT.Salary_Rank = 2


*************
PIVOT
*************
Pivoting is a specialized case of grouping and aggregating of data. Unpivoting is,
in a sense, the inverse of pivoting. The specification for the PIVOT operator 
starts by indicating an aggregate function.

Pivot Syntax
-------------
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
SELECT Y, x-value, x-value, x-value, .. FROM CTE AS P
PIVOT (Aggregate(A) FOR X IN (X-value, X-value, X-value, ...)) AS PVT;
       
*/

-- so-edw-sql2
WITH PWORKER 
AS (
SELECT GenderCode AS Gender,  
	   WorkStation AS WS,
       SUM(FTEAnnualizedAnnualSalary) AS TS
  FROM [SEACommonTransform].[dbo].[EDWWorkerFact]
  WHERE FTEAnnualizedAnnualSalary IS NOT NULL 
  GROUP BY WorkStation, GenderCode
  )
  SELECT Gender, A, C, D, E, F, G, H, I, J, K, L, M, N, O, P, R, S, T, V, W, X FROM PWORKER AS P 
    PIVOT (SUM(TS) FOR WS IN (A, C, D, E, F, G, H, I, J, K, L, M, N, O, P, R, S, T, V, W, X)) AS pvt;

/*
Example 2
*/
WITH PWORKER AS (
SELECT YEAR(StatementDATE) AS YSDT,
      MONTH(StatementDate) AS MSDT,
SUM(DIVIDEND) AS DSUM
FROM DIVDETAIL
GROUP BY YEAR(STATEMENTDATE)
 ,MONTH(STATEMENTDATE)
-- ORDER BY YEAR(STATEMENTDATE) 
)
-- SELECT *
-- FROM PWORKER;
SELECT YSDT, [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
FROM PWORKER AS P
PIVOT (SUM(DSUM) FOR MSDT IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) AS PVT
