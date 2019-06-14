/*
Implement Data Types
  - Use appropriate data; understand the uses and limitations of each data type; impact of GUID(newid,
    newsequentialid) on database performance, when to use what data type for columns

1. Helpful Web Links
2. Regular Character Types versus Unicode Character Types 
3. CAST, CONVERT, and PARSE 
4. TRY_CAST, TRY_CONVERT, and TRY_PARSE  
5. Date and Time Styles
6. Variables
7. Fixed versus Dynamic Types
8. Data Type Precedence
9. GUID - Globally Unique Identifier



********************
PRINT using CAST
********************
PRINT 'Number of films = ' + CAST(@NumFilms AS VARCHAR(MAX))
https://www.youtube.com/watch?v=NmYaOlcbfZM&index=3&list=PLNIs-AWhQzcleQWADpUgriRxebMkMmi4H

******************
1. Helpful Web Links
******************

W3Schools Data Types
https://www.w3schools.com/sql/sql_datatypes.asp

SQL Data Types
https://www.w3resource.com/sql/data-type.php

Data Types in SQL
https://www.youtube.com/watch?v=6E1tZg6qAvI&list=PL_RGaFnxSHWr_6xTfF2FrIw-NAOo3iWMy&index=6
https://www.youtube.com/watch?v=7fOdo8PhPaw&index=7&list=PL_RGaFnxSHWr_6xTfF2FrIw-NAOo3iWMy

Fixed Types versus Dynamic Types
Fixed- CHAR, NCHAR, BINARY
Dynamic - VARCHAR, NVARCHAR, VARBINARY.

Fixed Typs. Attributes that get updated frequently, where update performance is a priority, you should consider
fixed types.  Fixed types use the storage for the indicated size.  This means that updates will not
require the row to physically expand.

Dynamic or Variable Types - use the storage for what you enter, plus a couple of bytes for offset information.
So for widely varying sizes of strings, if you use variable types you can save a lot of storage.

With character strings, there's also the question of using regular character types (CHAR, VARCHAR) versus
Unicode types (NCHAR, NVARCHAR).   Using Unicode types makes your code more universal.


*******************************************************
2. Regular Character Types versus Unicode Character Types 
******************************************************
Regular Character Types  - Uses one byte of storage per character and supports only one language besides English.
Delimited with single quotation marks, as in 'abc'.
- CHAR
- VARCHAR

Unicode Character Types - Uses two bytes of storage per character and supports multiple languages.  Storage
                          requirements are mitigated with Unicode compression.
Delimited with a capital N and then single quotation marks, as in N'abc'.
- NVARCHAR   N- Unicode VAR - Variable Length  CHAR - Character
- NCHAR

When defining attributes that represent the same thing accross different tables- especially ones that will
later be used as join columns, it is important to be consistent with the types.  Otherwise, when comparing
one attribute to another, SQL Server has to apply implicit conversion of one attribute types to the other, 
and this could have negative performance implications, like preventing the effecient use of indexes.

***********************************
3. CAST, CONVERT, and PARSE 
***********************************
To force a literal to be of a certain type, you may need to apply explicit conversions with functions like
CAST, CONVERT, PARSE, or TRY_CAST, TRY_CONVERT, and TRY_PARSE.


CAST, CONVERT, and PARSE will fail if the value is not convertible.  Use TRY_ if you don't want it to fail.

CAST and CONVERT
Syntax of CAST and CONVERT functions

CAST (expression AS data_type [(length)])
CONVERT (data_type [(length)], expression [, style])

Differences between CAST and Convert
1. Cast is based on ANSI standard and Convert is specific to SQL Server.  So if portablity is a 
concern and if you want to use the script with other database applications, use Cast().
2. Convert provides more flexibility than Cast.  For example, it's possible to control how you
want DateTime datatypes to be converted using sytles with convert function.
Note:  The general guideline is to use CAST(), unless you want to take advantage of the style
functionality in CONVERT().
3. CONVERT has a third argument representing the style of the conversion

Select Id, Name, DateOfBirth, CAST(DateOfBirth as nvarchar(11)) as ConvertedDOB from tblEmployees

Select Id, Name, DateOfBirth, CONVERT(nvarchar, DateOfBirth) as ConvertedDOB from tblEmployees
https://www.youtube.com/watch?v=8GHUfb5k-a8&index=28&list=PL08903FB7ACA1C2FB

The difference between functions without the TRY and their counterparts with the TRY is that
those without the TRY fail if the value isn't convertible, whereas those with the TRY return
NULL in such a case.  Example:
The following code fails
   SELECT CAST('abc' AS INT);
The below code reurns a NULL
   SELECT TRY_CAST('abc' AS INT);

********************************
4. TRY_CAST, TRY_CONVERT, TRY_PARSE
********************************
TRY_CAST, TRY_CONVERT, TRY_PARSE will return NULL if the value is not convertible.

-- TRY_PARSE(..)
Translates to the requested data type, or returns null if the cast fails.  
Use TRY_PARSE only for converting from string to date/time and number data types.

DECLARE @ fakeDate AS varchar(10);  
DECLARE @ realDate AS VARCHAR(10);  
SET @fakeDate = 'iamnotadate';  
SET @realDate = '13/09/2015;  
SELECT TRY_PARSE(@fakeDate AS DATE); --NULL  
SELECT TRY_PARSE(@realDate AS DATE); -- 2015-09-13  
SELECT TRY_PARSE(@realDate AS DATE USING 'Fr-FR'); -- 2015-09-13  
https://docs.microsoft.com/en-us/sql/t-sql/functions/try-parse-transact-sql?view=sql-server-2017#arguments

https://www.c-sharpcorner.com/UploadFile/manas1/tryparse-tryconvert-and-trycast-in-sql-server/

-- TRY_CONVERT(..)

Converts value to specified data type and if conversion fails it returns NULL. 
For example, source value in string format and we need date/integer format. Then this will help us to achieve the same.

Syntax: TRY_CONVERT ( data_type [ ( length ) ], expression [, style ] )
Data_type - The datatype into which to convert. Here length is an optional parameter which helps to get result in specified length.
Expression - The value to be convert
Style - It is an optional parameter which determines formatting. 
Suppose you want date format like “May, 18 2013” then you need pass style as 111. More on style visit here.
Examples:
DECLARE @sampletext AS VARCHAR(10);  
SET @sampletext = '123456';  
DECLARE @ realDate AS VARCHAR(10);  
SET @realDate = '13/09/2015’;  
SELECT TRY_CONVERT(INT, @sampletext); -- 123456  
SELECT TRY_CONVERT(DATETIME, @sampletext); -- NULL  
SELECT TRY_CONVERT(DATETIME, @realDate, 111); -- Sep, 13 2015  
https://www.c-sharpcorner.com/UploadFile/manas1/tryparse-tryconvert-and-trycast-in-sql-server/

Styles
https://www.experts-exchange.com/articles/12315/SQL-Server-Date-Styles-formats-using-CONVERT.html


********************
5. Date and Time Styles
********************

Cast and Convert
https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-2017

CONVERT has a third argument that represents the Style for the conversion.
--To get just the date part from DateTime
SELECT CONVERT(VARCHAR(10),GETDATE(), 101) -- Returns 09/02/2012

-- In SQL Server 2008, Date datatype is introduced, so you can also use
SELECT CAST(GETDATE() as DATE)   -- 2012-09-02
SELECT CONVERT(DATE, GETDATE())  -- 2012-09-02

*********
6. Variables
*********

Variables
  SET @local_variable
  SELECT @Local variable
  DECLARE @local_variable
PRINT
RAISERROR
CHECKPOINT
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/variables-transact-sql?view=sql-server-2017

A variable can also have a value assigned by being referenced in a select list. 
If a variable is referenced in a select list, it should be assigned a scalar value or 
the SELECT statement should only return one row. For example:

DECLARE @EmpIDVariable int;

SELECT @EmpIDVariable = MAX(EmployeeID)
FROM HumanResources.Employee;
GO


***************************
7. Fixed versus Dynamic Types
***************************
Fixed Types
- CHAR, NCHAR, BINARY
Updates will not require row to physically expand, therefore, no data shifting is required. Fixed
types are good to use when updates occur frequently, they have less overhead.

Dynamic Types
- VARCHAR, NVARCHAR, VARBINARY
Variable types use the storage for what you enter, plus a couple of bytes for offset information. So for
widely varying size of strings, if you use variable types you can save a lot of storage.  The less 
storage used, the less there is for a query to read, and the faster the query can perform.  So variable
types are usually preferable when read performance is a priority.

Attained form Safari BOoks

 
*****************************
8. Data Type Precedence
****************************
The data type with the lower precedence is converted to the data type with the higher precedence.
Int has higher precededence than VARCHAR.  
SELECT '1' + 1    - gives 2 instead of '11'

https://docs.microsoft.com/en-us/sql/t-sql/data-types/data-type-precedence-transact-sql?view=sql-server-2017

Data Type Precedence
http://msdn.microsoft.com/en-us/library/ms190309.aspx 
When using expressions that involve operands of different types, SQL Server usually
converts the one that has lower data type precedence to the one with the higher.  One 
operand is INT and the other is VARCHAR, you will find that INT precedes VARCHAR; hence
SQL converts the VARCHAR value of '1' to the INT Value of 1, and the result of the expression
is therefore 2 and not the string '11'. 
SELECT 1 + '1'
*/
SELECT 1 + '1'

****************************************
9. GUID - Globally Unique Identifier
****************************************
Advantages:
- A GUID is unique across tables, databases and servers
- Useful if your consolidating records from multiple SQL Servers into a single table

Disadvantages
- Size is 16 bytes, where as INT is only 4 bytes
- One of the largest datatypes in SQL Server
- An index built on a GUID is larger and slower
- Hard to read compared to INT

Summary: Only use a GUID when you really need a globally unique identifier.  In all other cases it is
better to use an INT data type.

Nonsequential GUIDs - You can generate nonsequential global unique identifiers to be stored in an attribute
of a UNIQUEIDENTIFIER type.  You can use the T-SQL Function NEWID to generate a new GUID, possible invoking
it with a default expression attached to the column. The GUIDs are guarenteed to be unique.

Sequential GUIDs - You can generate sequential GUIDs within the machine by using the T-SQL function
NEWSEQUENTIALID.

SELECT NEWID() creates a GUID that is guaranteed to be unique across tables, databases, and servers.


-- Not guaranteed to be unique
CREATE Table USACustomers
(
   ID int primary key identity,
   Name nvarchar(50)
)

-- GUID Guarenteed to be unique
Create TABLE USACustomers
(
  ID uniqueidentifer primary key default newid(),
  Name nvarchar(50)
)
GO
INSERT INTO USACustomer Values (default,'Tom')
INSERT INTO USACustomer Values (default,'Mike')

https://www.youtube.com/watch?v=SJJ8EmfO2Fg&index=136&list=PL08903FB7ACA1C2FB
*/
/*
