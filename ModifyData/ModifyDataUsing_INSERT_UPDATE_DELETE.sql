/*
Modify Data by using INSERT, UPDATE, and DELETE Statements
- Given a set of code with defaults, constraints, and triggers, determine the output of a set of DDL; know 
  which SQL Statements are best to solve common requirements; use output statement.



Different ways of Updating Tables

1. INLINE TABLE Value Function (Updates not possible with Multi-Statement Table Value Function)
   Update is possible because INLINE TABLE does not define a table so the base table is used 
   whereas MULTI Statemement tables acutally defines a table that is separate from base table.

2.  If a CTE is created on one base table, then it is possible to UPDATE the CTE, which will in
     turn update the underlying base table.
    If a CTE is based on more than one table, and if the UPDATE affects only one base table, 
    then the UPDATE is allowed.
	If a CTE is based on multiple tables, and if the UPDATE statement affects more than 1 base
    table, then the UPDATE is not allowed.


OUTPUT Clause
https://docs.microsoft.com/en-us/sql/t-sql/queries/output-clause-transact-sql?view=sql-server-2017

Columns returned from OUTPUT reflect the data as it is after the INSERT, UPDATE, or DELETE statement
has completed but before triggers are executed.

For example, OUTPUT DELETED.* in the following DELETE statement returns all columns deleted from 
the ShoppingCartItem table:
  
  DELETE Sales.ShoppingCartItem  
       OUTPUT DELETED.*;  

-- End OUTPUT Clause

@@ROWCOUNT   - Returns the number of rows affected by last statement
USE AdventureWorks2012;  
GO  
UPDATE HumanResources.Employee   
SET JobTitle = N'Executive'  
WHERE NationalIDNumber = 123456789  
IF @@ROWCOUNT = 0  
PRINT 'Warning: No rows were updated';  
GO  
https://docs.microsoft.com/en-us/sql/t-sql/functions/rowcount-transact-sql?view=sql-server-2017

TRIGGERS
-- See "Create Database Objects" - CreateAndAlterDMLTriggers.sql


/* 
Example of Updating the underlying Table using INLINE Table Function
https://www.youtube.com/watch?v=EgYW7tsNP6g&list=PL08903FB7ACA1C2FB&index=32
*/
Update dbo.fn_EmployeesByGender('F') SET Gender = 'M' WHERE BusinessEntityID = 2

-- Sp_HELPTEXT fn_EmployeesByGender 

/* Stores the following under directory Functions/Table-valued Functions
*/
--CREATE FUNCTION fn_EmployeesByGender(@Gender nvarchar(10))
--RETURNS TABLE
--AS
--RETURN (SELECT 
--      JobTitle
--      ,[BirthDate]
--      ,[MaritalStatus]
--      ,Gender
--      ,[HireDate] 
--FROM [AdventureWorks2014].[HumanResources].[Employee]
--WHERE Gender = @Gender) 

USE TRS
sp_helptext [fncGetEmploymentAsOf]

*/