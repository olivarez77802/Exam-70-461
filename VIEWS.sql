/*
VIEWS

Views get saved in the database, and can be available to other queries and stored procedures.
However, if the view is only used in one place, it can be replaced using CTE, Derived Tables,
Temp Tables, Table Variable etc.

View Advantages.
1.  You can use the WHERE Clause
    

View Limitations
1. Views cannot have parameters.   Need to use INLINE TABLE Functions as a replacement for parameterized views.


Examples
-- Using WHERE Clauses
Select * FROM vEmployee WHERE EID = 3
*/

SP_HELPTEXT vEmp

--CREATE VIEW vEmp
--AS
--SELECT 
--      JobTitle
--      ,[BirthDate]
--      ,[MaritalStatus]
--      ,Gender
--      ,[HireDate] 
--	  ,ROW_NUMBER() OVER (ORDER BY Gender) AS GEN 
--FROM [AdventureWorks2014].[HumanResources].[Employee] 





   
  
  