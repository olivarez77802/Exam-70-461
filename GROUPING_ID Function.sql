/*
GROUPING_ID() concatenates all of the GROUPING functions, performs the binary decimal conversion, and returns the equivalent integer.


*/
USE ADVENTUREWORKS2014
SELECT ISNULL(E.Gender, '*') AS GENDER
	  ,ISNULL(E.MaritalStatus, '*') AS MARITAL	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
	  ,GROUPING(E.Gender) AS GP_Gender
	  ,GROUPING(E.MaritalStatus) AS GP_MS
	  ,GROUPING_ID(E.Gender, E.MaritalStatus) AS GP_ID
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY ROLLUP(E.Gender, E.MaritalStatus)
  ORDER BY GP_ID

  