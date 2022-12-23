/*
Create database objects
- Create and modify constraints (simple statements)
 
  Create constraints on tables; define constraints; unique constraints; default constraints; primary and
  foreign key constraints
   
Types of Contraints

* Not Null     - Making sure every row has a value.  Insert will fail if value is not populated.

* Default      - If while populating a table you miss giving a column some value, the default value will be used.

* Unique       - Makes sure that all values entered for the field on which the constraint is applied are different.
                 Will get error on duplicate values.

* Primary Key  - Most important, combination of 'Not Null' and 'Unique'.

* Foreign Key

* Check Constraint

https://www.youtube.com/watch?v=bIFB-rz315U&index=8&list=PL_RGaFnxSHWr_6xTfF2FrIw-NAOo3iWMy

CREATE TABLE with Constraints
https://www.w3schools.com/sql/sql_constraints.asp

SQL Constraints

Constraints could be either on a column level or a table level.  The column level constraints are applied to
one column, whereas the table level constraints are applied to the whole table.
https://www.tutorialspoint.com/sql/sql-constraints.htm



  1.  PRIMARY KEY CONSTRAINT
  2.  UNIQUE CONSTRAINT
  3.  FOREIGN KEY CONSTRAINTS
  4.  CHECK Constraint
  5.  DEFAULT Constraint

----------------
1. PRIMARY KEY 
---------------


What is a Primary Key Constraint?
- Column or combination of columns that makes each row in the table unique
- Distinguishes one row from another
- Can be a natural key or a surrogate key
- Provides relationships among tables in the database
Surrogate Key - An integer column with no other function than to provide a unique value.

PRIMARY KEY Constraint requirements
- A table can contain at most one PRIMARY KEY
- Column or columns used cannot allow NULL
- If data already in table, must be unique for the column used
- To redefine the PRIMARY KEY, all relationships must be deleted first
- To modify using Transact-SQL, delete key and re-create with new definition.

Primary Key - Behind the Scenes
- SQL Server creates a unique index on the column to enforce the constraint
- Primary key column(s) as index key
- Clustered index created (if none exists in table); otherwise, non-clustered index created.

Listing PRIMARY KEY Constraints
Use sys.key_constraints to list constraints for database - filter for type 'PK'
Example:
SELECT *
FROM sys.key_constraints
WHERE type = 'PK'

Use INFORMATION_SCHEMA.TABLE_CONSTRAINTS
Example:
SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY'

PRIMARY KEY Example
When creating table:
  CREATE TABLE Production.Products
    (ProductID int NOT NULL IDENTITY,
	 ProductName varchar(25) NOT NULL,
	 Price money NULL,
	 ProductDescription text NULL
	 CONSTRAINT PK_Products_ProductID PRIMARY KEY(ProductID)
	 );
On an existing table:
   ALTER TABLE Production.Products
     ADD CONSTRAINT PK_Products_ProductID PRIMARY KEY(ProductID);

Deleting the PRIMARY KEY Constraint
- Make sure all relationships to the PRIMARY KEY are deleted first the
  use ALTER TABLE..DROP CONSTRAINT syntax
  Example:
  ALTER TABLE Production.Products
    DROP CONSTRAINT PK_Products_ProductID;
NOTE: When you delete the PRIMARY KEY, the corresponding index is also deleted.

*/
SELECT *
FROM sys.key_constraints
WHERE type = 'PK'

SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY'
/*
--------------------
2. UNIQUE CONSTRAINT
--------------------
What is a UNIQUE Constraint ?
- Enforces no duplicate values entered in a column.
- Automatically creates a unique index
- Can be created on a computed column
Note: Unlike the PRIMARY Key, you can define multiple UNIQUE constraints on a table.

UNIQUE Constraint Requirements
- Column or columns used CAN allow NULL - but only one!!!
- If data already in table, must be unique for the column used
- To modify using Transact-SQL, delete UNIQUE constraint and re-create with new definition
- To remove uniqueness on a column or columns using constraint, delete UNIQUE constraint

Creating a UNIQUE Constraint
When creating a table:
CREATE TABLE Production.Products
  (ProductID int NOT NULL,
   ProductName varchar(50) NOT NULL,
   Price money NULL,
   ProductDescription varchar (max) NULL,
   CONSTRAINT PK_Products_ProductID PRIMARY KEY(ProductID),
   CONSTRAINT UQ_Products_ProductName UNIQUE(ProductName)
   );
On an existing table:
  ALTER TABLE Production.Products
    ADD CONSTRAINT UQ_Products_ProductName UNIQUE(ProductName);

Listing UNIQUE Constraints
Use sys.key_constraints to list constraints for database - filter for type 'UQ'

Use INFORMATION_SCHEMA.TABLE_CONSTRAINTS

SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'UNIQUE'

Modifying or Deleting a UNIQUE Constraint
- First DROP the CONSTRAINT
- If modifying, re-create with new definition

--  Delete the unique constraint
ALTER TABLE Production.Products
 DROP CONSTRAINT UQ_Products_ProductName;



*/

SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'UNIQUE'
GO
SELECT  name
FROM sys.objects
WHERE type = 'UQ';

/*
--------------------------------
3.  FOREIGN KEY CONSTRAINTS
--------------------------------
What IS A FOREIGN KEY ?
- A link to look up data in another table
- Establishes and enforces the link between two tables
- Column(s) holding the PRIMARY KEY for one table are referenced by the 
  columns in the other table.
- Does not automatically create an index
NOTE: When you define the FOREIGN KEY Constraint (in the foreign table) you
reference the PRIMARY KEY column in the originating table

FOREIGN KEY Requirements
- Declare the FOREIGN KEY in the table where it is foreign
- Use ALTER TABLE in the foreign table to define the key
- Use WITH CHECK to check for violations to key with existing table data
- Add the lookup column (REFERENCES) while defining the FOREIGN KEY
- Column being referenced must be a primary key or unique constraint
- Columns referenced in each table must have same data type
Best Practice: Use FK_ as a prefix in the foreign key name

Creating a FOREIGN KEY
Example:
ALTER TABLE Production.Products WITH CHECK
   ADD CONSTRAINT FK_Products_Categories FOREIGN KEY(CategoryID)
   REFERENCES Production.Categories (CategoryID);

Referential Integrity
FOREIGN KEY
- Also controls changes to PRIMARY KEY table
- Enforces referential integrity by guarenteeing no changes can be 
  made to primary key table data if those changes invalidate the link
  to data in the foreign key table.
- Uses Cascading Referential Integrity to define actions when a 
  user tries to delete or update a key to which existing foreign keys
  points.

Cascading Referential Integrity Constraint allows to define the actions
Microsoft SQL Server should take when a user attempts to delete or 
update a key to which an existing foreign key points.
For example, if you delete row with ID=1 from tblGender table, then row
with ID=3 from tblPerson table becomes an orphan record.  You will not be
able to tell the Gender for this row.  So Cascading referential integrity
constraint can be used to define actions Microsoft SQL Server should take
when this happens.  By default, we get an error and the DELETE or UPDATE is
rolled back.

Cascading referential integrity
Options when setting up Cascading referential integrity constraint:
1. No Action: This is the default behavior.  No Actions specifies that if an
attempt is made to delete or update a row with a key referenced by foreign
keys in exsting rows in other tables, an error is raised and the DELETE
or UPDATE is rolled back.  Get error message '547'

2. Cascade: Specifies that if an attempt is made to delete or update a row
with a key referenced by foreign keys in an existing rows in other tables,
all rows containing those foreign keys are also deleted or updated.

3. SET NULL: Specifies that if an attempt is made to delete or update a row
with a key referenced by foreign keys in existing rows in other tables, all
rows containing those foreign keys are set to NULL.

4. Set Default: Specifies that if an attempt is made to delete or update a row
with a key referenced by foreign keys in existing rows in other tables, all
rows containing those foreign keys are set to default values.
https://www.youtube.com/watch?v=ETepOVi7Xk8

Example: See explanation above for 'No Action' and 'Cascade'.  Different actions for Delete and Update.
Please Note, the above 4 are all Cascading Referential Integrity Options.  This is confusing since one of 
the options is 'Cascade'.  The 'No Action' option is still a Cascade Referential Integrity option.
CREATE TABLE Ref(
  RefID int PRIMARY KEY,
  RefData varchar(200))
CREATE TABLE Referencing(
  ReferID int,
  RefId int FOREIGN KEY REFERENCES Ref(RefID)
  ON DELETE CASCADE
  ON UPDATE NO ACTION)


Indexing the FOREIGN KEY
Note:
To improve query performance when creating joins, you will need to
create a nonclustered index on the FOREIGN KEY in the referencing table.

-- Example 1
Listing Foreign Keys for a database
SELECT *
FROM sys.foreign_keys

-- Example 2   (Nice!!)
SELECT
  name AS [Foreign Key],
  OBJECT_NAME(parent_object_id) AS [Parent Object Name],
  OBJECT_NAME(referenced_object_id) AS [Referenced Object Name]
FROM sys.foreign_keys

-- Example 3
Use INFORMATION_SCHEMA.TABLE_CONSTRAINTS
SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'FOREIGN KEY';

Modifying or Deleting FOREIGN KEY Reference
- First Drop the FOREIGN KEY
- If modifying, re-create with new definition
Example:
  ALTER TABLE Production.Products
    DROP CONSTRAINT FK_Products_Categories;


Comments!
If you want to create a map of Referencing Tables with Foreign Keys and Ref Tables follow
the below procedure.
1.  Open up a Table example.  TAMUS.dbo.FRSBatchAbrGrFb.
2.  Open Keys Folder.  You will see Primary Key and Foreighn Key Listed.
3.  Open Foreign Key.  You will see: 
ALTER TABLE [dbo].[FRSBatchAbrGrFb]  WITH NOCHECK ADD  CONSTRAINT [FRSBatchAbrGrFb_FKY] FOREIGN KEY([ISN])
REFERENCES [dbo].[FRSTables] ([ISN])
ON DELETE CASCADE
4.  The above tells you the REF table is dbo.FRSTables and a join can be done by ISN. 
5.  The above is also defined as 'CASCADE' so that means that if a row is deleted from FRSTables then it 
    will get deleted from all rows in FRSBatchAbrGrFb.  It also means that if a row is updated from FRSTablles
	then it will get updated when you use foriegn key in dbo.FRSBatchAbrGrFb.  Wow!  
 

/*
--------------------
4. CHECK Constraint
--------------------
What is a CHECK Constraint?
- Limits allowable values for the data type in the column(s)
- Defines the valid values for the column(s)
- Works as a filter on data -much like WHERE in a SELECT statement
- Since defined in a table, it will always be enforced.

Using CHECK constraints
- Multiple CHECK Constraints can be applied to one column
- One CHECK Constraint can be applied to multiple columns
- CHECK Constraints work at the row level of the table
- Returns TRUE when value being checked is not False

- Column level CHECK constranints references on the column(s) it defines
- Table level CHECK constraint references columns only in the same table

Check Constraint is used to limit the range of the values, that can be entered for a column.

The general formula for adding a check constraint in SQL Server:
ALTER TABLE {TABLE_NAME}
ADD CONSTRAINT {CONSTRAINT_NAME} CHECK {BOOLEAN_EXPRESSION}

To drop the CHECK Constraint:
ALTER TABLE tblPerson
DROP CONSTRAINT CK_tblPerson_Age 


Add a Contraint"
ALTER TABLE tblPerson
Add Constraint CK_tblPerson_Age CHECK (AGE> 0 AND AGE < 150)

If the BOOLEAN_EXPRESSION returns true, then the CHECK constraint allows the value,
otherwise it doesn't.  Since, AGE is a nullable column, it's possible to pass null
for this column, when inserting a row.  When you pass NULL for the AGE column, the 
boolean expression evaluates to UNKNOWN, and allows the value.
https://www.youtube.com/watch?v=9Zj5ODhv0b0

Listing CHECK Constraints
Use sys.check_constraints to list CHECK constraints for database

SELECT *
FROM sys.check_constraints

Use INFORMATION_SCHEMA.TABLE_CONSTRAINTS
SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'CHECK';

-- Retry the name of CHECK Constraint
SELECT name FROM sys.objects
WHERE type = 'C'

https://database.guide/what-you-should-know-about-with-nocheck-when-enabling-a-check-constraint-in-sql-server/

-- Review Check Constraints.  Gets name of contraints
SELECT 
  name,
  is_disabled,
  is_not_trusted,
  definition
FROM sys.check_constraints;

-- Disable the Constraints
ALTER TABLE Occupation  
NOCHECK CONSTRAINT chkJobTitle;    -- Where chkJobTitle is the name of constaint in your database
----------------------
5. DEFAULT Constraint
----------------------
What is a DEFAULT Constraint?
- Not really a Constraint
- Adds a default value to table column during an INSERT if no value specified
- If NULLs are allowed, default value replaces NULL
- If NULLs are not allowed, default values enable row values to be saved if nothing is specified for column.

Using DEFAULT Constraints
- When adding to existing column with data, only adds default to new data
- When deleting a default definition a NULL values is inserted for new rows - no changes to existing data
- When adding a column with default in table with existing data, can specify all existing rows
  get default instead of NULL
- Cannot be applied to columns defined as timestamp or those with IDENTITY property
- When table is dropped, the any definitis are complely removed

Creating a DEFAULT Constraint
When creating a table:
CREATE TABLE Production.ProductsNew
  (ProductID INT NOT NULL,
   ProductName varchar (50) NOT NULL
   Price money NOT NULL
     CONSTRAINT DFT_ProductsNew_price DEFAULT(0)
	 );

GO;
Adding Default Constraint to an existing table:
ALTER TABLE Production.Products
   ADD CONSTRAINT DFT_Products_price
   DEFAULT (0) FOR Price
GO;

Listing DEFAULT Constraints
Use sys.default_constraints to list DEFAULT constraints for database
SELECT *
FROM sys.default_constraints;

Use sys.objects to list DEFAULT definition constraints for database
SELECT *
FROM sysobjects
WHERE xtype = 'D';

To Modify or Delete a DEFAULT Constraint
- First DROP the Constraint

- Return the name of DEFAULT Constraint
SELECT name
FROM sysobjects
WHERE xtype = 'D';
GO;
-- Delete the DEFAULT Constraint
ALTER TABLE Production.Products
DROP CONSTRAINT DFT_Products_price;
GO;











*/