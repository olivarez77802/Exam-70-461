/*
Different ways of setting a variable or declaring variable

1.  Using SET in a CASE Statement
2.  Using SET with SELECT Statement
3.  Using SET with SELECT Statement
4.  Accumulating Variables in a Variable
5.  Loading Variable from Stored Procedure
6.  Variables in a Stored Procedure

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


******************************
USING SET in a CASE Statement
******************************

SE AdventureWorks2012;  
GO  
CREATE FUNCTION dbo.GetContactInformation(@BusinessEntityID int)  
    RETURNS @retContactInformation TABLE   
(  
    BusinessEntityID int NOT NULL,  
    FirstName nvarchar(50) NULL,  
    LastName nvarchar(50) NULL,  
    ContactType nvarchar(50) NULL,  
    PRIMARY KEY CLUSTERED (BusinessEntityID ASC)  
)   
AS   
-- Returns the first name, last name and contact type for the specified contact.  
BEGIN  
    DECLARE   
        @FirstName nvarchar(50),   
        @LastName nvarchar(50),   
        @ContactType nvarchar(50);  

    -- Get common contact information  
    SELECT   
        @BusinessEntityID = BusinessEntityID,   
        @FirstName = FirstName,   
        @LastName = LastName  
    FROM Person.Person   
    WHERE BusinessEntityID = @BusinessEntityID;  

    SET @ContactType =   
        CASE   
            -- Check for employee  
            WHEN EXISTS(SELECT * FROM HumanResources.Employee AS e   
                WHERE e.BusinessEntityID = @BusinessEntityID)   
                THEN 'Employee'  

            -- Check for vendor  
            WHEN EXISTS(SELECT * FROM Person.BusinessEntityContact AS bec  
                WHERE bec.BusinessEntityID = @BusinessEntityID)   
                THEN 'Vendor'  

            -- Check for store  
            WHEN EXISTS(SELECT * FROM Purchasing.Vendor AS v            
                WHERE v.BusinessEntityID = @BusinessEntityID)   
                THEN 'Store Contact'  

            -- Check for individual consumer  
            WHEN EXISTS(SELECT * FROM Sales.Customer AS c   
                WHERE c.PersonID = @BusinessEntityID)   
                THEN 'Consumer'  
        END;  

    -- Return the information to the caller  
    IF @BusinessEntityID IS NOT NULL   
    BEGIN  
        INSERT @retContactInformation  
        SELECT @BusinessEntityID, @FirstName, @LastName, @ContactType;  
    END;  

    RETURN;  
END;  
GO  

SELECT BusinessEntityID, FirstName, LastName, ContactType  
FROM dbo.GetContactInformation(2200);  
GO  
SELECT BusinessEntityID, FirstName, LastName, ContactType  
FROM dbo.GetContactInformation(5);  

https://docs.microsoft.com/en-us/sql/t-sql/language-elements/case-transact-sql?view=sql-server-2017

*******************************
USING SET with SELECT Statement
*******************************
DECLARE @MyDate DATETIME
DECLARE @NumFilms INT
SET @MyDate = '1980-01-01'
SET @NumFilms = (SELECT COUNT(*) FROM tblFilm WHERE FilmReleaseDate > = @MyDate)

*******************************
USING SET with SELECT STATEMENT
*******************************
DECLARE @ID INT
DECLARE @Name VARCHAR(MAX)
DECLARE @Date DATETIME

SELECT TOP 1
   @ID = ActorID,
   @Name = ActorName,
   @Date = ActorDB
FROM tblActor
WHERE ActordDOB >= '1970-01-01'
ORDER BY ActordDOB ASC

************************************
Accumulating Variables in a Variable
************************************
DECLARE @NameList VARCHAR(MAX)
SET @NameList = ''

SET @NameList = @NameList + ActorName + ', '
FROM  tblActor
WHERE YEAR(ActorDOB) = 1970

PRINT @NameList

*****************************************
5. Loading Variable from a Stored Procedure
*****************************************
DECLARE @Count INT
EXEC @Count = spFilmsInYear @Year = 2000
SELECT @Count
/*
******************************************
6. Loading Variables to a Stored Procedure
*******************************************
- It is best practice to name the parameters when you call a stored procedures.   Although passing parameter values by position
  may be more compact, it is also more error prone.  If you pass parameters by name and the parameter order changes on the 
  stored procedure, your call of the stored procedure will still work.

EXEC spFilmList 150, 180, 'star'  - Can be done after the Stored Procedure is executed
EXEC spFileList @MinLength=150, @MaxLength=180, @Title='star'  - Alternate way of writing parameters
EXEC spFileList @MaxLength=180, @Title='star'  - Uses Default Value for MinLength since it is optional

OUTPUT Keyword - Allows both input and OUTPUT.  OUTPUT Parameters are always optional parameters.

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


*/