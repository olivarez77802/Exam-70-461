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

**********************************************************************************************
DEFAULTS
**********************************************************************************************
--
-- SET ANSI_WARNINGS
--
When set to ON, if Null values appear in aggregates functions, such as SUM, AVG, MAX, MIN,
STDDEV, or COUNT, a warning is generated. When set to OFF, no warning is issued.

When set to ON, the divide by zero arithmetic overflow errors cause the statement to be rolled
back and an error message is generated.  When set to OFF, the divide by ZERO and arithmetic
overflows errors cause null values to be returned.
https://docs.microsoft.com/en-us/sql/t-sql/statements/set-ansi-warnings-transact-sql?view=sql-server-2017

------------------------- END ANSI_WARNINGS ---------------------------------------------------
--
-- ANSI_PADDING
--
Controls the way column stores values shorter than the defined size of the column, and the way
the column stores values that have trailing blanks in char, varchar, binary, and varbinary data.

'ON' SETTING - Trailing blanks in character values inserted into varchar columns are NOT trimmed.
'OFF' Setting ' - Trailing blanks in character values inserted into a varchar columnn are trimmed.

https://docs.microsoft.com/en-us/sql/t-sql/statements/set-ansi-padding-transact-sql?view=sql-server-2017

------------------------- END ANSI_PADDING -----------------------------------------------------
--
-- SET ANSI_NULLS ON
-- Specifies ISO compliant behavior of the Equals(=) and Not Equals(<>) comparison operators 
-- when they are used with null values	
--

-- Create table t1 and insert values.  
DROP TABLE #t1
CREATE TABLE #t1 (a INT NULL);  
INSERT INTO #t1 values (NULL),(0),(1);
DECLARE @TYPE NVARCHAR (20)
DECLARE @SQL1 NVARCHAR (MAX)
SET @SQL1 =
'SELECT * FROM #t1'  
-- EXECUTE sp_executesql @SQL1
 
DECLARE @SQL2 NVARCHAR (MAX)
SET @SQL2 = 
'     
DECLARE @varname int;   
SET @varname = NULL; 

SELECT a, @TYPE AS [SET TYPE]  
FROM #t1   
WHERE a = @varname;  

SELECT a, @TYPE AS  [SET TYPE]  
FROM #t1   
WHERE a <> @varname;  

SELECT a, @TYPE AS [SET TYPE]  
FROM #t1   
WHERE a IS NULL;
'  
-- End Dynamic

-- Print message and perform SELECT statements.  
--PRINT 'Testing default setting';
--SET @TYPE = 'Default'
--EXECUTE sp_executesql @sql2, N'@TYPE NVARCHAR(20)', @TYPE
   
---- SET ANSI_NULLS to ON and test.  
PRINT 'Testing ANSI_NULLS ON';  
SET ANSI_NULLS ON;  
SET @TYPE = 'ANSI_NULLS ON'
EXECUTE sp_executesql @sql2, N'@TYPE NVARCHAR(20)', @TYPE

-- SET ANSI_NULLS to OFF and test.  
PRINT 'Testing SET ANSI_NULLS OFF';  
SET ANSI_NULLS OFF;  
SET @TYPE = 'ANSI_NULLS OFF'
EXECUTE sp_executesql @sql2, N'@TYPE NVARCHAR(20)', @TYPE

-- Drop table t1.  
DROP TABLE #t1;  
GO
https://docs.microsoft.com/en-us/sql/t-sql/statements/set-ansi-nulls-transact-sql?view=sql-server-2017
---------------------------------- END ANSI_NULLS ------------------------------------------
--
-- SET ARITHABORT
--
Terminates a QUERY when an overflow or divide-by-zero error occurs during execution.  You should
always SET ARITHABORT ON.

https://docs.microsoft.com/en-us/sql/t-sql/statements/set-arithabort-transact-sql?view=sql-server-2017

---------------------------------- END ARITHABORT -----------------------------------------------------
--
-- QUOTED_IDENTIFIER
--

*/
