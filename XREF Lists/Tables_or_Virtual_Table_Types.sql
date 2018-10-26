/*
Different ways Tables can be created or ways to simulate a table:
1. CTE 
2  #TempTable    - Last only for session
3. Table Variables - Always there - Several other advantages over #Temp Tables
4. Derived Query
5. In-Line Table Value Function
6. Multi statement table valued function
7. Subqueries
8. Temp Tables in Dynamic SQL


********************
CTE                            
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
Temp Table
 - Only Lasts as long as the session
************************************
- Lasts for a session

**********************************************************
Table Variable
- Table is created and dropped automatically with each run
- Using a Table Variable results in few recomilations of a stored procedure compared to a tempory table.
- Table Variable requires less locking and logging resources, because table variables have limited scope
  and are not part of the persistent database, transaction rollbacks do not affect them.
- A Table Variable is NOT a memory only structure.  A table variable might hold more data than can fit
  in memory, it has to have a place to store data on disk.  Table variables are created in the tempdb
  database similar to temporary tables.  If memory is available, both table variables and temporary tables
  are created and processed while in memory (data cache).
- Table Variables cannot have indexes

- See TRS dbo.fncGetPayHistoryDaysHoursWorkedAsOf
**********************************************************

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
Derived Query
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
Inline Table Valued Function
*****************************
- Structure of the table that gets returned, is determined by the SELECT statement with in the function.
- The table returned by the table valued function, can also be used in joins with other tables.
- Function gets stored in Functions/Table-valued Functions

*************************************
Multi Statement Table Valued Function
*************************************
- Can be used with APPLY operator to simulate an INNER JOIN or OUTER JOIN

***********
Subqueries
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



*/