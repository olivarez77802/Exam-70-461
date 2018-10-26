/*
Parameters

Different Methods of using Parameters - Both Input and Ouptput Parameters

A. User Defined Function (Scalar Function)
B. Table-Valued Function - Inline Table  - Accepts Input Parameter and Returns TABLE
C. Table-Valued Function - Multi-Statement - Uses Table Variable - Accepts Input Parameter and Returns Table

1. Stored Procedures with Input Parameters
2. Stored Procedure with Output Parameters
3. Stored Procedure using Return Value (Can only have one return value)
4. Scalar Functions may or may not have parameters but always return a single value
5. Views - Cannot have parameters. 
6. Table and Column Names cannot be passed as parameters. Must use Dynamic SQL to make this happen.
7. Dynamic query using Input Parameters


Examples
*********************
User Defined Function
**********************
CREATE FUNCTION fnLongDate
(
  @FullDate AS DATETIME
)
RETURNS VARCHAR(MAX)
AS
BEGIN
  
  RETURN DATENAME(DW.@FullDate) + ' ' + DATENAME(D,@FullDate) + ' ' + DATENAME(M,@FullDate)

END

-- You can call above function with code below
SELECT FilmName,
       FilmReleaseDate,
	   [dbo].[fncLongDate])(FilmReleaseDate)
FROM tblFilm
https://www.youtube.com/watch?v=6BslHItOTjU&index=7&list=PLNIs-AWhQzcleQWADpUgriRxebMkMmi4H

****************************
Inline Table Valued Function
****************************
CREATE FUNCTION FilmsInYear
(
   @FilmYear INT
)
RETURNS TABLE
AS
RETURN
    SELECT FilmName,
	       FilmReleaseDate,
		   FilmRunTimeDate
	FROM tblFilm
	WHERE YEAR(FilmReleaseDate) = @FilmYear

--- Below is how you call Inline Table Value Function
--- Note must use dbo. prefix when calling Inline Table Value Function
SELECT FilmName,
       FilmReleaseDate,
	   FilmRunTimeMinutes
FROM dbo.FilmsInYear(2000)
https://www.youtube.com/watch?v=nCAEgNxC7nU&list=PLNIs-AWhQzcleQWADpUgriRxebMkMmi4H&index=10

*************************************
Multi-statement Table Valued Function
*************************************
CREATE FUNCTION PeopleInYear
(
  @BirthYear INT
)
RETURNS @t  TABLE
(
    PersonName VARCHAR(MAX),
	PersonDOB DATETIME,
	PersonJob VARCHAR (8)
)
AS BEGIN
   INSERT INTO @t
   SELECT
      DirectorName,
	  DirectorDOB,
	  'Director'
   FROM tblDirector
   WHERE YEAR(DirectorDOB) = @BirthYear
-- Just say RETURN in a MSVT Function
   RETURN
END

--- How you call above
SELECT *
FROM dbo.PeopleInYear(1945)
https://www.youtube.com/watch?v=nCAEgNxC7nU&list=PLNIs-AWhQzcleQWADpUgriRxebMkMmi4H&index=10


**************************************
Stored Procedure with Input Parameters
**************************************
EXEC spFilmList 150, 180, 'star'  - Can be done after the Stored Procedure is executed
EXEC spFileList @MinLength=150, @MaxLength=180, @Title='star'  - Alternate way of writing parameters
EXEC spFileList @MaxLength=180, @Title='star'  - Uses Default Value for MinLength since it is optional 

USE Movies
GO -- Begins new batch statments
CREATE PROC spFilmList
      (
	     @MinLength AS INT = 0,     -- Providing a Default Value will automatically make the parameter optional.  
		                            -- You can also set the Defualt values to 'NULL'.     
		 @MaxLength AS INT
		 @Title AS VARCHAR(MAX)     -- Defines Maxium length of characters
		 @FilmCount INT OUTPUT      -- Output parmameter
	  )
AS
BEGIN  --  Not Required but nice to use (Same with END Statement)
SELECT
  FilmName,
  FilmRunMinutes
FROM 
  tblFilm
WHERE FileRunMinutes >= @MinLength  AND
      FilmRunMinutes <= @MaxLength AND
	  FilmName LIKE '%' + @Title + '%'
ORDER BY FilmName ASC
END

****************************************
Stored Procedure with Output Parameters
****************************************
CREATE PROC spFilmInYear
  (
    @Year INT,
	@FilmList VARCHAR(MAX) OUTPUT,
	@FilmCount INT OUTPUT
  )
AS
BEGIN
 
  DECLARE @Films VARCHAR(MAX)
  SET @Films = ''
  SELECT @Films = @Films + FilmName + ','
  FROM tblFilm
  WHERE YEAR(FilmReleaseDate) = @Year
  ORDER BY FilmName ASC

  SET @FilmCount = @@ROWCOUNT
  SET @FilmList = @Films

END

----- Below is how you would call above stored procedure
DECLARE @Names VARCHAR(MAX)
DECLARE @Count INT

EXEC spFilmsInYear
     @Year = 2000
	 ,@FilmList = @Names OUTPUT
	 ,@FilmCount = @Count OUTPUT

SELECT @Count AS 'Number  of Films',
       @Names AS 'List of Films'

************************************
Stored Procedure using Return Value
************************************
CREATE PROC spFilmInYear
  (
    @Year INT,
  )
AS
BEGIN
 
  DECLARE @Films VARCHAR(MAX)
  SET @Films = ''
  SELECT @Films = @Films + FilmName + ','
  FROM tblFilm
  WHERE YEAR(FilmReleaseDate) = @Year
  ORDER BY FilmName ASC

  RETURN @@ROWCOUNT
END

--- How you call above stored procedure
DECLARE @Count INT
EXEC @Count = spFilmsInYear @Year = 2000

SELECT @Count AS 'Number of Films'

*******************************
Dynamic SQL passing Table Names
*******************************
CREATE PROC spDynamicTableName 
@tableName nvarchar(100)
AS
BEGIN
  DECLARE @SQL NVARCHAR (MAX)
-- QUOTENAME prevents SQL Injection Attacks
-- QUOTENAME wraps in square brackets treat [Countries; Drop Database SaledDB] to be treated as a table name
  SET @SQL = 'SELECT * FROM ' + QUOTENAME(@tableName)
  EXECUTE sp_executesql @sql
END

https://www.youtube.com/watch?v=RHHKG65WEoU&index=145&list=PL08903FB7ACA1C2FB

QUOTENAME Function - Prevents SQL Injection Attacks!
https://www.youtube.com/watch?v=LXplq-OWHdA&index=146&list=PL08903FB7ACA1C2FB

************************************
Dynamic Query using Input Parameters
************************************

- Syntax for SQL Server, Azure SQL Database, Azure SQL Data Warehouse, Parallel Data Warehouse  

sp_executesql [ @stmt = ] statement  
[   
  { , [ @params = ] N'@parameter_name data_type [ OUT | OUTPUT ][ ,...n ]' }   
     { , [ @param1 = ] 'value1' [ ,...n ] }  
]  
https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-executesql-transact-sql?view=sql-server-2017

DECLARE @SQL NVARCHAR(MAX)
DECLARE @GENDER NVARCHAR(10)
SET @GENDER = 'Female'
SET @sql = 'Select Count(*) from Employees where Gender=@GENDER'
Execute sp_exectutesql @sql, N'@GENDER nvarchar(10)', @GENDER
https://www.youtube.com/watch?v=na07ZODz-Gk&list=PL08903FB7ACA1C2FB&index=148

**************************************
Dynamic Query using Output Parameters
**************************************
DECLARE @SQL NVARCHAR(MAX)
DECLARE @GENDER NVARCHAR(10)
DECLARE @count int
SET @GENDER = 'Female'
SET @sql = 'Select @count =  Count(*) from Employees where Gender=@GENDER'
Execute sp_exectutesql @sql, N'@GENDER nvarchar(10)', @count int OUTPUT, @GENDER, @count OUTPUT
*/