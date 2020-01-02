/*
Implement Error Handling.
  Implement try/catch/throw; use set baed rather than row based logic; transaction management.

  1. Implement try/catch/throw
  2. Use set based rather than row based logic
  3. Transaction Management
  4. Unstructured and Structured Error Handling
     @@ERROR and TRY/CATCH
  5. XACT_ABORT
  6. XACT_STATE

As a database develeoper, you have been asked to refactor a set of stored procedures.  You observed
the stored procedures have practically no error handling, and when they do have it, it is adhoc and 
unstructured.  None of the stored procedures are using transactions.  You need to put a plan to justify
your activity.
 
A. When should you recommend using explicit transactions ?
   Whenever more than one data change occurs in a stored procedure, and it is more important that the
   data changes be treated as a logical unit of work, you should add transaction logic to the stored procedure.
    
B. When should you recommend using a different isolation level ?
   You need to adapt the isolation levels to the requirements for transactional consistency.  You should
   investigate the current application and the database for instances of blocking and especially deadlocking.
   If you find deadlocks and establish they are due to mistakes in T-SQL coding, you can use various methods
   of lowering the isolation level in order to make deadlocks less likely.  However, be aware that some transactions
   may require higher levels of isolation.

C. What type of error handling should you recommend ?
   You should use TRY/CATCH blocks in every stored procedure where errors might occur and encourage your team
   to standardize on that usage.  By funneling all errors to the CATCH block, you can handle all errors in just
   one place in the code.

D. What plans should you include for refactoring dynamic SQL ?
   Check the stored procedure for the use of dynamic SQL, and where possible, replace calls to the EXECUTE command
   with the sp_executesql stored procedure.

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

Implement Error Handling in Nested Procedures
https://www.codemag.com/Article/0305111/Handling-SQL-Server-Errors-in-Nested-Procedures

Logging SQL Errors
https://stackoverflow.com/questions/1387527/logging-sql-errors


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

***************
5. XACT_ABORT
***************
SET XACT_ABORT has some advantages. It causes a transaction to roll back based on any error with severity > 10. 
However, XACT_ABORT has many limitations, such as the following:

You cannot trap for the error or capture the error number.

Any error with severity level > 10 causes the transaction to roll back.

None of the remaining code in the transaction is executed. Even the final PRINT statements of the transaction are not executed.

After the transaction is aborted, you can only infer what statements failed by inspecting the error message returned to the 
client by SQL Server.

As a result, XACT_ABORT does not provide you with error handling capability. You need TRY/CATCH.

XACT_ABORT behaves differently when used in a TRY block. Instead of terminating the transaction as it does in unstructured
error handling, XACT_ABORT transfers control to the CATCH block, and as expected, any error is fatal. The transaction is 
left in an uncommittable state (and XACT_STATE() returns a –1). Therefore, you cannot commit a transaction inside a CATCH 
block if XACT_ABORT is turned on; you must roll it back.

*************************
6. XACT_STATE
*************************

Determines if a transaction is capable of being committed.
Values:
1 - Transaction can be committed
0 - No Active Transaction
-1 - Has Active Transaction but an error has occurred.  Transaction cannot be committed.

https://docs.microsoft.com/en-us/sql/t-sql/functions/xact-state-transact-sql?view=sql-server-ver15


*/
--
-- Notice the 'After error' is not printed.  This is because of the XACT_ABORT ON.   Actually nothing after the INSERT is done due to XACT_ABORT ON
--
USE JesseTest
CREATE TABLE dbo.Production2 (
    Supplier_id INT IDENTITY(1,1) PRIMARY KEY,
	ProductName NVARCHAR(40) NOT NULL,
    CategoryID INT NOT NULL,
    UnitPrice MONEY NOT NULL,
    Discontinued BIT NOT NULL
);

USE JesseTest
GO
SET XACT_ABORT ON;
PRINT 'Before error';
SET IDENTITY_INSERT dbo.Production2 ON;
INSERT INTO dbo.Production2(Supplier_id, ProductName, CategoryId,
 UnitPrice, Discontinued)
    VALUES(1, N'Test1: Duplicate productid', 1, 18.00, 0);
SELECT XACT_STATE() AS STATE1
SET IDENTITY_INSERT dbo.Production2 OFF;
PRINT 'After error';
GO
-- Need TRY/CATCH Block for XACT_STATE() or @@TRANCOUNT to work
SELECT XACT_STATE() AS STATE2,
      @@TRANCOUNT AS TRANSCOUNT;
PRINT 'New batch';
SET XACT_ABORT OFF;
--
-- The first transaction will get duplicate key error, so it will jump to CATCH block even though
-- second transaction is good.  The transaction will get rolled back
-- Regardless if XACT_ABORT is turned ON or OFF.  XACT_ABORT behaves different when used in a TRY
-- Block.  If an error occurs control transfer to the CATCH block, you then must ROLLBACK the transaction. 
--
USE JesseTest;
GO
BEGIN TRY
BEGIN TRAN;
    SET IDENTITY_INSERT dbo.Production3 ON;
    INSERT INTO dbo.Production3(IdNum, ProductName, SupplierId,
     CategoryId, UnitPrice, Discontinued)
        VALUES(1, 'BMW', 2, 1, 18.00, 0);
    INSERT INTO dbo.Production3(IdNum, ProductName, SupplierId,
     CategoryId, UnitPrice, Discontinued)
        VALUES(3, 'Ford', 3, 1, 16.00, 0);
    SET IDENTITY_INSERT dbo.Production3 OFF;
COMMIT TRAN;
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 2627 -- Duplicate key violation
        BEGIN
            PRINT 'Primary Key violation';
        END
    ELSE IF ERROR_NUMBER() = 547 -- Constraint violations
        BEGIN
            PRINT 'Constraint violation';
        END
    ELSE
        BEGIN
            PRINT 'Unhandled error';
			PRINT ERROR_NUMBER();
			
        END;
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH
--
-- Use THROW statement without parameters to re-raise (re-throw) the original error message
-- and send it back to client.  This is the best method for reporting the error back to the caller
--
GO
BEGIN TRY
BEGIN TRAN;
    SET IDENTITY_INSERT dbo.Production3 ON;
	INSERT INTO dbo.Production3(IdNum, ProductName, SupplierId,
     CategoryId, UnitPrice, Discontinued)
        VALUES(1, 'BMW', 2, 1, 18.00, 0);
    INSERT INTO dbo.Production3(IdNum, ProductName, SupplierId,
     CategoryId, UnitPrice, Discontinued)
        VALUES(3, 'Ford', 3, 1, 16.00, 0);
     SET IDENTITY_INSERT dbo.Production3 OFF;
COMMIT TRAN;
END TRY
BEGIN CATCH
    SELECT XACT_STATE() as 'XACT_STATE', @@TRANCOUNT as '@@TRANCOUNT';
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
SELECT XACT_STATE() as 'XACT_STATE', @@TRANCOUNT as '@@TRANCOUNT';