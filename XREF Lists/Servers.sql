/*
Servers
*/
Linked Servers IN SQL Server
https://www.c-sharpcorner.com/uploadfile/suthish_nair/linked-servers-in-sql-server-2008/

EXEC sys.sp_linkedservers

SELECT * FROM sys.servers

Linked Servers allows you to connect to other database instances on the same server or on another machine or remote servers.

OPENQUERY
https://learn.microsoft.com/en-us/sql/t-sql/functions/openquery-transact-sql?view=sql-server-ver16

Syntax
OPENQUERY ( linked_server ,'query' ) 

SELECT * FROM OPENQUERY([SEA-FA-SQL], 'SELECT * FROM FAMISMOD.dbo.FRSTables');


