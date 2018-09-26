/*
Temporary Tables 
https://www.youtube.com/watch?v=oGuS1rdfaMI&t=137s

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

CREATE TABLE #Person_Details
(
  Id int, 
  Name nvarchar(20)
)
INSERT INTO #Person_Details VALUES (1, 'Mike')
INSERT INTO #Person_Details VALUES (2, 'John')
INSERT INTO #Person_Details VALUES (3, 'Todd')

SELECT * FROM #Person_Details

SELECT name FROM tempdb..sysobjects 

/*
Using 'SELECT INTO' Syntax you do not need to define the columns.  The columns are defined 
behind the scenes. 
*/
USE AdventureWorks2014
SELECT P.FirstName,
       P.LastName
INTO #TempPerson
FROM Person.Person AS P

SELECT TOP 10 * FROM #TempPerson

/*
Table Variable - Just like TempTables, a Table variable is also created in TempDB.  The scope
of a table variable is the batch, stored procedure, or statement block in which it is declared.
They can be passed as parameters between procedures.
*/
Declare @TempPerson table(FirstName nvarchar (30), LastName nvarchar(30))

Insert @TempPerson
Select FirstName,
       LastName
FROM Person.Person 

SELECT TOP 10 * 
FROM @TempPerson


