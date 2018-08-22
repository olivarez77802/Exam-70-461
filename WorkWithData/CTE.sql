/*
CTE - Common Table Expressions

A CTE can be thought of as a temporary result set that is defined within the execution
scope of a signle SELECT, INSERT, UPDATE,DELETE, or CREATE VIEW Statement.  A CTE is similar
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
*/

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

