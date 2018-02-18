/*
OVER Clause  ... uses PARTITION BY Clause.   Will allow you to join Detail and Summary Fiels in the same Row.  
*/

SELECT 
      JobTitle
      ,[BirthDate]
      ,[MaritalStatus]
      ,Gender
      ,[HireDate] 
      ,COUNT(Gender) OVER (PARTITION BY Gender) AS PG 
      ,Count([JobTitle]) OVER (PARTITION BY Gender) AS Title
	  ,COUNT([MaritalStatus]) OVER (PARTITION BY Gender) AS MS
FROM [AdventureWorks2014].[HumanResources].[Employee] 




-- Long way of joing Detail and Summary Rows without using the OVER and PARTION BY Clause

--- Detail 
 SELECT 
      [JobTitle]
      ,[BirthDate]
      ,[MaritalStatus]
      ,D.Gender
      ,[HireDate]
	  ,Title
	  ,MS
	  ,Gen_count
  FROM [AdventureWorks2014].[HumanResources].[Employee] AS D
  INNER JOIN
-- Summary
  (SELECT
	  Gender AS GENDER
      ,Count([JobTitle]) AS Title
      ,COUNT([MaritalStatus]) AS MS
      ,COUNT(Gender) AS Gen_count
   FROM [AdventureWorks2014].[HumanResources].[Employee] 
   GROUP BY GENDER) AS S
   ON D.Gender = S.GENDER
   
  
  