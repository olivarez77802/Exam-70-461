/*
Create database objects
- Create and alter tables using T-SQL Syntax (simple statements)
  Create tables without using the built in tools; ALTER; DROP; ALTER COLUMN; CREATE

------------------------------------------------------------------------------------
SYNTAX
http://www.cheat-sheets.org/sites/sql.su/

CREATE TABLE,  CREATE TABLE using another Table.  
https://www.w3schools.com/sql/sql_create_table.asp

CREATE TABLE with Constraints
https://www.w3schools.com/sql/sql_constraints.asp

ALTER and ALTER COLUMN
https://www.w3schools.com/sql/sql_alter.asp

DROP and TRUNCATE TABLE
https://www.w3schools.com/sql/sql_drop_table.asp

Identity Column on SQL Server
https://www.youtube.com/watch?v=aOkFE6NLGCQ&list=PL08903FB7ACA1C2FB&index=7

Identity by Example
http://www.sqlservertutorial.net/sql-server-basics/sql-server-identity/

Methods of Inserting Data
* INSERT VALUES - Inserts single or multiple rows of data into table
* INSERT SELECT - Inserts the result set of a query into specified table
* INSERT EXEC - Uses the EXECUTE clause to call a stored procedure or 
                dynamic batch that contains the SELECT statment which 
				inserts result into specified table.
* SELECT INTO - Creates target table defined by 'SELECT' Table and inserts query results.
https://www.w3schools.com/sql/sql_insert.asp

Identity Column
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-table-transact-sql-identity-property?view=sql-server-ver15


Table must already be defined when using INSERT VALUES;INSERT SELECT; and INSERT EXEC.

Using INSERT VALUES
- Does not specify value for column with IDENTITY property unless :
  SET IDENITY_INSERT <table> ON;
  Best practice:specify target column names after table names. Example:
  INSERT INTO HumanResources.Contractors (loginID, JobTitle, HireDate)
  VALUES (N'adventure-works\marilyn',N'Course Developer',DEFAULT);

Using INSERT SELECT
- Inserts the result set of a query into a specified table
Example
SET IDENTITY_INSERT HumanResources.Contractors ON
INSERT INTO HumanResources.Contracters (entityID, loginID, JobTitle, HireDate)
  SELECT BusinessEntityID, loginID, JobTitle, HireDate
  FROM HumanResources.Employee
  WHERE SalariedFlag = 0;

Using INSERT EXEC
- Uses the EXECTUTE clause to call a stored procedure that contains the SELECT
statement which inserts the result set into the specified table.  Example:
CREATE PROC HumanResources.ContractorsStatus @EmployeeStatus AS bit
AS
   SELECT BusinessEntityID, LoginID, Titlle, HireDate
   FROM HumanResources.Employee
   WHERE SalariedFlag = @EmployeeStatus;
GO
-- Run the stored procedure to insert the results into specified table.
SET IDENTITY_INSERT HumanResources.Contractors ON;
INSERT INTO HumanResources.Contractors (EntityID, LoginID, JobTitle, HireDate)
  EXEC HumanResources.ContractorStatus @EmployeeSTatus = 1;
SET IDENTITY_INSERT HumanResources.Contractors OFF;

USING SELECT INTO
- Creates table based on existing table definition and inserts values based
  on query results. Example:
IF OBJECT_ID('HumanResources.Contractors','U') IS NOT NULL
DROP TABLE HumanResources.Contractors;
-- Use SELECT INTO to create and fill new Contractors table
SELECT BusinessEntitityId,LoginID, JobTitle, HireDate
INTO HumanResources.Contractors
FROM HumanResources.Employee
WHERE SalariedFlag = 0;






*/