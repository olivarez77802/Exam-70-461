/*
SET XREF

SET Statements change the current session handling of specific information
https://docs.microsoft.com/en-us/sql/t-sql/statements/set-statements-transact-sql?view=sql-server-2017

Problem 
With each session that is made to SQL Server the user can configure the options that are SET for that session
and therefore affect the outcome of how queries are executed and the underlying behavior of SQL Server. Some of these
options can be made via the GUI, while others need to be made by using the SET command.  

@@OPTIONS allows you to get the current values that are set for the current session.  When each session is made the 
default values are established for each connection and remain set unless they are overridden.
https://www.mssqltips.com/sqlservertip/1415/determining-set-options-for-a-current-session-in-sql-server/

Defaults - Run Code below to compare
- ANSI_WARNINGS
- ANSI_PADDING
- ANSI_NULLS
- ARITHABORT
- QUOTED_IDENTIFIER
- ANSI_NULL_DFLT_ON
- CONCAT_NULL_YIELDS_NULL

When dealing with indexes on computed columns and indexed views, four of the defaults must be set to ON.
- ANSI_NULLS
- ANSI_PADDING
- ANSI_WARNINGS
- QUOTED_IDENTIFIER

Take a look at what all of these set options do and how they can affect your session
DISABLE_DEF_CNST_CHK
IMPLICIT_TRANSACTIONS
CURSOR_CLOSE_ON_COMMIT
ANSI_WARNINGS
ANSI_PADDING
ANSI_NULLS
ARITHABORT
ARITHIGNORE
QUOTED_IDENTIFIER
NOCOUNT
ANSI_NULL_DFLT_ON
ANSI_NULL_DFLT_OFF
CONCAT_NULL_YIELDS_NULL
NUMERIC_ROUNDABORT
XACT_ABORT

**********************************************************************************************
DEFAULTS
**********************************************************************************************
-- SET ANSI_NULLS ON
-- Specifies ISO compliant behavior of the Equals(=) and Not Equals(<>) comparison operators when they are used
-- with null values

-- Create table t1 and insert values.  
CREATE TABLE #t1 (a INT NULL);  
INSERT INTO #t1 values (NULL),(0),(1);
SELECT * FROM #t1  
GO  
DECLARE @SQL NVARCHAR (MAX)
SET @SQL = 
'     
DECLARE @varname int;   
SET @varname = NULL; 

SELECT a  
FROM #t1   
WHERE a = @varname;  

SELECT a   
FROM #t1   
WHERE a <> @varname;  

SELECT a   
FROM #t1   
WHERE a IS NULL;
'  
-- End Dynamic
EXECUTE sp_executesql @sql


-- Print message and perform SELECT statements.  
PRINT 'Testing default setting';  
DECLARE @varname int;   
SET @varname = NULL;  

SELECT a  
FROM #t1   
WHERE a = @varname;  

SELECT a   
FROM #t1   
WHERE a <> @varname;  

SELECT a   
FROM #t1   
WHERE a IS NULL;  
GO  

-- SET ANSI_NULLS to ON and test.  
PRINT 'Testing ANSI_NULLS ON';  
SET ANSI_NULLS ON;  
GO  
DECLARE @varname int;  
SET @varname = NULL  

SELECT a   
FROM #t1   
WHERE a = @varname;  

SELECT a   
FROM #t1   
WHERE a <> @varname;  

SELECT a   
FROM #t1   
WHERE a IS NULL;  
GO  

-- SET ANSI_NULLS to OFF and test.  
PRINT 'Testing SET ANSI_NULLS OFF';  
SET ANSI_NULLS OFF;  
GO  
DECLARE @varname int;  
SET @varname = NULL;  
SELECT a   
FROM #t1   
WHERE a = @varname;  

SELECT a   
FROM #t1   
WHERE a <> @varname;  

SELECT a   
FROM #t1   
WHERE a IS NULL;  
GO  

-- Drop table t1.  
DROP TABLE #t1;  

*/
-- @@OPTIONS - Gets the settings for the current session
-- When run this command returns an integer that represents the bit values.
-- To make further sense of these values you can run the bitwise code below that
-- will show what SET options are turned on.
DECLARE @options INT
SELECT @options = @@OPTIONS

PRINT @options
IF ( (1 & @options) = 1 ) PRINT 'DISABLE_DEF_CNST_CHK' 
IF ( (2 & @options) = 2 ) PRINT 'IMPLICIT_TRANSACTIONS' 
IF ( (4 & @options) = 4 ) PRINT 'CURSOR_CLOSE_ON_COMMIT' 
IF ( (8 & @options) = 8 ) PRINT 'ANSI_WARNINGS' 
IF ( (16 & @options) = 16 ) PRINT 'ANSI_PADDING' 
IF ( (32 & @options) = 32 ) PRINT 'ANSI_NULLS' 
IF ( (64 & @options) = 64 ) PRINT 'ARITHABORT' 
IF ( (128 & @options) = 128 ) PRINT 'ARITHIGNORE'
IF ( (256 & @options) = 256 ) PRINT 'QUOTED_IDENTIFIER' 
IF ( (512 & @options) = 512 ) PRINT 'NOCOUNT' 
IF ( (1024 & @options) = 1024 ) PRINT 'ANSI_NULL_DFLT_ON' 
IF ( (2048 & @options) = 2048 ) PRINT 'ANSI_NULL_DFLT_OFF' 
IF ( (4096 & @options) = 4096 ) PRINT 'CONCAT_NULL_YIELDS_NULL' 
IF ( (8192 & @options) = 8192 ) PRINT 'NUMERIC_ROUNDABORT' 
IF ( (16384 & @options) = 16384 ) PRINT 'XACT_ABORT'