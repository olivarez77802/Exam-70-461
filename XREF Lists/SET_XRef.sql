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
1.  ANSI_WARNINGS
  When set to ON, if Null values appear in aggregates functions, such as SUM, AVG, MAX, MIN,
  STDDEV, or COUNT, a warning is generated. When set to OFF, no warning is issued.

2. ANSI_PADDING  
  SET @VAR = 'A   '
  'ON' SETTING - Trailing blanks in character values inserted into varchar columns are NOT trimmed @VAR= 'A   '.
  'OFF' Setting ' - Trailing blanks in character values inserted into a varchar columnn are trimmed @VAR= 'A'.

3. ANSI_NULLS
   Means only 'IS NULL' will recognize NULL.  Won't find NULLS with '=' or '<>'.  This is the ISO standard.

4. ARITHABORT
   Terminates a QUERY when an overflow or divide-by-zero error occurs during execution.

5. QUOTED_IDENTIFIER
   You delimit string literals by using single quotation marks,
   and use double quotation marks only to delimit T-SQL identifiers (in addition to square brackets).

6. ANSI_NULL_DFLT_ON
   Will allow NULL values to be inserted into a Table.

7. CONCAT_NULL_YIELDS_NULL
   When SET CONCAT_NULL_YIELDS_NULL is ON, concatenating a null value with a string yields a NULL result.
   For example, 
   SET CONCAT_NULL_YIELDS_NULL ON
   SELECT 'abc' + NULL
   yields NULL. When SET CONCAT_NULL_YIELDS_NULL is OFF, 
   concatenating a null value with a string yields the string itself (the null value is treated as an empty string). 
   For example, 
   SET CONCAT_NULL_YIELDS_NULL OFF
   SELECT 'abc' + NULL
   yields abc.

When dealing with indexes on computed columns and indexed views, four of the defaults must be set to ON.
- ANSI_NULLS
- ANSI_PADDING
- ANSI_WARNINGS
- QUOTED_IDENTIFIER

Additional SET Options to Review 
1. DISABLE_DEF_CNST_CHK

2. IMPLICIT_TRANSACTIONS
   SET IMPLICIT_TRANSACTIONS OFF is the default.  When OFF, each of the preceding T-SQL statements is bounded by an 
   unseen BEGIN TRANSACTION and unseen COMMIT TRANSACTION statement.  When OFF, we say the transaction mode is AUTOCOMMIT.

3. CURSOR_CLOSE_ON_COMMIT
   The default setting is OFF  This means that the server will not close cursors when you commit a transaction.

4. ARITHIGNORE
   SET ARITHIGNE OFF - Default - Will give message 'Overflow occured'.   Setting 'ON' will give message 'Divide by Zero occured'.

5. NOCOUNT
   SET NOCOUNT OFF is the Default.  The message will show the count of the number of rows affected after query.  You usually
   want this ON when creating a stored procedure.

6. NUMERIC_ROUNDABORT
   SET NUMERIC_ROUNDABORT OFF is the default.  
   When SET NUMERIC_ROUNDABORT is ON, an error is generated after a loss of precision occurs in an expression. If set to OFF, 
   losses of precision don't generate error messages. The result is rounded to the precision of the column or variable storing the result. 

7. XACT_ABORT  (See also Error Handling.sql)
  OFF is the default setting. When SET XACT_ABORT is OFF, in some cases only the Transact-SQL statement that raised the error is rolled back and the transaction
  continues processing.
  When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back.
  
  Depending upon the severity of the error, the entire transaction may be rolled back even when SET XACT_ABORT is OFF. OFF is the default setting in a T-SQL
  statement, while ON is the default setting in a trigger.

-- @@OPTIONS - Gets the settings for the current session
-- When run this command returns an integer that represents the bit values.
-- To make further sense of these values you can run the bitwise code below that
-- will show what SET options are turned on.
DECLARE @options INT
SELECT @options = @@OPTIONS

PRINT @options
IF ( (1 & @options) = 1 ) PRINT 'DISABLE_DEF_CNST_CHK' 
IF ( (2 & @options) = 2 ) PRINT 'IMPLICIT_TRANSACTIONS' 
IF ( (2 & @options) = 0) PRINT 'IMPLICIT_TRANSACTIONS OFF' 
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

ANSI Padding is used when Storing values to a TABLE.
https://sqlstudies.com/2017/06/15/turning-ansi_padding-off-and-why-you-shouldnt/https://sqlstudies.com/2017/06/15/turning-ansi_padding-off-and-why-you-shouldnt/

SET ANSI_PADDING ON
DECLARE @T1 VARCHAR(10)
SET @T1 = 'AAA  '
SELECT DATALENGTH(@T1)
-- SET ANSI_PADDING ON is the default but even if you set it to off the length would be the same.
-- ANSI Padding is used more for when you STORE values to a table.  Not seeig differences when you
-- Declare variableSETs.

------------------------- END ANSI_PADDING -----------------------------------------------------
--
-- SET ANSI_NULLS ON
-- Specifies ISO compliant behavior of the Equals(=) and Not Equals(<>) comparison operators 
-- when they are used with null values	
--

-- Create table t1 and insert values.  
IF OBJECT_ID('tempdb..#t1') IS NOT NULL
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
The following example shows that the SET QUOTED_IDENTIFIER setting must be ON, and the keywords in table names 
must be in double quotation marks to create and use objects that have reserved keyword names.

https://docs.microsoft.com/en-us/sql/t-sql/statements/set-quoted-identifier-transact-sql?view=sql-server-2017

You should leave QUOTED_IDENTIFIER set to ON because that is the ANSI standard and the SQL Server default.
When SET QUOTED_IDENTIFIER is ON, which is the default, you delimit string literals by using single quotation marks,
and use double quotation marks only to delimit T-SQL identifiers (in addition to square brackets).

If you set QUOTED_IDENTIFIER to OFF, then along with single quotation marks, you can also use double quotation
marks to delimit strings. But then you must use square brackets to delimit T-SQL identifiers.

SET QUOTED_IDENTIFIER OFF  
GO  
-- An attempt to create a table with a reserved keyword as a name  
-- should fail.  
CREATE TABLE "select" ("identity" INT IDENTITY NOT NULL, "order" INT NOT NULL);  
GO  

SET QUOTED_IDENTIFIER ON;  
GO  

-- Will succeed.  
CREATE TABLE "select" ("identity" INT IDENTITY NOT NULL, "order" INT NOT NULL);  
GO  

SELECT "identity","order"   
FROM "select"  
ORDER BY "order";  
GO  

DROP TABLE "SELECT";  
GO  

SET QUOTED_IDENTIFIER OFF;  
GO  
------------------------------ END QUOTED_IDENTIFIER --------------------------------------------------
--
-- ANSI_NULL_DFLT_ON
--

https://docs.microsoft.com/en-us/sql/t-sql/statements/set-ansi-null-dflt-on-transact-sql?view=sql-server-2017

USE AdventureWorks2012;  
GO  

-- The code from this point on demonstrates that SET ANSI_NULL_DFLT_ON  
-- has an effect when the 'ANSI null default' for the database is false.  
-- Set the 'ANSI null default' database option to false by executing  
-- ALTER DATABASE.  
ALTER DATABASE AdventureWorks2012 SET ANSI_NULL_DEFAULT OFF;  
GO  
-- Create table t1.  
CREATE TABLE t1 (a TINYINT) ;  
GO   
-- NULL INSERT should fail.  
INSERT INTO t1 (a) VALUES (NULL);  
GO  

-- SET ANSI_NULL_DFLT_ON to ON and create table t2.  
SET ANSI_NULL_DFLT_ON ON;  
GO  
CREATE TABLE t2 (a TINYINT);  
GO   
-- NULL insert should succeed.  
INSERT INTO t2 (a) VALUES (NULL);  
GO  
---------------------------- END ANSI_NULL_DFLT_ON ----------------------------------------------------------------
--
-- CONCAT_NULL_YIELDS_NULL
--
Controls whether concatenation results are treated as null or empty string values.

https://docs.microsoft.com/en-us/sql/t-sql/statements/set-concat-null-yields-null-transact-sql?view=sql-server-2017

When SET CONCAT_NULL_YIELDS_NULL is ON, concatenating a null value with a string yields a NULL result.
For example, SELECT 'abc' + NULL yields NULL. When SET CONCAT_NULL_YIELDS_NULL is OFF, 
concatenating a null value with a string yields the string itself (the null value is treated as an empty string). 
For example, SELECT 'abc' + NULL yields abc.
*/
PRINT 'Setting CONCAT_NULL_YIELDS_NULL ON';  
GO  
-- SET CONCAT_NULL_YIELDS_NULL ON and testing.  
SET CONCAT_NULL_YIELDS_NULL ON;  
GO  
SELECT 'abc' + NULL ;  
GO  

-- SET CONCAT_NULL_YIELDS_NULL OFF and testing.  
SET CONCAT_NULL_YIELDS_NULL OFF;  
GO  
SELECT 'abc' + NULL;   
GO  
-------------------------- END CONCAT_NULL_YIELDS_NULL ---------------------------------------------------------
-- END DEFAULTS
----------------------------------------------------------------------------------------------------------------
--
-- SET NOCOUNT ON
--
/*
You can embed the setting of NOCOUNT to ON inside the stored procedure to remove messages like (3 row(s) affected)
being returned every time the procedure executes.   Placing a 'SET NOCOUNT ON' at the beginning of every stored 
procedure prevents the procedure from returning that message to the client.  In addition, SET NOCOUNT ON can improve
the performance of frequently executed stored procedures because there is less network communications required when
the 'rows affected' message is not returned to the client.
*/
/*
****************************************************************************************************************
--  XACT_ABORT
****************************************************************************************************************
See also:
Error-Handling.sql

XACT_ABORT - Controls Atomicity so it the A in A.C.I.D
IF XACT_ABORT is OFF, which IS the DEFAULT, you can add code to decide whether to roll back the transaction or 
commit it.

XACT_ABORT works with all types of code and affects the entire batch. You can make an entire batch fail if any
error occurs by beginning it with SET XACT_ABORT ON. You set XACT_ABORT per session. After it is set to ON, all
remaining transactions in that setting are subject to it until it is set to OFF.



The THROW statement honors SET XACT_ABORT.
RAISERROR does not. New applications should use THROW instead of RAISERROR.

XACT_ABORT behaves differently when used in a TRY block. Instead of terminating the transaction as it does in unstructured error handling, 
XACT_ABORT transfers control to the CATCH block, and as expected, any error is fatal. The transaction is left in an uncommittable state 
(and XACT_STATE() returns a –1). Therefore, you cannot commit a transaction inside a CATCH block if XACT_ABORT is turned on; you must
roll it back.

When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back.
When SET XACT_ABORT is OFF, in some cases only the Transact-SQL statement that raised the error is rolled back and the transaction continues processing.
Depending upon the severity of the error, the entire transaction may be rolled back even when SET XACT_ABORT is OFF. OFF is the default setting in a T-SQL
statement, while ON is the default setting in a trigger.

https://docs.microsoft.com/en-us/sql/t-sql/statements/set-xact-abort-transact-sql?view=sql-server-2017 
*/

SET XACT_ABORT OFF;  
GO  
BEGIN TRANSACTION;  
INSERT INTO t2 VALUES (1);  
INSERT INTO t2 VALUES (2); -- Foreign key error.  
INSERT INTO t2 VALUES (3);  
COMMIT TRANSACTION;  
GO  
SET XACT_ABORT ON;  
GO  
BEGIN TRANSACTION;  
INSERT INTO t2 VALUES (4);  
INSERT INTO t2 VALUES (5); -- Foreign key error.  
INSERT INTO t2 VALUES (6);  
COMMIT TRANSACTION;  
GO  
-- SELECT shows only keys 1 and 3 added.   
-- Key 2 insert failed and was rolled back, but  
-- XACT_ABORT was OFF and rest of transaction  
-- succeeded.  
-- Key 5 insert error with XACT_ABORT ON caused  
-- all of the second transaction to roll back.  
SELECT *  
    FROM t2;  
GO  
--------------------------------- END XACT_ABORT ------------------------------------------
/*
***************************************
-- IMPLICIT TRANSACTION MODE
***************************************

See also ManageTranactions/3.Transaction Modes

In the implicit transaction mode, when you issue one or more DML or DDL statements, or a 
SELECT statement, SQL starts a transaction, increments @@TRANCOUNT, but does not automatically
commit or roll back the statement.  You must issue a COMMIT or ROLLBACK interactively to finish
the transaction, even if all you issued was a SELECT statement.

Implicit transaction mode is not the SQL default.  You enter that mode by entering command
SET IMPLICIT_TRANSACTION ON

*************************
ARITHIGNORE
*************************

Default is SET ARITHIGNORE OFF.
Controls whether error messages are returned from overflow or divide-by-zero errors during a query.

SET ARITHABORT OFF;  
SET ANSI_WARNINGS OFF  
GO  
  
PRINT 'Setting ARITHIGNORE ON';  
GO  
-- SET ARITHIGNORE ON and testing.  
SET ARITHIGNORE ON;  
GO  
SELECT 1 / 0 AS DivideByZero;  
GO  
SELECT CAST(256 AS TINYINT) AS Overflow;  
GO  
  
PRINT 'Setting ARITHIGNORE OFF';  
GO  
-- SET ARITHIGNORE OFF and testing.  
SET ARITHIGNORE OFF;  
GO  
SELECT 1 / 0 AS DivideByZero;  
GO  
SELECT CAST(256 AS TINYINT) AS Overflow;  

https://docs.microsoft.com/en-us/sql/t-sql/statements/set-arithignore-transact-sql?view=sql-server-ver15

*****************
NOCOUNT
*****************
Stops the message that shows the count of the number of rows affected by a Transact-SQL statement or stored procedure from being returned as part of the result set.

SET NOCOUNT OFF - Is the default.  The count is returned.
SET NOCOUNT ON - The count is not returned.
https://docs.microsoft.com/en-us/sql/t-sql/statements/set-nocount-transact-sql?view=sql-server-ver15

********************
NUMERIC_ROUNDABORT
********************
SET NUMERIC_ROUNDABORT OFF is the default.  

When SET NUMERIC_ROUNDABORT is ON, an error is generated after a loss of precision occurs in an expression. If set to OFF, 
losses of precision don't generate error messages. The result is rounded to the precision of the column or variable storing the result. 

https://docs.microsoft.com/en-us/sql/t-sql/statements/set-numeric-roundabort-transact-sql?view=sql-server-ver15

*/