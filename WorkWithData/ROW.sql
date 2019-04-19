/*
ROW_NUMBER() Clause  ....  

Needs the OVER (ORDER BY ... Clause

ROW_NUMBER() Will start over with each Partition see second example

Since ROW_NUMBER() starts over with each partition ... if you wanted to identify duplicates this could easily be done

https://www.youtube.com/watch?v=cvrwOoGwgz8&index=109&list=PL08903FB7ACA1C2FB

Use case of ROW_NUMBER() Function is that you can Delete all Duplicate Rows.
Example:
  WITH EmployeesCTE AS
  (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY ID ORDER BY ID) AS RowNumber
	FROM Employees
  )
  DELETE FROM EmployeesCTE WHERE RowNumber > 1

--- See example below where Derived Query is used.
*/

SELECT 
      JobTitle
      ,[BirthDate]
      ,[MaritalStatus]
      ,Gender
      ,[HireDate] 
	  ,ROW_NUMBER() OVER (ORDER BY Gender) AS GEN 
FROM [AdventureWorks2014].[HumanResources].[Employee] 


SELECT 
      JobTitle
      ,[BirthDate]
      ,[MaritalStatus]
      ,Gender
      ,[HireDate] 
	  ,ROW_NUMBER() OVER (PARTITION BY Gender ORDER BY GENDER) AS GEN 
FROM [AdventureWorks2014].[HumanResources].[Employee] 


*********************
SO-EDW-SQL2
*********************
-- Example using CTE
WITH StatusCTE
AS
(
SELECT BPPStatus, BPPStatusDescription, ROW_NUMBER() OVER (PARTITION BY BPPStatus ORDER BY BPPStatus) AS RowNumber
FROM SEACommonTransform.dbo.vEDWWorkerDim
)
SELECT StatusCTE.BPPStatus, StatusCTE.BPPStatusDescription FROM StatusCTE
WHERE StatusCTE.RowNumber = 1
ORDER BY StatusCTE.BPPStatus

-- Alternate Method using Derived Query
SELECT BPPStatus, BPPStatusDescription
FROM (SELECT BPPStatus, BPPStatusDescription, ROW_NUMBER() OVER (PARTITION BY BPPStatus ORDER BY BPPStatus) AS RowNumber
      FROM SEACommonTransform.dbo.vEDWWorkerDim) AS D
WHERE RowNumber <= 1
ORDER BY D.BPPStatus



   
  
  