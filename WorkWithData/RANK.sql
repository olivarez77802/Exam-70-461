/*
RANK AND DENSE_RANK returns a rank starting at 1 based on the ordering of rows imposed by the ORDER BY Clause

ORDER BY Clause is required 

RANK Function will skip ranking if there is a tie whereas DENSE_RANK will not.

RANK() Returns  -     (1,1,...85)       /* 1 is repeated in both Rank and Dense_rank because there is a tie.
DENSE_RANK() Returns- (1,1,...2)

ROW_NUMBER - Returns an increasing unique row number starting at 1, even if there are duplicates.

Use case for RANK and DENSE_RANK Functions: Both these functions can be used to find the Nth highest
salary.  However, whic function to use depends on what you want to do when there is a tie.

Since we have 2 employees with the FIRST highest salary.  Rank() function will not return any rows for 
the SECOND highest salary.
Ex.
  WITH Result AS 
  (
    SELECT Salary, RANK() OVER (ORDER BY Salary DESC) AS Salary_Rank
	FROM Employees
  )
  SELECT TOP 1 Salary FROM Result WHERE Salary_Rank = 2

Though we have 2 Employees with the FIRST highest salary.  Dense_Rank() function
returns, the next salary after the tied rows as the SECOND highest salary.
Ex.
  WITH Result AS
  (
    SELECT Salary, DENSE_RANK() OVER (ORDER BY Salary DESC) AS Salary_Rank
	FROM Employees
  )
  SELECT TOP 1 Salary FROM Result WHERE Salary_Rank = 2

You can also use RANK and DENSE_RANK functions to find the Nth highest Salary
among Male or Female employee groups.

The following query finds the 3rd highest salary amount paid among the Female
employees group
Ex.
WITH Result AS
(
  SELECT Salary, Gender,
         DENSE_RANK() OVER (PARTION BY Gender ORDER BY Salary DESC) AS Salary_Rank
  FROM Employees
)
SELECT TOP 1 Salary FROM Result WHERE Salary_Rank = 3 AND Gender = 'Female'

https://www.youtube.com/watch?v=5-La_uSNkKU&list=PL08903FB7ACA1C2FB&index=110

Similarities between RANK, DENSE_RANK and ROW_NUMBER Functions
* Returns and increasing integer value starting at 1 based on the ordering of rows
  imposed by the ORDER BY Clause (if there are no ties)
* ORDER BY clause is required
* PARTITION BY clause is optional
* When the data is partitioned, the integer value is reset to 1 when the partition changes.

https://www.youtube.com/watch?v=MZTSHDFuCUk&index=111&list=PL08903FB7ACA1C2FB


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

/*
https://docs.microsoft.com/en-us/sql/t-sql/functions/ranking-functions-transact-sql?view=sql-server-2017
*/
SELECT p.FirstName, p.LastName  
    ,ROW_NUMBER() OVER (ORDER BY a.PostalCode) AS "Row Number"  
    ,RANK() OVER (ORDER BY a.PostalCode) AS Rank  
    ,DENSE_RANK() OVER (ORDER BY a.PostalCode) AS "Dense Rank"  
    ,NTILE(4) OVER (ORDER BY a.PostalCode) AS Quartile  
    ,s.SalesYTD  
    ,a.PostalCode  
FROM Sales.SalesPerson AS s   
    INNER JOIN Person.Person AS p   
        ON s.BusinessEntityID = p.BusinessEntityID  
    INNER JOIN Person.Address AS a   
        ON a.AddressID = p.BusinessEntityID  
WHERE TerritoryID IS NOT NULL AND SalesYTD <> 0;

  