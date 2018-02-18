/*
GROUPING Function 

GROUPING indicates whether a column in a GROUPBY list is aggregated or not. 
GROUPING returns ‘1’ for aggregated or 
                 ‘0’ for not aggregated
in the result set.

*/
USE ADVENTUREWORKS2014
SELECT ISNULL(E.Gender, 'ALL') AS GENDER
	  ,ISNULL(E.MaritalStatus, 'ALL') AS MARITAL	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
	  ,GROUPING(E.Gender) AS 'GP_Gender'
	  ,GROUPING(E.MaritalStatus) AS 'GP_MS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY ROLLUP(E.Gender, E.MaritalStatus)

  SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
	  ,GROUPING(E.Gender) AS 'GP_Gender'
	  ,GROUPING(E.MaritalStatus) AS 'GP_MS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY ROLLUP(E.Gender, E.MaritalStatus)