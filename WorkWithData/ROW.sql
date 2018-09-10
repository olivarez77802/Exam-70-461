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
  DELETE FROM EmployeesCTE WHEREH RowNumber > 1

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



   
  
  