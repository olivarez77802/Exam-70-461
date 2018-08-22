/*
Variables and Data Types
Data Types
https://docs.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql?view=sql-server-2017

Converting Strings and Date/Time Data Types
https://docs.microsoft.com/en-us/sql/integration-services/data-flow/integration-services-data-types?view=sql-server-2017

Cast and Convert
https://www.youtube.com/watch?v=8GHUfb5k-a8&index=28&list=PL08903FB7ACA1C2FB




DECLARE @MyDate  DATETIME

SET @MyDate = '1980-01-01
SET @NumFilms = (SELECT COUNT(*) FROM tblFilm WHERE FilmReleaseDate >= @MyDate)
*
***********************
* Populating a Variable
***********************
*
DECLARE @ID INT
DECLARE @Name VARCHAR(MAX)
DECLARE @Date DATETIME

SELECT TOP 1 
  @ID = ActorID,
  @Name = ActorName,
  @Date = ActorDOB
FROM
   tblActor

SELECT @Name, @Date

*
************************************
* Accumulating a List in a Variable - Easy way to create a CSV File
************************************
*
DECLARE @NameList VARCHAR(MAX)
SET @NameList = ''
SELECT 
    @NameList = @NameList + ActorName + ', '
FROM
    tblActor
WHERE
    YEAR(ActorDOB) = 1970

PRINT @NameList

*/

-- Global Variables
SELECT @@SERVERNAME  -- Server Name
SELECT @@VERSION     -- SQL Version
SELECT @@ROWCOUNT