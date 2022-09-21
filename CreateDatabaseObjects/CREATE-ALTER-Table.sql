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

ALTER TABLE  and ALTER COLUMN
https://www.w3schools.com/sql/sql_alter.asp

ALTER TABLE cannot be used to:
- Change column names
- Add an IDENTITY Property
- Remove an IDENTITY Property

DROP and TRUNCATE TABLE
https://www.w3schools.com/sql/sql_drop_table.asp
Using DROP TABLE
- Removes the table definition
- Removes all data
- Removes all ancillary objects of the table - indexes, triggers, constraints
- Removes permission specifications
If you re-create the table, all of the above must be re-created
Any view or stored procedure referencing the dropped table must
be explicitly dropped using DROP VIEW or DROP PROCEDURE
To get a list of dependencies on a table, use
  sys.dm_sql_referencing_entities

Examples: 
Select * from sys.dm_sql_referencing_entities('dbo.sp_GetEmployeesandDepartments','Object')
Select * from sys.dm_sql_referenced_entities('dbo.sp_GetEmployeesandDepartments','Object')

Difference between referencing entity and referenced entity
A dependency is created between two objects when one object appears by name inside a SQL statement
stored in another object.  The object which is appearing inside the SQL expression is known as
REFERENCED ENTITY and the object which has the SQL expression is known as REFERENCING ENTITY

Referencing entities sys.dm_sql_referencing_entities
Referenced entitites sys.dm_sql_referenced_entities

Create view VwEmployees   --> REFERENCING ENTITY
as
Select * from Employees   --> REFERENCED 

Difference between Schema-bound dependency and Non-Schema-bound dependency.
Schema-bound-dependency:Schema-bound dependency prevents referenced objects
from being dropped or modified as log as the referencing object exists.  You
can't drop table 'Employees' if the view exists.
Example:  A view created with SCHEMABINDING, or a table created with foreign key constraint.
So the SCHEMABINDING statement will be in the view when it is defined.  The forieign key constraint
will be done when the table is defined.

Create view VwEmployees  --> Referencing Entity
WITH SCHEMABINDING
AS
Select * from Employees  --> Referenced Entity

Tables
Departments
Employees   (references Departments)
Note! You have to delete Employees first (Referencing table) before you can delete Departments.   This is because Employees 
references Departments.  


Non-schema bound dependency: A non-schema-bound dependency doesn't prevent the referenced object
from being dropped or modified.

https://www.youtube.com/watch?v=c1NCzfo2_jo

DELETE tablename - A table exists even if you delete all rows in a table
using DELETE tablename.
TRUNCATE tablename - removes all the table names from the table, but the
table structure, column constraints, indexes, etc. will remain.



Identity Column on SQL Server
https://www.youtube.com/watch?v=aOkFE6NLGCQ&list=PL08903FB7ACA1C2FB&index=7

Identity by Example
http://www.sqlservertutorial.net/sql-server-basics/sql-server-identity/

Using the IDENTITY Property 
- Automatically generates a numerical sequence.
- Can be used for only one column in a table.
- Need to Specify seed and increment values.
- Often used to generate key columns.
- Does NOT guarentee uniqueness
- Does NOT guarentee there will be no gaps - i.e. in the case of a failed insert.
- No cycling support - would need to reseed.

IDENTITY Property Syntax
- seed (value used for very first row loaded into the table)
- increment (value that is added to identity value of the previous row)

SEQUENCE (new feature introduced in SQL Server 2012). 
- Used to generate database-wide sequential numbers
- Can be used in multiple tables
- Can be used in insert statement to insert identity values
- Can be used to CYCLE numbers
If you need to start over and recylce your sequence numbers then you can use SEQUENCE.

When to use SEQUENCE. 
-  SEQUENCE is preferred over IDENTITY because it is stored at the database level.  When
you need a method to automate numbers over an entire database then you would use 
SEQUENCE.
-  When you need a number before data is inserted into a table then you would use SEQUENCE.
-  Single series of numbers needs to be shared between multiple tables or multiple	
   columns within a table.
- Series needs to be recycled when a specified number is reached.
- If you need multiple numbers that need to be assigned at the same time.
- If you need to change the specification of the sequence, such as increment value.
Note! - If a data type is not specified the SEQUENCE will default to bigint.

SYNTAX:
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-sequence-transact-sql?view=sql-server-ver15

NEXT VALUE FOR
https://docs.microsoft.com/en-us/sql/t-sql/functions/next-value-for-transact-sql?view=sql-server-ver15

   
Examples:
IF OBJECT_ID('HumanResources.Programmers') IS NOT NULL DROP TABLE HumanResources.Programmers;
GO

CREATE TABLE HumanResources.Programmers
(
  entityID INT NOT NULL IDENTIY(1,1)
      CONSTRAINT PK_Programmers_entityID PRIMARY KEY,
	  loginID nvarchar(256) NOT NULL,
	  JobTitle nvarchar(50) NOT NULL,
	  HireDate DATE NOT NULL
	    CONSTRAINT DFT_Programmers_HireDate DEFAULT (CAST(SYSDATETIME() AS DATE)),
	  VacationHours smallint NOT NULL

);


*/