/*
- See Tables_or_Virtual_Tables.sql

1. @@System Functions
2. Table Variables
3. Temp Tables

***********************************************
1. @@System Functions
*********************************************** 

The names of some Transact-SQL system functions begin with two at signs (@@). Although in earlier versions of SQL Server,
the @@functions are referred to as global variables, they are not variables and do not have the same behaviors as variables. 
The @@functions are system functions, and their syntax usage follows the rules for functions.
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/variables-transact-sql?view=sql-server-2017

************************************************
2. Table Variables
************************************************
Transaction scope and lifetime
Just like any local variable we create with a DECLARE statement, a table variable is also scoped to the stored procedure, batch, or user-defined 
function. On the other hand, temporary tables are only available to the current connection to the database for the current user. They are dropped
when the connection is closed. Whenever there is a rollback of a transaction, it does not affect the table variables. As we can see in the output
of the query below – even after a rollback, we are still seeing data in table variable whereas data in temporary table is cleaned up.
https://logicalread.com/3-things-to-know-about-sql-server-table-variable-pd01/#.XYTdmihKiUk

Table Variable - Just like TempTables, a Table variable is also created in TempDB.  The scope
of a table variable is the batch, stored procedure, or statement block in which it is declared.
They can be passed as parameters between procedures.


*************************************************
3. Temp Tables
*************************************************
Temp Tables 
Lasts for a session
- If you create a temporary table in one stored procedure (Proc1), that temporary table is visible to all
  other stored procedures called from Proc1.   However, that temporary table is not visible to any other
  procedures that call Proc1.

Local Temp Tables are noted with a prefixed # symbol.

Temporary Tables are only available for the connection that created the table,
if you were to open another connection and try to query the temporary table the query
would fail.

Temporary tables, are very similar to permanent tables.  Permanent tables get created in 
the database you specify, and remain in the database permanently, until you delete(drop)
them.  On the other hand, temporary tables get created in the 
System Databases/tempbdb/Temporary Tables folder
and are automatically deleted, when they are no longer used. 

A Local temporary table is automatically dropped, when the connection that has created
it has been closed.

If the user want to excplicitly drop the temporary table, he can do so using DROP TABLE #Person

Another way to show tempory tables is to use the below select
SELECT name FROM tempdb..sysobjects 


GLOBAL Temporary Tables
To create a Global Temporary table, prefix the name of the table with 2 pound(##)
symbols.

Global temporary tables are visible to all the connections of the sql server, and are only
destroyes when the last connection referencing the table is closed.

Global temporary table names have to be unique unlike local temporary tables.



*/