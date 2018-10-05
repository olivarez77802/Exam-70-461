/*
VIEWS

Views get saved in the database, and can be available to other queries and stored procedures.
However, if the view is only used in one place, it can be replaced using CTE, Derived Tables,
Temp Tables, Table Variable etc.

View Advantages.
1.  You can use the WHERE Clause
    

View Limitations
1. Views cannot have parameters.   Need to use INLINE TABLE Functions as a replacement for parameterized views.

Inline Table Valued functions can be used to achieve the functionality of a parameterized views.
The table returned by the table value function, can also be used in joins with other tables.
Inline Tables have better performance that Multi Statement Table Valued Functions because internally,
SQL Server treats an inline table valued function much like it would a view and treats a multi-statement
table valued function similar to how it would a stored procedure.

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





   
  
  