/*
Different ways of setting a variable or declaring variable

1.  Using SET in a CASE Statement  ( See also QueryDatabyUsingSelect; ModifyingData/CombineDatasets)
2.  Using SET with SELECT Statement
3.  Using SET with SELECT Statement
4.  Accumulating Variables in a Variable
5.  Loading Variable from Stored Procedure
6.  Variables in a Stored Procedure
7.  Table Variable (see also Tables_or_Virtual_Tables)

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
-----------
Example 2 
-----------
SET STATISTICS PROFILE ON
 DECLARE @p1_1 VARCHAR(2) = '02',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
         @p2_1  VARCHAR(4) = '2021',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
         @p3_1  VARCHAR(1)= '+',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
         @p4_1  VARCHAR(4) = '0421',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
         @p5_1  VARCHAR(6) = '      ',                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
         @p6_1  VARCHAR(6) = '999999' 
 SELECT TOP(100) WaAcctAnalysisCd, WaCampusCd, WaCsrsAcct, WaCsrsBank, WaCsrsChrgCd, WaFicaAcct, WaFicaBank, WaFicaChrgCd, WaFirAcct, WaFirBank, WaFirChrgCd, WaFiscalYy, WaFromAcct, WaGipAcct, WaGipBank, WaGipChrgCd, WaLeavAcct, WaLeavBank,
 WaLeavChrgCd, WaLngAcct, WaLngBank, WaLngChrgCd, WaOrpBaseAcct, WaOrpBaseBank, WaOrpBaseChrgCd, WaOrpSsupAcct, WaOrpSsupBank, WaOrpSsupChrgCd, WaOrpSuplAcct, WaOrpSuplBank, WaOrpSuplChrgCd, WaTrsAcct, WaTrsBank, WaTrsCareAcct, WaTrsCareBank,
 WaTrsCareChrgCd, WaTrsChrgCd, WaTrsSurcAcct, WaTrsSurcBank, WaTrsSurcChrgCd, WaTrs90Acct, WaTrs90Bank, WaTrs90ChrgCd, WaUciAcct, WaUciBank, WaUciChrgCd, WaWciAcct, WaWciBank, WaWciChrgCd, FBI_WaCcFyAaAcct, WaThruAcct, main.ISN                                                                                                                                                                                                                               
FROM PAYAcctAnalysis main                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
WHERE FBI_WaCcFyAaAcct >= CAST(@p1_1 AS CHAR(2)) + RIGHT('0000' + CAST(ABS(@p2_1) AS VARCHAR(4)),4) + CAST(@p3_1 AS VARCHAR(1)) + CAST(@p4_1 AS CHAR(4)) + CAST(@p5_1 AS CHAR(6)) + CAST(@p6_1 AS CHAR(6))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
ORDER BY FBI_WaCcFyAaAcct, ISN                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
SET STATISTICS PROFILE OFF
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

USE AdventureWorks2012;  
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

USE TRS
DECLARE @cnt INT;
EXEC dbo.spGetHeaderRPForWorkstationAsOf 388, 'B', @recordCount = @cnt OUTPUT
SELECT @cnt   
http://www.sqlservertutorial.net/sql-server-stored-procedures/stored-procedure-output-parameters/

- It is best practice to name the parameters when you call a stored procedures.   Although passing parameter values by position
  may be more compact, it is also more error prone.  If you pass parameters by name and the parameter order changes on the 
  stored procedure, your call of the stored procedure will still work.

EXEC spFilmList 150, 180, 'star'  - Can be done after the Stored Procedure is executed
EXEC spFilmList @MinLength=150, @MaxLength=180, @Title='star'  - Alternate way of writing parameters
EXEC spFilmList @MaxLength=180, @Title='star'  - Uses Default Value for MinLength since it is optional

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

***************************
7. Loading a Table Variable  - See also Tables_or_Virtual Tables
***************************
Stored procedure spGetPayrollDaysHoursWorkedChangesAsOf  uses a Table Variable.

DECLARE @EmployeeJobCategory AS EmployeeJobCategory
INSERT INTO @EmployeeJobCategory
SELECT
    WorkerDimKey,
	JobCategory,
	Workstation
FROM #Reported

*/