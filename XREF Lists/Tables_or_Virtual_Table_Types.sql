/*
See Also:
WorkwithData/QueryDatabyUsingSelect.sql

Different ways Tables can be created or ways to simulate a table:
1. CTE 
2  #TempTable - Define Columns   - Last only for session
2. #TempTables - No Column Definition - Last only for session
3. Table Variables - Always there - Several other advantages over #Temp Tables
4. Derived Table 
5. In-Line Table Value Function
6. Multi statement table valued function
7. Subqueries
8. Temp Tables in Dynamic SQL
9. Table Variables versus Multi Statement table valued function



********************
1. CTE                            
********************          
- Only lasts for                  
  duration of query               
                                     
- Must be used immed-	           
  iately after query

- Require a semicolon
  on the SQL Statement
  preceding CTE

With ITBL(Gender, MaritalStatus, VAC_HOURS)
as
(
  SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS VAC_HOURS
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY ROLLUP(E.Gender, E.MaritalStatus) 
 )
 
--  Select 'Hello'  /* if you uncomment will get error. CTE must be used immediately. */

Select *
FROM ITBL  
WHERE VAC_HOURS > 0 


************************************
2. Temp Table - Define Columns
 - Only Lasts as long as the session
************************************
- Lasts for a session
- If you create a temporary table in one stored procedure (Proc1), that temporary table is visible to all
  other stored procedures called from Proc1.   However, that temporary table is not visible to any other
  procedures that call Proc1.

-- See 'SELECT INTO' below if you don't want to define columns.

-- When you define the columns they can be used with a Stored procedure
-- CREATE TABLE #Employment (
   ****
   ) 
-- INSERT INTO #Employment
--	EXEC spGetEmploymentAsOf

CREATE TABLE #Person_Details
(
  Id int, 
  Name nvarchar(20)
)
INSERT INTO #Person_Details VALUES (1, 'Mike')
INSERT INTO #Person_Details VALUES (2, 'John')
INSERT INTO #Person_Details VALUES (3, 'Todd')

SELECT * FROM #Person_Details

Temporary Tables 
https://www.youtube.com/watch?v=oGuS1rdfaMI&t=137s

Local Temp Tables are noted with a prefixed # symbol.

Temporary Tables are only available for the connection that created the table,
if you were to open another connection and try to query the temporary table the query
would fail.   

What is a connection, when stored procedure that creates temp tables is called from SSIS ?  You 
have to look at the properties of your connection manager.  It should have a Misc Parameter named
'RetainSameConnection'.   If it set to false the Temp Tables will automatically be deleted.  If it is 
set to 'True' the Temp Tables won't be deleted see below link.
https://www.mssqltips.com/sqlservertip/2826/how-to-create-and-use-temp-tables-in-ssis/

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

--
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

*********************************************************************************************
2. Temp Tables - No Column Definition
Using 'SELECT INTO' Syntax you do not need to define the columns.  The columns are defined 
behind the scenes. 
*********************************************************************************************
-- Cannot be used with Stored Procedures.  Example you can't say 
-- SELECT *
-- INTO
-- FROM EXEC dbo.Stored-Procedure
-- 
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



******************
3. Table Variable
******************
- Table is created and dropped automatically with each run so it does not last the whole session like the temp table
  You won't have to drop the Table Variable if you decide to re-run.
- Using a Table Variable results in few recompilations of a stored procedure compared to a tempory table.
- Table Variable requires less locking and logging resources, because table variables have limited scope
  and are not part of the persistent database, transaction rollbacks do not affect them.
- A Table Variable is NOT a memory only structure.  A table variable might hold more data than can fit
  in memory, it has to have a place to store data on disk.  Table variables are created in the tempdb
  database similar to temporary tables.  If memory is available, both table variables and temporary tables
  are created and processed while in memory (data cache).
- Table Variables cannot have indexes

- See TRS dbo.fncGetPayHistoryDaysHoursWorkedAsOf

DECLARE @TempPeople TABLE
( 
   PersonName VARCHAR(MAX),
   PersonDOB  DATETIME
)
INSERT INTO @TempPeople

SELECT ActorName,
       ActorDOB
FROM tblActor
WHERE ActorDOB < '1950-01-01'

SELECT * FROM @TempPeople

https://www.youtube.com/watch?v=MdVd0fI1s-A&index=9&list=PLNIs-AWhQzcleQWADpUgriRxebMkMmi4H

*********************
4. Derived Table
*********************
- Only lasts for duration of query
- Basically a subquery, except it is always in the FROM Clause.  The reason it is called
  derived is because it functions as a table.

Dervied Tables are available only in the context of the current query.

A Derived Table is basically a subquery, exception it is always in the FROM Clause.
The reasons it is called a derived table is because it essentially functions as a 
table as far as the entire query is concerned.

Select DeptName, TotalEmployees
from
   (
     Select DeptName, DepartmentId, COUNT(*) as TotalEmployees
	 from tblEmployee
	 join tblDepartment
	 on tblEmployee.DepartmentId = tblDepartment.DeptId
	 group by DeptName, DepartmentId

    )
as EmployeeCount
Where TotalEmployees >= 2

****************************
5. Inline Table Valued Function
*****************************
- Structure of the table that gets returned, is determined by the SELECT statement with in the function.
- The table returned by the table valued function, can also be used in joins with other tables.
- Function gets stored in Functions/Table-valued Functions

CREATE FUNCTION HR.GetManagers(@empid AS INT) RETURNS TABLE
AS 
RETURN
  WITH EmpsCTE AS
   (
     SELECT empid, mgrid, firstname, lastname, 0 AS distance
	 FROM HR.Employees
	 WHERE empid = @empid

	 UNION ALL

	 SELECT M.empid, M.mgrid, M.firstname, M.lastname, S.distance + 1 AS distance
	 FROM EmpsCTE AS S
	   JOIN HR.Employees AS M
	     ON S.mgrid = M.empid
   )
   SELECT empid, mgrid, firstname, lastname, distance
   FROM EmpsCTE;
GO

*************************************
6. Multi Statement Table Valued Function
*************************************
- Can be used with APPLY operator to simulate an INNER JOIN or OUTER JOIN

***********
7. Subqueries
***********
- Subqueries are used in JOIN and WHERE Clause.  Predicates are used
  when used with WHERE Clause.
DisAdvantages - Can often be replaced by a join
-- Joins may perform faster
-- SQL Server will frequently rewrite subqueries as joins

SELECT p.Name,
       p.Listprice - ap.AverageListPrice AS DifferenceFromSubCategoryAverage
FROM Production.Product P
INNER JOIN (SELECT ProductSubcategoryID, AVG(Listprice) AS 'AverageListPrice'
            FROM Production.Product
			GROUP BY ProductSubcategoryID) AS ap
		ON P.SubcategoryID = ap.SubcategoryID
-- IN Example
SELECT C.Firstname,
       C.Lastname,
	   C.EmailAddress
FROM PersonContact AS C
WHERE C.ContactID IN (SELECT ContactID
                      FROM Sales.SalesOderHeader);

-- EXIST Example
SELECT C.Firstname,
       C.Lastname,
	   C.EmailAddress
FROM PersonContact AS C
WHERE EXIST IN (SELECT soh.ContactID
                FROM Sales.SalesOderHeader AS soh
				WHERE soh.Contactid = c.Contactid);

SELECT productid, productname, unitprice
FROM Prodution.Products
WHERE unitprice = (SELECT MIN(unitprice) FROM Production.Products);

***************************
Temp Tables in Dynamic SQL
***************************
CREATE PROC spTempTableInDynamicSQL
AS
BEGIN
  DECLARE @SQL NVARCHAR(MAX)
  SET @SQL = 'CREATE TABLE #Test(ID int)
              INSERT INTO #Test values (101)
			  SELECT * FROM #Test'
  EXECUTE sp_executesql @sql
END
https://www.youtube.com/watch?v=ZQvItdzB8to&list=PL08903FB7ACA1C2FB&index=149

****************************************************************
9. Table Variables versus Multi Statement table valued function
****************************************************************
---------------
Table Variable
---------------

DECLARE @TempPeople TABLE
( 
   PersonName VARCHAR(MAX),
   PersonDOB  DATETIME
)
INSERT INTO @TempPeople

SELECT ActorName,
       ActorDOB
FROM tblActor
WHERE ActorDOB < '1950-01-01'

SELECT * FROM @TempPeople

-------------------------------------
Multi Statement Table valued function
--------------------------------------
--
-- Uses a Table Variable
--
CREATE FUNCTION fn_MSTVF_GetEmployees()
RETURNS @TABLE Table(JobTitle nvarchar(40), Birthdate DATE, Gender nvarchar(10))
AS
BEGIN
INSERT INTO @TABLE
SELECT 
      JobTitle
      ,[BirthDate]
      ,Gender
FROM [AdventureWorks2014].[HumanResources].[Employee]
RETURN
END 

*/