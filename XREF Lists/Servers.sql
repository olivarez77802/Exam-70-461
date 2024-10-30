/*
Servers
*/
Linked Servers IN SQL Server
https://www.c-sharpcorner.com/uploadfile/suthish_nair/linked-servers-in-sql-server-2008/

EXEC sys.sp_linkedservers
FINANCE IS SEA-FA-SQL
FINANCE_DEV IS SEA-FA-SQLDEV

SELECT * FROM sys.servers

Linked Servers allows you to connect to other database instances on the same server or on another machine or remote servers.

OPENQUERY
https://learn.microsoft.com/en-us/sql/t-sql/functions/openquery-transact-sql?view=sql-server-ver16

Syntax
OPENQUERY ( linked_server ,'query' ) 
linked_server
Is an identifier representing the name of the linked server.

' query '
Is the query string executed in the linked server. The maximum length of the string is 8 KB.

-- Won't work  - Needs Linked Server Name
-- SELECT * FROM OPENQUERY([SEA-FA-SQL], 'SELECT * FROM FAMISMOD.dbo.FRSTables');
-- Works same as SEA-FA-SQL 
SELECT * FROM OPENQUERY([FINANCE], 'SELECT * FROM FAMISMOD.dbo.FRSTables');
-- Looks at Prod.  Like it.. will be usefull!
SELECT * FROM OPENQUERY([SEA-FA-SQL], 'SELECT * FROM FAMISMOD.dbo.FRSTables');

-- Won't work - Needs Linked Server Name.
-- SELECT * FROM OPENQUERY([SEA-FA-SQLDEV], 'SELECT * FROM FAMISMOD.dbo.FRSTables');
-- Works same as SEA-FA-SQLDEV
SELECT * FROM OPENQUERY([FINANCE_DEV], 'SELECT * FROM FAMISMOD.dbo.FRSTables');