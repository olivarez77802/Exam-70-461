/*
Indexes 
https://www.youtube.com/watch?v=i_FwqzYMUvk

See also:
CreateDatabaseObjects/CreateAndModifyConstraints.sql
TroubleShootandOptimize/OptimizeQueries.sql


Clustered and NonClustered Indexes
https://www.youtube.com/watch?v=NGslt99VOCw
- Different types of indexes in sql server
- What are clustered indexes
- What are NonClustered indexes
- Differences between clustered and non clustered indexes

1. Creating an Index
2. Clustered Index
3. NonClustered Index

Difference between Clustered and NonClustered Index
- Only one clustered index per table, where as you can have more than one NonClustered Index
- Clustered Index is faster than a NonClustered Index, because the NonClustered Index has to refer
  back to the table, if the selected column is not present in the index.
- Clustered index determines the storage order of rows in the table, and hence doesn't 
  require additional disk space, but where as a NonClustered Index is stored separately
  from the table, additonal storage space is required.

---------------------------------
1.  Creating an Index (Same as NonClustered Index)
--------------------------------

https://www.mssqltips.com/sqlservertutorial/9133/sql-server-non-clustered-indexes/
Creating a non-clustered index is basically the same as creating clustered index, but instead of specifying
the CLUSTERED clause we specify NONCLUSTERED.   We can also omit this clause altogether as a non-clustered
is the default when creating an index. 

Creating an index
Example:
  CREATE INDEX IX_tblEmployee_Salary
  ON tblEmployee (SALARY ASC)

Once you have created the index you should be able to find it under the table name/ index folder.

To find an index in a table, you can use command
sp_Helpindex tblEmployee   

To drop an index use:
drop index tblEmployee.IX_tblEmployee_Salary

--------------------------------------
2. Clustered Index
--------------------------------------

When should clustered indexes be created
As a general rule of thumb is it's best to create a clustered index on a table when the same columns
are heavily used in the WHERE clause portion of a query.  Queries that perform a lot of range scans with
the indexed columns in the WHERE clause can also benefit greatly from having a clustered index on these columns. 
In both cases since the data is output in basically the same order that it is queried we end up using less 
resources to execute the query.  In all cases we will use less disk IO and in some cases
(depending on the ORDER BY clause) we can save ourselves memory and CPU by not having to perform a sort since
data is already ordered.  The following example shows how no extra lookups are required to fetch the actual
data and also that no sort is required as the data is already in the correct order.
https://www.mssqltips.com/sqlservertutorial/9132/sql-server-clustered-indexes/

Clustered Index
- Determines the physical order of data in a table.  For this reason, a table
  can have only one clustered index.

CREATE TABLE [tblEmployee]
(
 [Id] int Primary Key,
 [Name] nvarchar(50),
 [Salary] int,
 [Gender] nvarchar(10),
 [City] nvarchar(50)
)

- Below command will show you the Clustered index and the column defining
- the clustered index.
Exectute sp_helpindex tblEmployee

A Clustered Index is analagous to a telephone directory, where the data is 
arranged by the last name.  We know that a table can have only one clustered
index.  However, the index can contain multiple columns (a composite index),
list the way a telephone directory is organized by last name and first name.

Create a composit clustered index on the Gender and Salary Columns
Example:
Create Clustered Index IX_tblEmployee_Gender_Salary 
ON tblEmployee(Gender DESC, Salary ASC)

Note! - If you try to run the above command, you will get the error.  "You already
have a Clustered Index on tblEmployee. Drop the existing clustered index".

You must execute the command to drop the Clustered Index.  You need to find the 
name of the index first.
Example:
Drop Index tblEmployee.PK_tblEmploye_3214EC..

But Hold On, if you try to drop, you will still get an error.  It will say
"You are not allowed to drop index because it is being used for PRIMARY KEY
enforcement".

To Safely delete the Clustered Index you must go to the Object Explorer and
go to the Index folder, right click on the Index and select Delete.  This method
should delete the Clustered Index.  

You may now create the Composite Clustered Index
Example:
Create Clustered Index IX_tblEmployee_Gender_Salary 
ON tblEmployee(Gender DESC, Salary ASC)

---------------------------------
3. NonClustered Index
---------------------------------

NonClustered Index
- A NonClustered Index is analagous to an index in a texbook.  The data is stored
in one place, the index in another place.  The index will have pointers to the storage
location of the data.

Since, the nonclustered index is stored separately from the actual data, a table can
have more than one non clustered index, just like how a book can have an index by
Chapters at the beginning and another index by common terms at the end.

In the index itself, the data is stored in an ascending or descendng order of the index key
which doesn't in any way influence the storage of data in the table.
Example of Creating Non Clustered Index:
CREATE NONCLUSTERED INDEX IX_tblEmployee_Name
ON tblEmployee(Name)



*/
/*
Shows more information about what fields compose the index keys.
*/
USE FAMISMod_TAMUS
EXEC sp_HelpIndex AFRFinancialReport
EXEC sp_HelpIndex FPRInvoice
EXEC sp_HelpIndex FPRInvoiceDollars
