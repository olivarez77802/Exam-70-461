/*
BULK Import and Export of Data

SQL Server supports exporting data in bulk (bulk data) from a SQL Server table and importing bulk data into a SQL Server table
or non partitioned view. 

The FIRSTROW Attribute is not intended to skip column headers.  Skipping headers is not supported by the BULK INSERT statement.
When skipping rows, the SQL Server looks only at the field terminators, and does not validate the data in the fields of skipped
rows.

1. Example of Importing CSV File
2. Example of Importing Piple Delimited File




https://docs.microsoft.com/en-us/sql/relational-databases/import-export/bulk-import-and-export-of-data-sql-server?view=sql-server-2017


*****************************
Example of Importing CSV File
*****************************
BULK INSERT Employees
FROM 'D:\SQL\DATA\EMPLOYEES.CSV'
WITH
(
  ROWTERMINATOR='\n',
  Fieldterminator=','
)
https://www.youtube.com/watch?v=cCcIwKLUCEw


****************************************
Example of Importing pipe delimited file
****************************************
BULK INSERT AdventureWorks2012.Sales.SalesOrderDetail  
   FROM 'f:\orders\lineitem.tbl'  
   WITH   
      (  
         FIELDTERMINATOR =' |',  
         ROWTERMINATOR =' |\n'  
      );
 https://docs.microsoft.com/en-us/sql/t-sql/statements/bulk-insert-transact-sql?view=sql-server-2017
  
******************************************

*/
USE TRS_BPP;
CREATE TABLE dbo.MyFirstImport (
   Month  VARCHAR (02),
   Year   VARCHAR (04),
   WorkStation VARCHAR (05),
   TRSJOBCategory VARCHAR (05)
   );
GO

BULK INSERT dbo.MyFirstImport
FROM 'C:\Users\jesse-olivarez\Downloads\BP8508N_DETAIL_A_BULK_TEST.csv'

