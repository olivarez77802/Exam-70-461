/*
Implement sub-queries
 - Identify problematic elements in query plans; pivot and unpivot; apply operator; cte statement; with statement

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

***************************************************************************************************************************
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

*/