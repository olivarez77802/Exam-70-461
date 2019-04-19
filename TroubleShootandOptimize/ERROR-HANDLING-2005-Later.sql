/*
ERROR Handling 2005 and later

With the Introduction of Try/Catch blocks in SQL Server 2005, error handling in sql server
is now similar to programming languages such as C#, and Java.

Begin Try
  -- Any set of SQL Statemements
End Try
Begin Catch
  Rollback Transaction
  SELECT
    ERROR_NUMBER() AS ErrorNumber,
	ERROR_MESSAGE() AS ErrorMessage,
	ERROR_PROCEDURE() AS ErrorProcedure,
	ERROR_STATE() AS ErrorState,
	ERROR_SEVERITY() AS ErrorSeverity
End Catch

Any set of of SQL Statements that can possibly throw an exception are wrapped between
BEGIN TRY and END TRY Blocks.  If there is an exception in the TRY block, the control
immediately, jumps to the CATCH block.  If there is no exception, CATCH block will be
skipped, and the statements, after the CATCH block are executed.

Errors trapped by by a CATCH block are not returned to the calling application.  If any
part of the error information must be returned to the application, the code in the CATCH
block must do so by using RAISERROR() Function.

In the scope of the CATCH block, there are several system functions, that are used to 
retrieve more information about the error that occurred.  These functions return
NULL if they are executed outside the scope of the CATCH block.  TRY/CATCH cannot be 
used in a user-defined functions.

RAISEERROR('Error Message',ErrorSeverity,ErrorState)
Create and return custom errors
Severity level = 16(indicates general errors that can be corrected by the user)
State=Number between 1 & 255. RAISERROR only generates errors with state from 1 thru 127.

https://www.youtube.com/watch?v=VLDirfx_OQg&index=56&list=PL08903FB7ACA1C2FB

ERROR_LINE
https://docs.microsoft.com/en-us/sql/t-sql/functions/error-line-transact-sql?view=sql-server-2017
ERROR_PROCEDURE
https://docs.microsoft.com/en-us/sql/t-sql/functions/error-procedure-transact-sql?view=sql-server-2017

RAISERROR()


Severity
  The error is returned to the caller if RAISERROR is run:
  - Outside the scope of any TRY block.
  - With the severity of 10 or lower in a TRY block.
  - With a severity of 20 OR higher that terminates the database connection.
State
  Is an integer from 0 thru 255. Negative values default to 1. Values larger than 255 should
  not be used.
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/raiserror-transact-sql?view=sql-server-2017

--------
THROW() 
---------
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/throw-transact-sql?view=sql-server-2017

Syntax
error_number - must be greater than or equal to 50000.
message - string
state - between 0 and 255

THROW [ { error_number | @local_variable },  
        { message | @local_variable },  
        { state | @local_variable } ]   
[ ; ]  

THROW() - Raises an exception and transfers execution to a CATCH block of a TRY...CATCH block.
The statement before the THROW statement must be followed by the semicolon(;) statement terminator.

Note! - THROW; 
THROW without parameters has to be nested inside a CATCH block.  THROW with paramters does not 
have to be nested inside a CATCH block.
*/