/*
Modify data by using INSERT, UPDATE, and DELETE Statements
- Given a set of code with defaults, constraints, and triggers, determine the output of a set of DDL;
  know which SQL statements are best to solve common requirements; use output statement

  1. INSERT DATA
  2. UPDATE DATA
  3. DELETING DATA

Best practices before Modifying Data
- Always query to verify data before modifying
- Use column names or literals to improve the readability of a result set
- Always include WHERE clause when using UPDATE or DELETE
- If deleting all rows in a table, use TRUNCATE TABLE - Faster and fewer logging resouces



---------------------------------------
1. INSERT DATA
---------------------------------------
Steps to Copy Prod Records to Dev
1. Create a Table of Prod Data (use SEA-FA-SQL)
2. You have to understand column names to be inserted the best way to do this 
   is to type INSERT dbo.TableName and automatically the Insert and Values statement
   will appear.  You will use this to make your Select col1,col2..ISN statement.  The column
   names will not inculde FBI indexes but will include the ISN field.   The ISN created in Dev
   will be the same as in Prod.
3. Your finished statement should look something like this
INSERT INTO dbo.FRSPayrollDetail
SELECT col1,
       col2,
       ..
       ISN
FROM dbo.FRSPayroll_Detail_92001253_Prod
4. You should now do a Select to review 


Methods of Inserting Data
- INSERT VALUES - Inserts single or multiple rows of data into table
- INSERT SELECT - Inserts the result set of a query into specified table
- INSERT EXEC - Uses the EXECUTE clause to call a stored procedure or dynamic batch that contains the SELECT statement
                which contains the SELECT statement which inserts the result set into the specified table.
- SELECT INTO - Creates target table defines table and inserts query results

Understanding the Methods
Best practice: When using INSERT statements, specify column names to avoid column order dependency.
- When using INSERT statements, columns that get values automatically can be omitted
- Using INSERT statements require the target table has already been created
- Using SELECT INTO creates the target table using the definition of the data being inserted
- Using SELECT INTO does not copy indexes, constraints, or triggers from the source

SQL Insert INTO SELECT Statement
https://www.w3schools.com/sql/sql_insert_into_select.asp

Copy all columns from one table to another table
INSERT INTO table2
SELECT * FROM table1
WHERE condition; 

Create Index
https://www.w3schools.com/sql/sql_create_index.asp
Example:
CREATE INDEX idxPayEmployee_UIN
ON dbo.PayEmployee_Prod (EmUin)

----------------------------
1A.  Using INSERT VALUES
----------------------------
Does not specify value for column with IDENTITY property unless:
 - SET IDENTITY_INSERT <table> ON;
Best practice: specify target column names after table name
Example:
INSERT INTO HumanResources.Contractors (loginID, JobTitle, HireDate)
VALUES (N'adventure-works\jesse', N'Developer', DEFAULT);

---------------------------
1B. Using INSERT SELECT
---------------------------
Inserts the result set of a query into a specified table
Example:
SET IDENTY_INSERT HumanResources.Contractors ON;
INSERT INTO HumanResources.Contractors (entityID, loginID, JobTitle, HireDate)
  SELECT BusinessEntityID, LoginID, JobTitle, HireDate
  FROM HumanResources.Employee
  WHERE SalariedFlag = 0;

SET IDENTITY_INSERT HumanResources.Contractors OFF;

---------------------------
1C. Using INSERT EXEC
---------------------------
Uses the EXECUTE clause to call a stored procedure that contains the SELECT
statement which inserts the result set into the specified table:
Example:
CREATE PROC HumanResources.ContractorsStatus
   @EmploymentStatus AS bit
AS
   SELECT BusinessEntityID, loginID, JobTitle, HireDate
   FROM HumanResources.Employee
   WHERE SalariedFlag = @EmployeeStatus;
GO;
INSERT INTO HumanResources.Contractors(EntityID, loginID, JobTitle, HireDate)
  EXEC HumanResources.ContractorStatus @EmploymentStatus = 1;

SET IDENTITY_INSERT HumanResources.Contractors OFF;

--------------------------
1D. SELECT INTO
--------------------------
Creates the table based on existing table definition and inserts values based
on query results:
Example:
IF OBJECT_ID('HumanResources.Contractors','U') IS NOT NULL
   DROP TABLE HumanResources.Contractors;

 -- Use SELECT INTO TO CRATE AND FILL new Contractors table 
 -- with only contractors employed by company
SELECT BusinessEntityID, loginID, JobTitle, HireDate
INTO HumanResources.Contractors
FROM HumanResources.Employee
WHERE SalariedFlag = 0;

/*
* Example where I created a table in dev where I only stored my UIN.
*/
SELECT *
INTO dbo.PayEmployee_Test
FROM dbo.PAYEmployee
WHERE EMUIN = '802002713'

/*
*  Example where I copied a production table and created a new table in Dev environment.
*  I had to create my own index to the new table so I could use to filter.
*
*/
SELECT * 
INTO dbo.PayEmployee_Prod
FROM OPENQUERY([SEA-FA-SQL], 'SELECT * FROM FAMISMOD.dbo.PayEmployee' )

CREATE INDEX idxPayEmployee_UIN
ON dbo.PayEmployee_Prod (EmUin)

----------------------
2. UPDATE DATA
----------------------
Methods of Update
2A. - Using the Standard UPDATE Statement
2B. - Using Variables
2C. - Using Joins
2D. - Using Subquery Expressions
2E. - Join Subqueryy




------------------------
2A. Standard Update
------------------------

Standard Update Syntax
UPDATE Target
  SET Column_Name1 = eExpression1 [,Column_Name2 = eExpresssion2..]
WHERE <predicate>;
- Specify rows to update in WHERE
- Specify new values with SET
- Update in only one table at a time
- Rows that violate integrity constraints are not updated

Using the Standard UPDATE Statement
Example:
UPDATE HumanResoures.Programmers
  SET HireDate = GETDATE()
  WHERE BusinessEntityID IN (11,12,17);
-- UPDATE without WHERE updates single column for all rows in a table
-- WHERE <predicate> clause specifes rows to be updated
-- Updates can include computed values, subqueries, and DEFAULT Values

----------------------
2B. - Using Variables
----------------------

Update Data using Variables
Example:
DECLARE @NewVacationHrs int = 10;
UPDATE HumanResources.Programmers
SET VacationHours += @NewVacationHrs
WHERE BusinessEntityID = 12

--------------------------
2C. - Using JOINS
--------------------------

Update Data using JOINS
-- Update rows in table based on criteria from related rows in other tables
-- SET in example replaces OrderAmount in Vendors table with SalesAmount in
   Orders table
Example:
UPDATE VEN
  SET VEN.OrderedAmount = ORD.SalesAmount
  FROM SALES.Vendors VEN
  INNER JOIN Sales.Orders ORD
    ON VEN.VendorID = ORD.VendorID;

----------------------------------
2D. - Using SubQuery Expressions
----------------------------------
Update Data Using SubQuery Expressions
-- UPDATE can use subqueries, CTEs, and derived tables to determine
   either value used or entities to update
-- Add 5 Vacation Hours to last 2 hires
UPDATE HumanResources.Programmers
SET VacationHours += 5
FROM (SELECT TOP 2 BusinessEntityID FROM HumanResources.Programmers
      ORDERS BY HireDate DESC) AS th
WHERE HumanResources.Programmmers.BusinessEntityID = th.BusinessEntityID;
GO

------------------------------------
2E.  JOIN SubQuery
------------------------------------
UPDATE m
SET m.Foo = f.valsum
FROM [Master] m
INNER JOIN (SELECT ID, SUM(val) valsum
FROM [Foos]
GROUP BY ID) f ON m.ID = f.ID


-------------------------
3. DELETE DATA
-------------------------
Methods of Deleting Data
3A. - Use the DELETE Statement
3B. - Using DELETE based on a join or subquery
3C. - Using DELETE with Table Expressions
3D. - Using TRUNCATE TABLE Statement

-------------------------------
3A. Using the DELETE Statement
-------------------------------

DELETE FROM <table_or_view_name>
WHERE <predicate>;
- Deletes all rows from a table unless restricted with WHERE Predicate
- Each deleted row logged in a transaction log
- Requires DELETE permissions on target

---------------------------------------
3B. DELETE Based on a Join or Subquery
---------------------------------------
DELETE FROM <table_or_view_name>
FROM <table_source>
WHERE <predicate>;
- First FROM indicates table from which rows deleted
- Second FROM introduces join or subquery and acts as restricting criteria for DELETE
Example:
  DELETE FROM Sales.NewSalesOrderDetail
    FROM Sales.SalesOrderHeader AS SOH
	INNER JOIN Sales.NewSalesOrderDetail AS OD
	  ON SOH.SalesOrderID = OD.SalesOrderID
  WHERE SalesOrderNumber = 'S043659'

-----------------------------------------------
3C.  DELETE with Table Expressions
-----------------------------------------------
- Use CTE or derived table to define rows to be deleted
- Use DELETE statement against the CTE or derived table
- Rows are deleted from underlying table
Example:
WITH FirstHires AS
(
  SELECT TOP (50) *
  FROM HumanResources.Programmers2
  ORDER BY HireDate
)
DELETE FROM FirstHires;

---------------------------------------
3D.  TRUNCATE TABLE
---------------------------------------
- Deletes all rows - removes all data - does not take a predicate
- Retains the table structure and associated objects
- Executes more quickly than DELETE - Logs only the deallocation of detail
  pages - deleted rows are not logged
- If table has IDENTITY, see value is reset
Example:
TRUNCATE TABLE HumanResources.Programmer2;



--------------------
ORIGINAL - Had before I created this file. Should be put above at some point
--------------------
/*
Modify Data by using INSERT, UPDATE, and DELETE Statements
- Given a set of code with defaults, constraints, and triggers, determine the output of a set of DDL; know 
  which SQL Statements are best to solve common requirements; use output statement.



Different ways of Updating Tables

1. INSERT INTO dbo.Table1 (eid, name, address)
   VALUES (1, 'Joe', '123 Some Street')

1. INLINE TABLE Value Function (Updates not possible with Multi-Statement Table Value Function)
   Update is possible because INLINE TABLE does not define a table so the base table is used 
   whereas MULTI Statemement tables acutally defines a table that is separate from base table.

2.  If a CTE is created on one base table, then it is possible to UPDATE the CTE, which will in
     turn update the underlying base table.
    If a CTE is based on more than one table, and if the UPDATE affects only one base table, 
    then the UPDATE is allowed.
	If a CTE is based on multiple tables, and if the UPDATE statement affects more than 1 base
    table, then the UPDATE is not allowed.

3.  Views can be updated in some cases..see CreateDatabaseObjects/CreateandAlterViews.sql
    UPDATE CUSTOMERS_VIEW
    SET AGE = 35
    WHERE name = 'Ramesh';
    This would ultimately update the base table CUSTOMERS and the same would reflect in the view itself.
 


OUTPUT Clause
https://docs.microsoft.com/en-us/sql/t-sql/queries/output-clause-transact-sql?view=sql-server-2017

Columns returned from OUTPUT reflect the data as it is after the INSERT, UPDATE, or DELETE statement
has completed but before triggers are executed.

For example, OUTPUT DELETED.* in the following DELETE statement returns all columns deleted from 
the ShoppingCartItem table:
  
  DELETE Sales.ShoppingCartItem  
       OUTPUT DELETED.*;  

-- End OUTPUT Clause

@@ROWCOUNT   - Returns the number of rows affected by last statement.  @@ROWCOUNT will get set back to zero by
any additional statement.  Compare to @@ERROR in ERROR-HANDLING.sql
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


*/