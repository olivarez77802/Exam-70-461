/*
Implement Aggregate queries
 - New analytic functions; grouping sets; spatial aggregates; apply ranking functions

 COUNT(), AVERAGE(), SUM() Functions
 https://www.w3schools.com/sql/sql_count_avg_sum.asp

 MIN(), MAX()
 https://www.w3schools.com/sql/sql_min_max.asp

 GROUP BY - Often used with aggregate functions (COUNT, MAX, MIN, SUM, AVG) to group the result-set by one or more columns.
 https://www.w3schools.com/sql/sql_groupby.asp


 Analytic Functions
 https://docs.microsoft.com/en-us/sql/t-sql/functions/analytic-functions-transact-sql?view=sql-server-2017

/*
UNION


UNION - Does not include Duplicates.   Sorts the output.  There is a performance penalty since we have to do a Distinct SORT.

UNION ALL - Will include all rows including duplicates.  Output is not sorted.

Note: For UNION and UNION ALL to work the Number, DataTypes, and the order of the columns in the select statement should be the same.

ROLLUP - Used to do AGGREGATE Operation on Multiple Levels in a heirarchy. 
So it will automatically give you the subtotals and Grand Totals.

UNION ALL and GROUP SETS could also be used, however, the ROLLUP verb is the easiest way
to achieve Subtotals and Grand Totals.



USE AdventureWorks2014
SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY ROLLUP(E.Gender, E.MaritalStatus)

/*
Left the below just to do a comparison
*/

SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY E.Gender, E.MaritalStatus

  UNION ALL

  SELECT E.Gender
	  ,NULL 	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY E.Gender

  UNION ALL

  SELECT NULL
	  ,E.MaritalStatus 	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY E.MaritalStatus

  UNION ALL

  SELECT NULL
	  ,NULL 	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
 
 /*
  See GROUPING SETS for an easier more effecient way of doing the above
  */

SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY GROUPING SETS
   (
    (E.Gender,E.MaritalStatus),     -- Sum of Vac Hours by Gender, Marital Status
	(E.Gender),                     -- Sum of Vac Hours by Gender
	(E.MaritalStatus),              -- Sum of Vac Hours by Marital Status
	()                              -- Grand Total Vacation Hours

   )

/* The above will replace the below and is much more efficient)
*/

SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY E.Gender, E.MaritalStatus

  UNION ALL

  SELECT E.Gender
	  ,NULL 	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY E.Gender

  UNION ALL

  SELECT NULL
	  ,E.MaritalStatus 	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY E.MaritalStatus

  UNION ALL

  SELECT NULL
	  ,NULL 	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
 
 /*

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


  SELECT 
   E.Gender,
   E.MaritalStatus	
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
 
 
 */

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

  -- Limited to one character - prints out 'G' and 'T'

  SELECT ISNULL(E.Gender, 'Grand Total')  AS GENDER
	  ,ISNULL(E.MaritalStatus, 'Total') AS MARITAL	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
	  ,GROUPING(E.Gender) AS GP_Gender
	  ,GROUPING(E.MaritalStatus) AS GP_MS
	  ,GROUPING_ID(E.Gender, E.MaritalStatus) AS GP_ID
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY ROLLUP(E.Gender, E.MaritalStatus)
  ORDER BY GP_ID
  
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

/*
GROUP BY 
*/
SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY E.Gender, E.MaritalStatus


*/
/*
HAVING Clause
Syntax

  SELECT
  FROM  
  WHERE 
  GROUP BY
  HAVING
  ORDER BY

The HAVING clause must follow the GROUP BY clause in a query and must also precede the ORDER BY clause if used.

SELECT ID, NAME, AGE, ADDRESS, SALARY
FROM CUSTOMERS
GROUP BY age
HAVING COUNT(age) >= 2;

https://www.tutorialspoint.com/sql/sql-having-clause.htm


*/