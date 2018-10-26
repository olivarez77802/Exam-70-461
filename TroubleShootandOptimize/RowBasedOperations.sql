/*
Troubleshoot and Optimize
- Evaluate the use of row-based operations vs. set-based operations 
  When to use cursors; impact of scalar UDFs; combine multiple DML operations 

@@ROWCOUNT
https://docs.microsoft.com/en-us/sql/t-sql/functions/rowcount-transact-sql?view=sql-server-2017

Set based versus Procedural (Row based)
https://www.codeproject.com/Articles/34142/Understanding-Set-based-and-Procedural-approaches

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

*/