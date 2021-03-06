
/*
OBJECT_ID Xref

-- Testing for the existence of a Stored Procedure (N'P').  You can check for the existence of a data object
   in many ways. Example you can check the metadata in sys.objects.  However, using the OBJECT_ID() is the
   least verbose.

https://docs.microsoft.com/en-us/sql/t-sql/functions/object-id-transact-sql?view=sql-server-2017

Check Object_id for temp table 
https://stackoverflow.com/questions/581427/how-to-check-if-a-temporary-table-is-existing-in-database
IF OBJECT_ID('tempdb..#t1') IS NOT NULL
   DROP TABLE #t1

IF OBJECT_ID (N'Sales.GetCustomerOrders', N'P') IS NOT NULL
   DROP PROC Sales.GetCustomerOrders;
GO
-- Check existence of Triggers - (N'TR')
IF OBJECT_ID(N'Sales.tr_SalesOrderDetailsDML', N'TR') IS NOT NULL
   DROP TRIGGER Sales.tr_SalesOrderDetailsDML;
GO;
-- 
-- Function abbreviations
-- FN - Scalar Function
-- IF - Inline Table Valued Function
-- TF - Table Valued Function
-- U  - Table  N'U'
-- P  - Stored Procedure. N'P'
-- V  - View. N'V'
--
IF OBJECT_ID(N'Sales.fn_extension',N'FN') IS NOT NULL
   DROP FUNCTION Sales.fn_extension  
IF OBJECT_ID(N'Sales.fn_FilteredExtension', N'IF') IS NOT NULL
   DROP FUNCTION Sales.fn_FilteredExtension 
IF OBJECT_ID(N'Sales.fn_FilteredExtension2', N'TF') IS NOT NULL
   DROP FUNCTION Sales.fn_FilteredExtension2;
IF OBJECT_ID(N'Sales.OrderTotalsByYear', N'V') IS NOT NULL
   DROP VIEW Sales.OrderTotalsByYear;

*/

SELECT OBJECT_ID FROM sys.triggers

SELECT @@SERVERNAME
SELECT DB_NAME() AS [Current Database];
-- Loop to print out nonsystem databases
DECLARE @databasename AS NVARCHAR(128);
SET @databasename = (SELECT MIN(name) FROM sys.databases 
                     WHERE name NOT IN ('master','model','msdb','tempdb'));
WHILE @databasename IS NOT NULL
BEGIN
 PRINT @databasename;
 SET @databasename = (SELECT MIN(name) FROM sys.databases WHERE name NOT IN
    ('master','model','msdb','tempdb') AND name > @databasename);
END
GO

