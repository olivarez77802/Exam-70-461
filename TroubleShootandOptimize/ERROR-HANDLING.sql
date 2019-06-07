/*
Implement Error Handling.
  Implement try/catch/throw; use set baed rather than row based logic; transaction management.

  1. Implement try/catch/throw
  2. Use set based rather than row based logic
  3. Transaction Management
  4. Unstructured and Structured Error Handling

*******************************
1. Implement try/catch/throw
*******************************
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



ERROR_LINE
https://docs.microsoft.com/en-us/sql/t-sql/functions/error-line-transact-sql?view=sql-server-2017
ERROR_PROCEDURE
https://docs.microsoft.com/en-us/sql/t-sql/functions/error-procedure-transact-sql?view=sql-server-2017

In addition to the error messages that SQL Server raises when it encounters an error, you can raise
your own errors by using two commands:
1. The older RAISERROR command
2. The SQL Server 2012 THROW command

1. RAISEERROR('Error Message',ErrorSeverity,ErrorState)
Create and return custom errors
Severity level = 16(indicates general errors that can be corrected by the user)
State=Number between 1 & 255. RAISERROR only generates errors with state from 1 thru 127.

Severity
  The error is returned to the caller if RAISERROR is run:
  - Outside the scope of any TRY block.
  - With the severity of 10 or lower in a TRY block.
  - With a severity of 20 OR higher that terminates the database connection.
State
  Is an integer from 0 thru 255. Negative values default to 1. Values larger than 255 should
  not be used.
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/raiserror-transact-sql?view=sql-server-2017

Execution of the CATCH block continues after the RAISERROR statement.

2. THROW() 

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
THROW with parameters terminates the batch, so commands following it are not executed.
A THROW without parameters can be used to re-raise the original error message and send it back to the client. 
This is by far the best method for reporting the error back to the caller. Now you get the original message 
sent back to the client, and under your control, though it does terminate the batch immediately.
You must take care that the THROW with or without parameters is the last statement you want executed in the CATCH block,
because it terminates the batch and does not execute any remaining commands in the CATCH block.

EXAM TIP
The statement before the THROW statement must be terminated by a semicolon (;). This reinforces the best 
practice to terminate all T-SQL statements with a semicolon.

*****************************
3. TRANSACTION Management
****************************
See information on SET XACT_ABORT ON - stored in SET_XREF.sql

When you handle errors in a CATCH block, the number of errors that can occur is quite large, so it is difficult to anticipate 
all of them. Also, the types of transactions or procedures involved might be specialized. Some T-SQL developers prefer to just
return the values of the error functions as in the previous SELECT statement. This can be most useful for utility stored 
procedures. In other contexts, some T-SQL developers use a stored procedure that can be called from the CATCH block and that will
provide a common response for certain commonly encountered errors.

What are the main advantages of using a TRY/CATCH block over the traditional trapping for @@ERROR?
The main advantage is that you have one place in your code that errors will be trapped, so you only need to put error handling in one place.

Can a TRY/CATCH block span batches?
No, you must have one set of TRY/CATCH blocks for each batch of code.


**********************************************
4. Unstructured and Structured Error Handling
*********************************************
There are essentially two error handling methods available: unstructured and structured. With unstructured error handling,
you must handle each error as it happens by accessing the @@ERROR function. With structured error handling, you can designate
a central location (the CATCH block) to handle errors.

With the Introduction of Try/Catch Blocks in SQL Server 2005, error handling in sql server,
is now similar to programming languages like C#, and Java.

Error Handling in SQL Server 2000 - @@Error
Error Handling in SQL Server 2005 and Later - Try...Catch

Note:  Sometimes, system functions that being with two at signs(@@), are called as
global variables.  They are not variables and do not hve the same behaviors as variables,
instead they are very similar to functions.
RAISERROR('Error Message', ErrorSeverity, Error State)
Create and return custom errors
Severity level = 16(indicates general errors that can be corrected by the user)
State=Number between 1 & 255. RAISERROR only generates errors with state from 1 thru 127.

T-SQL provides you with ways of detecting SQL Server errors and raising errors of your own. When 
SQL Server generates an error condition, the system function @@ERROR will have a positive integer
value indicating the error number.
@@ERROR returns a non-zero value, if there is an error, otherwise ZERO, indicating that the 
previous SQL statement encountered errors.

Note:@@ERROR is cleared and reset on each statement execution.  Check it immediately following
the statement being verified, or save it to a local variable that can be checked later.

Insert into tblProduct values(2, 'Mobile Phone', 1500, 100)
-- At this point @@ERROR will have a Non Zero value
Select * from tblProduct
-- At this point @@ERROR is reset to zero, because the Select statement successfully executed
-- You need to save @@ERROR to a local variable before Select statement E.G. Set @ERROR = @@ERROR
IF (@@ERROR <> 0)
   Print 'Error Occurred'
ELSE
   Print 'No Errors'

https://www.youtube.com/watch?v=xgpyqxKuta0&index=55&list=PL08903FB7ACA1C2FB

Microsoft TRY/ CATCH
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/try-catch-transact-sql?view=sql-server-2017
*/