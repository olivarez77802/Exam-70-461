/*
BULK Import and Export of Data

SQL Server supports exporting data in bulk (bulk data) from a SQL Server table and importing bulk data into a SQL Server table
or non partitioned view. 

The FIRSTROW Attribute is not intended to skip column headers.  Skipping headers is not supported by the BULK INSERT statement.
When skipping rows, the SQL Server looks only at the field terminators, and does not validate the data in the fields of skipped
rows.

1. Example of Importing CSV File
2. Example of Importing Piple Delimited File
3. Experience Importing into Server so-edw-sql2dev from my Local C: drive




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

Example2:
USE Development
BULK INSERT Fund
FROM 'C:\Users\olivarez77802\Documents\Jesse\Book2.csv'
WITH
(
  ROWTERMINATOR='\n',
  Fieldterminator=','
)

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

/*
*************************************************************************
3.  Experience Importing into Server so-edw-sql2dev from my Local C: drive
*************************************************************************
Got ERROR WHEN trying TO do A BULK Import
Msg 4861, Level 16, State 1, Line 20
Cannot bulk load because the file "C:\Users\Jesse-Olivarez\OneDrive - TAMUS\Documents\DOC2022\CUTOVER\DatabaseVersion2.csv" could not be opened. Operating system error code 3(The system cannot find the path specified.).

First step is to modify your excel file so that it only includes colummns that you need.  Any 
unnecessary columns should be deleted.

You have to put a single quote around anything that is alphanumeric, to do this see:
https://lenashore.com/2012/04/how-to-add-quotes-to-your-cells-in-excel-automatically/
Steps to put single quote:
0. Make Selection of Fields to be changed.
1. Click on Home Tab
2. Click on Format
3. Click on Format Cells
4. Click on Custom
5. Put Cursor on Type and Back space and paste \'@\'
6. Save file as CSV(Comma Delimited)(*.csv)
7. Rename file from .csv to .txt
6. Click Ok 


When you save a file from Excel into a CSV file it will give it a CSV extension.  If you want it to 
see the commas you have to rename it to '.txt'.   Once you have it in text format you can open it and 
put VALUES (value1, value2, value3, ...);   May be able to write a Powershell script to do this.

Tricks:
1. If you have a text file comma at the end of the file, you can easily elimante the comma by importing the 
file into excel and separating the fields by commma.  then resaving as a csv and rename again to .txt.
2. If you have to do special editing, Notepad's 'Find' and 'Replace' can be very useful.
3. If you have comma's in big numbers and want to remove comma, then Format table and use \'@\'

USE JesseTest
CREATE TABLE dbo.DatabaseVer2 (
  FileNbr VARCHAR (10),
  PredicateName VARCHAR (50),
  SQLTable VARCHAR (50),
  Comment VARCHAR (50),
  Counts VARCHAR (20),
 )

TRUNCATE TABLE dbo.DatabaseVer2
INSERT INTO dbo.DatabaseVer2 VALUES ('FileNo','Predict Name','SQL Table Name','FEB 2021 COUNTS')
INSERT INTO dbo.DatabaseVer2 VALUES (52,'BPP-BENEFIT-HISTORY','BPPBenefitHistory',627764)
INSERT INTO dbo.DatabaseVer2 VALUES (58,'BPP-EMPLOYEES','BPPEmployee',331376)



*/

