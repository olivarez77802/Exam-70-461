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

Errors trapped by by a CATCH block are not returned to the calling appication.  If any
part of the error information must be returned to the application, the code in the CATCH
block must do so by using RAISERROR() Function.

In the scope of the CATCH block, there are several system functions, that are used to 
retrieve more information about the error that occurred.  These functions return
NULL if they are executed outside the scope of the CATCH block.  TRY/CATCH cannot be 
used in a user-defined functions.


https://www.youtube.com/watch?v=VLDirfx_OQg&index=56&list=PL08903FB7ACA1C2FB


*/