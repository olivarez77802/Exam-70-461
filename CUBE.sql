/*

CUBE Provides more subtotals than does ROLLUP.  CUBE Does totals on all possible combinations.  ROLLUP does totals based on the Heirarchy Order.

CUBE VERSUS GROUP BY -- Group by doesn't have Subtotals or Grand Totals
CUBE VERSUS ROLLUP  -- Cube has more subtotals
CUBE VERSUS GROUPING SETS - Exactly the same
*/
USE ADVENTUREWORKS2014
SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY E.Gender, E.MaritalStatus


  SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY CUBE(E.Gender, E.MaritalStatus) 
 --  ORDER BY E.Gender DESC   -- Have to use ORDER BY Clause if you want Subtotals and Grand Totals at Bottom

   SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY ROLLUP(E.Gender, E.MaritalStatus)

    SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY 
    GROUPING SETS
	(
	(E.Gender,E.MaritalStatus),
	(E.Gender),
	(E.MaritalStatus),
	()
	)
 