/*
Query data by using SELECT statements
 - Use the ranking function to select top (X) rows for multiple categories in a single query; write and perform
   queries effeciently using the new (SQL 2005/8) oode items such as synonyms, and joins (except, intersect);
   implement logic which uses dynamic SQL and system metadata; write effecient; technically complex SQL queries,
   including all types of joins versus the use of derived tables; determine what code may or may not execute
   based on the tables provided; given a table with constraints, determine which statement set would load
   a table; use and understand different data access technologies; case versus isnull versus coalesce.
   
   1. SELECT Statement
   2. LIKE Operator
   3. EXCEPT Operator
   4. INTERSECT Operator
   5. JOIN Operator
   6. DERIVED Tables
   7. RANK 
   8. SYNONYMS
   

Set operators have precedence: INTERSECT precedes UNION and EXCEPT, and UNION and EXCEPT are evaluated from left to right 
based on their position in the expression. Consider the following set operators.

<query 1> UNION <query 2> INTERSECT <query 3>;

First, the intersection between query 2 and query 3 takes place, and then a union between the result of the intersection and
query 1. You can always force precedence by using parentheses. So, if you want the union to take place first, you use the 
following form.

(<query 1> UNION <query 2>) INTERSECT <query 3>; 

So Order of Precedence is:
1. INTERSECT
2. UNION and EXCEPT (Evaluated Left to Right)
  

***************
1. SELECT
***************

SELECT Statement
https://www.youtube.com/watch?v=R9pXnHIFj_8&index=10&list=PL08903FB7ACA1C2FB

Operators and Wild Cards
=
!= or <>
>=
<
<=
IN
BETWEEN
LIKE
NOT   - Not in a list, range

%  -  Specifies zero or more characters
_  -  Specifies exacly one characters
[] -  Any character with in the brackets
[^] - Not any character with in the brackets

--------------------------------------------------------------------------------------------
Elements of a SELECT Statement
1. SELECT - Defines which columns to return
2. FROM - Defines table to query
3. WHERE - Filters returned data using a predicate  --- May not be used with Aggregate Functions
           'Where' filtering cluase is evaluated per row - not per group.
4. GROUP BY - Arranges rows by groups - Used with Aggregate Functions
5. HAVING - Filters groups by predicate.  Filters by group.
6. ORDER BY - Sorts the results

Logical Order - The order in which a query is written is not the order
                in which it is evaluated in SQL Server.

5. SELECT   <select list>
1. FROM     <table source>
2. WHERE    <search condition>
3. GROUPBY  <group by list>
4. HAVING   <search condition>
6. ORDER BY <order by list>

-A typical mistake made by people who don't understand logical query processing is attempting to
refer in the 'WHERE' clause to a column alias defined in the 'SELECT' clause.  This isn't allowed
because the 'WHERE' clause is evaluated before the 'SELECT' clause.

- Note! - Due to SQL Optimization, a JOIN in the FROM statement may do filtering prior to the 
  WHERE clause being processed.

A very common question is, “What’s the difference between the ON and the WHERE clauses, and does it matter if you specify your predicate
in one or the other?” The answer is that for inner joins it doesn’t matter. Both clauses perform the same filtering purpose. Both filter 
only rows for which the predicate evaluates to true and discard rows for which the predicate evaluates to false or unknown. In terms of 
logical query processing, the WHERE is evaluated right after the FROM, so conceptually it is equivalent to concatenating the predicates
with an AND operator. SQL Server knows this, and therefore can internally rearrange the order in which it evaluates the predicates in 
practice, and it does so based on cost estimates.

SELECT shipperid, YEAR(shippeddate) AS shippedyear,
   COUNT(*) AS numorders
FROM Sales.Orders
WHERE shippeddate IS NOT NULL
GROUP BY shipperid, YEAR(shippeddate)
HAVING COUNT(*) < 100;
Notice that the query filters only shipped orders in the WHERE clause. This filter is applied at the row level conceptually
before the data is grouped. Next the query groups the data by shipper ID and shipped year. Then the HAVING clause filters 
only groups that have a count of rows (orders) that is less than 100. Finally, the SELECT clause returns the shipper ID, 
shipped year, and count of orders per each remaining group.

SELECT DISTINCT - 
https://www.w3schools.com/sql/sql_distinct.asp
- Below query will give you DISTINCT country, region, and city (not just DISTINCT Country).
SELECT DISTINCT country, region, city
FROM HR.Employees;

--------------------------------------------------------------------------------------------
Examples

SELECT DISTINCT City from tblPerson

SELECT * FROM tblPerson Where City != 'London"

SELECT * FROM tblPerson Where Age BETWEEN 20 AND 25

SELECT * FROM tblPerson Where City LIKE 'L%'




-- Example - Get Age
SELECT dbo.fnComputeAge('11/30/2005')

Alter function fnComputeAge(@DOB DateTime)
returns nvarchar(50)
AS
BEGIN
DECLARE @tmpdate datetime, @years int, @months int, @days int

SELECT @tmpdate = @DOB
SELECT @years = DATEDIFF(YEAR, @tmpdate, GETDATE()) -
                CASE
				   WHEN (MONTH(@DOB) > MONTH(GETDATE())) OR
				        (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE()))
				   THEN 1 ELSE 0
				END

SELECT @tmpdate = DATEADD(YEAR, @years, @tmpdate)

SELECT @months = DATEDIFF(MONTH, @tmpdate, GETDATE()) -
                 CASE
				    WHEN DAY(@DOB) > DAY(GETDATE())
					THEN 1 ELSE 0
				 END

SELECT @tmpdate = DATEADD (MONTH, @months, @tmpdate)

SELECT @days = DATEDIFF(DAY, @tmpdate, GETDATE())

Declare @Age nvarchar(50)
Set @Age = CAST(@years as nvarchar(4)) + ' Years ' + CAST(@months as nvarchar(2)) + ' Months ' + Cast(@days as nvarchar(2)) + ' Days Old '
return @Age
-- SELECT @years AS Years, @months AS Months, @days as Days
END

***************
2. LIKE Operator
***************
PERFORMANCE OF THE LIKE PREDICATE

When the LIKE pattern starts with a known prefix—for example, col LIKE ‘ABC%’— SQL Server can potentially 
efficiently use an index on the filtered column; in other words, SQL Server can rely on index ordering. 
When the pattern starts with a wildcard—for example, col LIKE ‘%ABC%’—SQL Server cannot rely on index ordering anymore. 
Also, when looking for a string that starts with a known prefix (say, ABC) make sure you use the LIKE predicate, 
as in col LIKE ‘ABC%’, because this form is considered a search argument. Recall that applying manipulation to the
filtered column prevents the predicate from being a search argument. For example, the form LEFT(col, 3) = ‘ABC’ 
isn’t a search argument and will prevent SQL Server from being able to use an index efficiently.

***************
3. EXCEPT Operator
***************

EXCEPT Operator
Returns unique rows from the left query that aren't in the right query's results
-- Introduced in SQL Server 2005
-- The number and the order of the columns must be the same in both the queries
-- The data types must be the same or compatible
-- Can use on ONE or TWO Tables

Differences between EXCEPT and NOT IN Operator
-- EXCEPT filters duplicates and returns only DISTINCT rows
   from the left query that are not in the right query results
-- NOT does not filter duplicates
-- EXCEPT expects the same number of columns in both queries. 
-- NOT IN,
   compares a single column from the outer query with a single column from the sub-query


Examples
-- Two Tables - Table A and B
SELECT Id, Name, Gender FROM TABLE A
EXCEPT
SELECT Id, Name, Gender FROM TABLE B

-- Single Table - Where Clause
SELECT Id, Name, Gender, Salary FROM tblEmployees
WHERE Salary >= 50000
EXCEPT
SELECT Id, Name, Gender, Salary FROM tblEmployees
WHERE Salary >= 60000

-- NOT IN Operator
Select Id, Name, Gender FROM TABLE A
WHERE Id NOT IN (SELECT Id FROM TABLE B)
 
*****************
4. INTERSECT 
*****************

INTERSECT Operator 
-- The number and order of the columns must be the same in both queries
-- Retrieves the common records from both the Left and Right Queries
-- The datatypes must be the same or compatible

Difference between INTERSECT and INNER JOIN
-- INTERSECT filters duplicates and returns only DISTINCT rows that are common between the Left and Right Query
-- INNER JOIN does NOT filter duplicates.  To make INNER JOIN behave like INTERSECT use DISTINCT Operator
-- INTERSECT returns two NULLS as a same value and returns all matching rows
-- INNER JOIN treats two different NULLS as two different values.  So if you are joining two tables based on a 
   nullable column and if both tables contain NULLs in that joining column, INNER JOIN will not include those rows in the
   result set.  

Examples
-- INTERSECT
Select Id, Name, Gender FROM TABLE A
INTERSECT
Select Id, Name, Gender FROM TABLE B

Select TableA.Id, TableA.Name, TableA.Gender FROM TableA
INNER JOIN TableB
ON TableA.Id = TableB.Id

 
**************
5. JOINS
**************

Joins

Types of Joins
* INNER JOIN - Returns rows when there is a match in both tables.
* LEFT (OUTER) JOIN - Returns all rows from the left table, returns matching rows on Right table.
* RIGHT (OUTER) JOIN - Returns all rows from the right table, and matched records from Left Table. 
* FULL (OUTER) JOIN - Returns rows when there is a match in one of the tables.
* SELF JOIN - Used to join a table to itself as if the table where two tables.
* CARTESIAN (CROSS) JOIN - Returns the Cartesian product of the sets of records from two or more joined tables.
                           For example. if we have 10 rows in the Employee table and the Department table we
						   have 4 rows.  A cross join between these 2 tables produces 40 rows. 
						   Note! - A Cross Join will not have a 'ON' Clause.  Syntax:
						   Select Name, Gender, Salary, DepartmentName
						   FROM tblEmployee
						   CROSS JOIN tblDepartment.
 
 See Also Apply Operator in Implement-Subqueries.sql
 CROSS APPLY - Same as INNER JOIN
 OUTER APPLY - Same as LEFT OUTER JOIN

 https://www.w3schools.com/sql/sql_join.asp

https://www.tutorialspoint.com/sql/sql-using-joins.htm

  
   JOIN XREF
   -  INNER JOIN 
          same as 'CROSS APPLY' Operator
		  same as Subquery using 'IN' Operator
		  same as subquery using 'EXISTS' Operator
   -  LEFT OUTER JOIN same as 'OUTER APPLY' Operator
   
   
   Cross Apply and Outer Apply Operator
   https://www.youtube.com/watch?v=kVogo0AbatM

   In most cases JOINS are faster than sub-queries.  However,
   in cases, where you only need a subset of records from a 
   table that you are joining with, sub-queries can
   be faster.
   https://www.youtube.com/watch?v=ZEcHC_o6OFw&list=PL08903FB7ACA1C2FB&index=47

  - INNER JOIN using a SubQuery  (This is the long way it would be much easier to use the
                                  OVER clause PARTITION BY Clause)
    SELECT Name, Salary, Employees.Gender, Gender.GendersTotal, Genders.AvgSal,
	Genders.MinSal, Genders.MaxSal
	FROM EMPLOYEES
	(SELECT Gender, COUNT(*) AS GendertTotal, AVG(Salary) AS AvgSal,
	 MIN(Salary) AS MinSal, MAX(Salary) AS MaxSal
	 FROM Employees
	 GROUP BY Gender) AS Genders
	 ON Genders.Gender = Employees.Gender

  - OVER (PARTITITION BY ...) Clause better alternative to INNER Join using Subquery
    SELECT Name, Salary, Gender,
	COUNT(Gender) Over (Partition by Gender) AS GenderTotal,
	AVG(Salary) Over (Partition by Gender) AS AvgSal,
	MAX(Salary) Over (Partition by Gender) AS MaxSal
	FROM Employees


   https://www.youtube.com/watch?v=KwEjkpFltjc&index=108&list=PL08903FB7ACA1C2FB

    
SELECT TOP 1000 PERS.BusinessEntityID
      ,[PersonType]
      ,[NameStyle]
      ,[Title]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[Suffix]
	  ,PHON.PhoneNumber
  FROM [AdventureWorks2014].[Person].[Person] AS PERS
  INNER JOIN Person.PersonPhone AS PHON
  ON PERS.BusinessEntityID = PHON.BusinessEntityID

*******************
6. DERIVED TABLES
*******************

Derived Tables

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


SELECT
P.FIRSTNAME,
P.LASTNAME,
P.BusinessEntityID,
E.AddressID,
A.City
FROM PERSON.PERSON AS P
JOIN PERSON.BusinessEntityAddress AS E
ON P.BusinessEntityID = E.BusinessEntityID
JOIN PERSON.ADDRESS AS A
ON E.AddressID = A.AddressID

*************
7. RANK
*************

Use the ranking function to select top(X) rows for multiple categories in a single query.
   RANK


RANK AND DENSE_RANK returns a rank starting at 1 based on the ordering of rows imposed by the ORDER BY Clause

ORDER BY Clause is required 

RANK Function will skip ranking if there is a tie whereas DENSE_RANK will not.

RANK() Returns  -     (1,1,...85)       /* 1 is repeated in both Rank and Dense_rank because there is a tie.
DENSE_RANK() Returns- (1,1,...2)

ROW_NUMBER - Returns an increasing unique row number starting at 1, even if there are duplicates.

Use case for RANK and DENSE_RANK Functions: Both these functions can be used to find the Nth highest
salary.  However, whic function to use depends on what you want to do when there is a tie.

Since we have 2 employees with the FIRST highest salary.  Rank() function will not return any rows for 
the SECOND highest salary.
Ex.
  WITH Result AS 
  (
    SELECT Salary, RANK() OVER (ORDER BY Salary DESC) AS Salary_Rank
	FROM Employees
  )
  SELECT TOP 1 Salary FROM Result WHERE Salary_Rank = 2

Though we have 2 Employees with the FIRST highest salary.  Dense_Rank() function
returns, the next salary after the tied rows as the SECOND highest salary.
Ex.
  WITH Result AS
  (
    SELECT Salary, DENSE_RANK() OVER (ORDER BY Salary DESC) AS Salary_Rank
	FROM Employees
  )
  SELECT TOP 1 Salary FROM Result WHERE Salary_Rank = 2

You can also use RANK and DENSE_RANK functions to find the Nth highest Salary
among Male or Female employee groups.

The following query finds the 3rd highest salary amount paid among the Female
employees group
Ex.
WITH Result AS
(
  SELECT Salary, Gender,
         DENSE_RANK() OVER (PARTION BY Gender ORDER BY Salary DESC) AS Salary_Rank
  FROM Employees
)
SELECT TOP 1 Salary FROM Result WHERE Salary_Rank = 3 AND Gender = 'Female'

https://www.youtube.com/watch?v=5-La_uSNkKU&list=PL08903FB7ACA1C2FB&index=110

Similarities between RANK, DENSE_RANK and ROW_NUMBER Functions
* Returns and increasing integer value starting at 1 based on the ordering of rows
  imposed by the ORDER BY Clause (if there are no ties)
* ORDER BY clause is required
* PARTITION BY clause is optional
* When the data is partitioned, the integer value is reset to 1 when the partition changes.

https://www.youtube.com/watch?v=MZTSHDFuCUk&index=111&list=PL08903FB7ACA1C2FB



USE ADVENTUREWORKS2014
SELECT ISNULL(E.Gender, '*') AS GENDER
	  ,ISNULL(E.MaritalStatus, '*') AS MARITAL
	  ,VacationHours
	  ,ROW_NUMBER() OVER (ORDER BY VACATIONHOURS) AS 'Row'
	  ,RANK() OVER (ORDER BY VACATIONHOURS) AS RANK1	
	  ,DENSE_RANK() OVER (ORDER BY VACATIONHOURS) AS DENSERANK 
FROM HumanResources.Employee AS E


USE ADVENTUREWORKS2014
SELECT ISNULL(E.Gender, '*') AS GENDER
	  ,ISNULL(E.MaritalStatus, '*') AS MARITAL
	  ,VacationHours
	  ,RANK() OVER (PARTITION BY E.GENDER ORDER BY VACATIONHOURS) AS RANK1	
	  ,DENSE_RANK() OVER (PARTITION BY E.GENDER ORDER BY VACATIONHOURS) AS DENSERANK 
FROM HumanResources.Employee AS E


https://docs.microsoft.com/en-us/sql/t-sql/functions/ranking-functions-transact-sql?view=sql-server-2017

SELECT p.FirstName, p.LastName  
    ,ROW_NUMBER() OVER (ORDER BY a.PostalCode) AS "Row Number"  
    ,RANK() OVER (ORDER BY a.PostalCode) AS Rank  
    ,DENSE_RANK() OVER (ORDER BY a.PostalCode) AS "Dense Rank"  
    ,NTILE(4) OVER (ORDER BY a.PostalCode) AS Quartile  
    ,s.SalesYTD  
    ,a.PostalCode  
FROM Sales.SalesPerson AS s   
    INNER JOIN Person.Person AS p   
        ON s.BusinessEntityID = p.BusinessEntityID  
    INNER JOIN Person.Address AS a   
        ON a.AddressID = p.BusinessEntityID  
WHERE TerritoryID IS NOT NULL AND SalesYTD <> 0;

******************
8. SYNONYMS
******************
   
   Synonyms using SSMS
   https://www.youtube.com/watch?v=qRzLupYLGQg

   Practical uses for Synonyms
   http://www.sqlservercentral.com/articles/Synonyms/115072/

   Write and perform queries effeciently using the new (SQL 2005/8) code items such as synonyms
   https://docs.microsoft.com/en-us/sql/t-sql/statements/create-synonym-transact-sql?view=sql-server-2017
  
 - Syntax.  Will store in folder Synonyms once created.
  CREATE SYNONYM dbo.Categories FOR Production.Categories;

  Then the end user can select from Categories without needing to specify a schema.

  SELECT categoryid, categoryname, description
  FROM Categories;

  -Synonyms cannot refer to other synonyms.  They can refer to database objects
   such as tables, views, stored procedures, and functions.  Synonym chaining is 
   not allowed.
  - You cannot reference a synonym in a DDL, statement such as ALTER.  Such
    statements require you reference the base object instead. 
	e.g. ALTER sp.StoredProcedure.   sp.StoredProcedure could not be a synonym.
  - You can drop a synonym by using the DROP SYNONYM statement
    DROP SYNONYM dbo.Categories

	Advantages or Disadvatage of Synonyms over Views
	 - Unlike views, synonyms can stand in for many other kinds of objects, not
	   just tables.
	 - Just as with views, synonyms can provide an abstraction layer, allowing
	   you to present a logical view of the system without having to expose the 
	   phyical names of the database objects to the end user. If the underlying
	   object is altered, the synonym will not break (NO SCHEMA BINDING).
	- Unlike views, synonyms cannot simplify complex logic like a view can
	  simplify complex joins.  Synonyms are really just names.
	- A view can refer to many tables, but a synonym can only refer to just
	  one object.
	- A view can reference another view, but a synonym cannot reference another
	  synonym; synonym chaining not allowed.
	- If you do not want to expose metadata to the user, the user will not see
	  the any columns or datatypes if the synonyms refers to a table or view,
	  nor will the user see any parameters if the synonym refers to a procedure
	  or function.
   
*/