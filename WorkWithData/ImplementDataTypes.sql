/*
Implement Data Types
  - Use appropriate data; understand the uses and limitations of each data type; impact of GUID(newid,
    newsequentialid) on database performance, when to use what data type for columns

W3Schools Data Types
https://www.w3schools.com/sql/sql_datatypes.asp


Data Types in SQL
https://www.youtube.com/watch?v=6E1tZg6qAvI&list=PL_RGaFnxSHWr_6xTfF2FrIw-NAOo3iWMy&index=6
https://www.youtube.com/watch?v=7fOdo8PhPaw&index=7&list=PL_RGaFnxSHWr_6xTfF2FrIw-NAOo3iWMy


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

Date and Time Styles
https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-2017

--To get just the date part from DateTime
SELECT CONVERT(VARCHAR(10),GETDATE(), 101) -- Returns 09/02/2012

-- In SQL Server 2008, Date datatype is introduced, so you can also use
SELECT CAST(GETDATE() as DATE)   -- 2012-09-02
SELECT CONVERT(DATE, GETDATE())  -- 2012-09-02

-- Concatenate Id(INT) and Name(NVARCHAR)
Select Id, Name, Name + ' - ' + CAST(Id AS NVARCHAR) AS (Name-Id) FROM tblEmployees


*/