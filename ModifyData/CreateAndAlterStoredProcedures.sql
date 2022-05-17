/*
ModifyData/CreateAndAlterStoredProcedures (simple statements)
- Write a stored procedure to meet a given set of requirements; branching logic;
  create stored procedures and other programmmatic objects; techniques for developing
  stored procedures; different types of storeproc result; create stored procedure for
  data access layer; program stored procedures, triggers, functions with T-SQL.

1. Write a stored procedure to meet a given set of requirements
2. Create and Alter Functions

See also XREF/Table_or_Virtual_Tables (#TempTables)

Useful system stored procedures
sp_help procedure_name - View the information about the stored procedure, like parameter names,
their datatypes etc.  sp_help can be used with any database object, like tables, views, SP's,
triggers, etc.  Alternatively, you can also press ALT+F1, when the name of the object is 
highlighted.

sp_helptext procedure_name - View the Text of the stored procedure

sp_depends procedure_name - View the dependencies of the stored procedure.  The system
SP is very useful, especially if you want to check if there are any stored procedures
that are referencing a table that you are about to drop.  sp_depends can also be used
with ohter database objects like table, etc.
https://www.youtube.com/watch?v=bldBshxuhMk

Wise Owl Tutorial
https://www.youtube.com/watch?v=fjNsRV4zLdc&index=1&list=PLNIs-AWhQzcleQWADpUgriRxebMkMmi4H

Parameters
https://www.youtube.com/watch?v=Vs-atxMs4mw&index=2&list=PLNIs-AWhQzcleQWADpUgriRxebMkMmi4H

Database Engine Stored Procedures
https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/database-engine-stored-procedures-transact-sql?view=sql-server-2017

- Always include the EXEC command when calling a stored procedure.  That will avoid getting unexpected and confusing errors.  If 
  the statement is no longer the first statement in the batch, it wil still run.
- It is best practice to name the parameters when you call a stored procedures.   Although passing parameter values by position
  may be more compact, it is also more error prone.  If you pass parameters by name and the parameter order changes on the 
  stored procedure, your call of the stored procedure will still work.
- The NOCOUNT setting of ON or OFF stays with the stored procedure when it is created. Placing a SET NOCOUNT ON
  at the beginning of every stored procedure prevents the procedure from returning that message to the client.
  SET NOCOUNT OFF is the Default.  The message will show the count of the number of rows affected after query.  You usually
  want this ON when creating a stored procedure.
  In addition, SET NOCOUNT ON can improve the performance of frequently executed stored procedures because there 
  is less network communication required when the “rows(s) affected” message is not returned to the client.
- Whenever a RETURN is executed, execution of the stored procedure ends and control returns to the caller.
- Stored procedures can return more than one result set to the caller.
- If you create a temporary table in one stored procedure (Proc1), that temporary table is visible to all
  other stored procedures called from Proc1.   However, that temporary table is not visible to any other
  procedures that call Proc1.
- OUTPUT parameters are both input and OUTPUT.  OUTPUT parameters are always optional.

EXEC spFilmList 150, 180, 'star'  - Can be done after the Stored Procedure is executed
EXEC spFileList @MinLength=150, @MaxLength=180, @Title='star'  - Alternate way of writing parameters
EXEC spFileList @MaxLength=180, @Title='star'  - Uses Default Value for MinLength since it is optional 

USE Movies
GO -- Begins new batch statments
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
SELECT @FilmCount = Count(*)
FROM 
  tblFilm
WHERE FileRunMinutes >= @MinLength  AND
      FilmRunMinutes <= @MaxLength AND
	  FilmName LIKE '%' + @Title + '%'
END

Stored procedure with 'output' parameters
https://www.youtube.com/watch?v=bldBshxuhMk


------------------------
Tricky Stored Procedure
------------------------
DataSet:
Userid    UserName
1         User1
1         User2
2         User3
3         User4
4         User5
5         User6
6         User7
7         User8 
CREATE PROCEDURE GetUserCount
  @userID INT = NULL,                    /* Defaults to NULL if a value is not supplied */
  @userCount INT OUTPUT
AS
BEGIN
  IF @userID IS NULL                     /* Thinking IF STATEMENT ends after Return since there is no block */
     RETURN(-1)
 SET @userCount = (SELECT COUNT(*) Users WHERE UserID = @userID
END
/* Output Parameters are both Input and Output */
/* A value of 7 is supplied for @userid so the default of NULL is not used */
EXEC GetUserCount 7, @userCount=@result OUTPUT               

Returns a value of 1.

----------------
IF/ELSE
----------------
The IF/ELSE construct gives you the ability to conditionally execute code.  You enter an expression after the IF keyword,
and if the expression evaluates as true, the statement or block of statements after the IF statement will be executed.
You can use the optional ELSE to add a different statement or block of statements that will be executed if the expression
in the IF statement evalutes to FALSE.  Note! - There is not a 'THEN' Statement or an 'END-IF' the ';' serves as the END-IF in
the ELSE Block.

DECLARE @var1 AS INT, @var2 AS INT
SET @var1 = 1;
SET @var2 = 2;
IF @var1 = @var2
   PRINT 'The variables are equal';
ELSE
   PRINT 'The variables are not equal';
GO

When the IF or ELSE statements are used without BEGIN/END blocks, they each only deal with one statement.  Beware
of the below code.

IF @var1 = @var2
   PRINT 'The variables are equal';
ELSE
   PRINT 'The variables are not equal';
   PRINT '@var1 does not equal @var2';  --   This statement will always get executed.  The ';' ended the ELSE Block.

-----------
WHILE  -  Note! There is no END-WHILE.  Has the ability of BREAK and CONTINUE.
          Even though a BEGIN/END block is optional in a WHILE loop if you only have one statement, it is a best
		  practice to include it.  The BEGIN/END block helps you organize your code, makes it easier to read, and
		  makes it easier to modify in the future.  Any statement block in a WHILE loop with more than one statment
		  requires the BEGIN/END construct.
-----------
SET NOCOUNT ON;
Declare @count AS INT =1;
WHILE @count <= 10
BEGIN
   PRINT CAST(@Count AS NVARCHAR);
   SET @Count += 1;
END;
-- Example of BREAK and CONTINUE.  Notice that thare are no END-IF statements.
GO 
SET NOCOUNT ON
DECLARE @count AS INT = 1;
WHILE @count <= 100
BEGIN
  IF @count = 10
     BREAK;
  IF @count = 5
     BEGIN
	   SET @count += 2;
	   CONTINUE;
	 END
	 PRINT CAST(@Count AS NVARCHAR);
	 SET @count += 1;
END;


*/