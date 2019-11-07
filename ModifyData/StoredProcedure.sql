/*
Stored Procedure

See also XREF/Table_or_Virtual_Tables (#TempTables)

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