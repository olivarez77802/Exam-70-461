/*
ROW_NUMBER() Clause  ....  

Needs the OVER (ORDER BY ... Clause

ROW_NUMBER() Will start over with each Partition see second example

Since ROW_NUMBER() starts over with each partition ... if you wanted to identify duplicates this could easily be done
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



   
  
  