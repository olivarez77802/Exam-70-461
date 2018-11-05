/*
Implement sub-queries
 - Identify problematic elements in query plans; pivot and unpivot; apply operator; cte statement; with statement

1. SUBQUERY					 
2. APPLY Operator
3. CTE Statment

********************
SUBQUERY
********************

Note: Compare with derived table.  A derived table is basically q subquery, except it is always in the FROM Clause
of an SQL Statement.  The reason it is called a derived table is because it essentially functions as a table.
See DERIVED_TABLES.sql

Subquery - Can be put on the WHERE or the FROM Line

A Query within a query 

Advantages - Uses
-- Breaks down complex logic
-- Simplifies reading
-- Sneak "in" operations otherwise not allowed. e.g use an aggregate function on a where clause

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

Select D.DepartmentName, E.Name, E.Gender, E.Salary
from Department D
Cross Apply fn_GetEmployeeByDeparmtmentId (D.Id) E

-- on D.Id = E.DepartmentId   <-- Unlike Join - Not required

or if you also want non-matching rows use 'Outer Apply'

Select D.DepartmentName, E.Name, E.Gender, E.Salary
from Department D
Outer Apply fn_GetEmployeeByDeparmtmentId (D.Id) E

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



*/