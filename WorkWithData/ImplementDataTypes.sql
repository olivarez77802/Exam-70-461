/*
Implement Data Types
  - Use appropriate data; understand the uses and limitations of each data type; impact of GUID(newid,
    newsequentialid) on database performance, when to use what data type for columns

1. Helpful Web Links
2. NVARCHAR Data Type
3. CAST and CONVERT Differences
4. Date and Time Styles
5. Variables
6. TRY_PARSE  - converting from string to date/time and number data types.
7. TRS_CONVERT 




********************
PRINT using CAST
********************
PRINT 'Number of films = ' + CAST(@NumFilms AS VARCHAR(MAX))
https://www.youtube.com/watch?v=NmYaOlcbfZM&index=3&list=PLNIs-AWhQzcleQWADpUgriRxebMkMmi4H

******************
Helpful Web Links
******************

W3Schools Data Types
https://www.w3schools.com/sql/sql_datatypes.asp

SQL Data Types
https://www.w3resource.com/sql/data-type.php

Data Types in SQL
https://www.youtube.com/watch?v=6E1tZg6qAvI&list=PL_RGaFnxSHWr_6xTfF2FrIw-NAOo3iWMy&index=6
https://www.youtube.com/watch?v=7fOdo8PhPaw&index=7&list=PL_RGaFnxSHWr_6xTfF2FrIw-NAOo3iWMy

*******************
NVARCHAR Data Type
*******************
NVARCHAR 
N- Unicode
VAR - Variable Length
CHAR - Character

****************************
CAST and CONVERT Differences
****************************
CAST and CONVERT
Syntax of CAST and CONVERT functions

CAST (expression AS data_type [(length)]
CONVERT (data_type [(length)], expression [, style])

Differences between CAST and Convert
1. Cast is based on ANSI standard and Convert is specific to SQL Server.  So if portablity is a 
concern and if you want to use the script with other database applications, use Cast().
2. Convert provides more flexibility than Cast.  For example, it's possible to control how you
want DateTime datatypes to be converted using sytles with convert function.
Note:  The general guideline is to use CAST(), unless you want to take advantage of the style
functionality in CONVERT().

Select Id, Name, DateOfBirth, CAST(DateOfBirth as nvarchar(11)) as ConvertedDOB from tblEmployees

Select Id, Name, DateOfBirth, CONVERT(nvarchar, DateOfBirth) as ConvertedDOB from tblEmployees
https://www.youtube.com/watch?v=8GHUfb5k-a8&index=28&list=PL08903FB7ACA1C2FB

********************
Date and Time Styles
********************

Date and Time Styles
https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-2017

--To get just the date part from DateTime
SELECT CONVERT(VARCHAR(10),GETDATE(), 101) -- Returns 09/02/2012

-- In SQL Server 2008, Date datatype is introduced, so you can also use
SELECT CAST(GETDATE() as DATE)   -- 2012-09-02
SELECT CONVERT(DATE, GETDATE())  -- 2012-09-02

*********
Variables
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

***************
TRY_PARSE(..)
***************
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

*************
TRY_CONVERT(..)
*************
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

*/