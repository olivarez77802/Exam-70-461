/*
Troubleshoot and Optimize
- Evaluate the use of row-based operations vs. set-based operations 
  When to use cursors; impact of scalar UDFs; combine multiple DML operations 

See also:
WorkwithData\QueryDatabyUsingSelect\7.Rank

1. @@ROWCOUNT
2. CURSOR
3. IF Logic
4. BEGIN.. END

-----------------
1. @@ROWCOUNT
-----------------
@@ROWCOUNT
https://docs.microsoft.com/en-us/sql/t-sql/functions/rowcount-transact-sql?view=sql-server-2017

Set based versus Procedural (Row based)
https://www.codeproject.com/Articles/34142/Understanding-Set-based-and-Procedural-approaches

-----------------
2. CURSOR
-----------------
SQL Server Cursor Analysis - When to use (or not use) cursors
https://www.mssqltips.com/sqlservertip/1599/sql-server-cursor-example/

Examples
GO  
UPDATE HumanResources.Employee   
SET JobTitle = N'Executive'  
WHERE NationalIDNumber = 123456789  
IF @@ROWCOUNT = 0  
PRINT 'Warning: No rows were updated';  
GO 
------------------
3.  IF Logic
------------------

https://www.w3schools.com/sql/func_mysql_if.asp

https://www.sqlshack.com/sql-if-statement-introduction-and-overview/

https://www.sqlservertutorial.net/sql-server-stored-procedures/sql-server-begin-end/

However, the BEGIN...END is required for the IF ELSE statements, WHILE statements, etc., where you need to wrap multiple statements.

-----------------
4. BEGIN.. END
-----------------
https://learn.microsoft.com/en-us/sql/t-sql/language-elements/begin-end-transact-sql?view=sql-server-ver16

*/