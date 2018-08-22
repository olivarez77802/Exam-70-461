/*
ERROR HANDLING

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

*/