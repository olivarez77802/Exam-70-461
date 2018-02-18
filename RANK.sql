/*
RANK AND DENSE_RANK returns a rank starting at 1 based on the ordering of rows imposed by the ORDER BY Clause

ORDER BY Clause is required 

RANK Function will skip ranking if there is a tie whereas DENSE_RANK will not.

RANK() Returns  -     (1,1,...85)
DENSE_RANK() Returns- (1,1,...2)

ROW_NUMBER - Returns an increasing unique row number starting at 1, even if there are duplicates.

*/
USE ADVENTUREWORKS2014
SELECT ISNULL(E.Gender, '*') AS GENDER
	  ,ISNULL(E.MaritalStatus, '*') AS MARITAL
	  ,VacationHours
	  ,ROW_NUMBER() OVER (ORDER BY VACATIONHOURS) AS 'Row'
	  ,RANK() OVER (ORDER BY VACATIONHOURS) AS RANK1	
	  ,DENSE_RANK() OVER (ORDER BY VACATIONHOURS) AS DENSERANK 
FROM HumanResources.Employee AS E


USE ADVENTUREWORKS2014
SELECT ISNULL(E.Gender, '*') AS GENDER
	  ,ISNULL(E.MaritalStatus, '*') AS MARITAL
	  ,VacationHours
	  ,RANK() OVER (PARTITION BY E.GENDER ORDER BY VACATIONHOURS) AS RANK1	
	  ,DENSE_RANK() OVER (PARTITION BY E.GENDER ORDER BY VACATIONHOURS) AS DENSERANK 
FROM HumanResources.Employee AS E

  