/*
See Also:
ImplementAggregateQueries


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
   5. JOIN Operator  (See also NULL_XREF.sql)
   6. DERIVED Tables
   7. RANK 
   8. SYNONYMS
   9. Dynamic Sql  (See \XREF List\SQLInjection.sql)
      Implement Logic which uses dynamic SQL and system metadata.
   10. CASE - See Modifying Data/Combine datasets; Setting_Variable
   

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

See also WorkWithFunctions
* Understand deterministic, non-determininistic; scalar and table values; apply built in scalar
  functions; create and alter user-defined functions (UDFs)


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

LIKE Operator using a Variable
Example
DECLARE @WS VARCHAR(1)
DECLARE @SEARCHWS VARCHAR(2)
SET @SEARCHWS = @WS+'%'
SELECT *
FROM dbo.Table AS T
WHERE T.WS LIKE @SEARCHWS

LIKE Operator using regular expressions.
% - bl% finds bl, black, blue, and blob.
LIKE 'a%'	Finds any values that starts with "a"  
LIKE '%a'	Finds any values that ends with "a"
[]	Represents any single character within the brackets	h[oa]t finds hot and hat, but not hit
^	Represents any character not in the brackets	h[^oa]t finds hit, but not hot and hat
'%[^A-Z0-9a-z_ -./><:%|*@]%'  - Finds all character that are NOT alphabetic or numbers, underscores, dash, periods, forward slash, inequality, delimiter, asterisk,@ sign.

https://www.w3schools.com/sql/sql_wildcards.asp

 SELECT DISTINCT WT_TYP_CD,
  COUNT(WT_TYP_CD) OVER (PARTITION BY WT_TYP_CD ORDER BY WT_TYP_CD) AS CNT
  FROM [FAMISMod].[dbo].[PAYTables]
  WHERE WT_DATA LIKE '%[^A-Z0-9a-z_ -./><:%|*@]%'   
   
 SELECT * FROM 
  [FAMISMod].[dbo].[PAYTables]
  WHERE WT_TYP_CD = 'UB' AND  
  WT_DATA LIKE '%[^A-Z0-9a-z_ -./><:%|*@]%'     

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
1. INNER JOIN - Returns rows when there is a match in both tables.
2. LEFT (OUTER) JOIN - Returns all rows from the left table, returns matching rows on Right table.
3. RIGHT (OUTER) JOIN - Returns all rows from the right table, and matched records from Left Table. 
4. FULL (OUTER) JOIN - Returns rows when there is a match in one of the tables.

5. CROSS (CARTESIAN) JOIN - Returns the Cartesian product of the sets of records from two or more joined tables.
                           For example. if we have 10 rows in the Employee table and the Department table we
						   have 4 rows.  A cross join between these 2 tables produces 40 rows. 
						   Note! - A Cross Join will not have a 'ON' Clause.  Syntax:
						   Select Name, Gender, Salary, DepartmentName
						   FROM tblEmployee
						   CROSS JOIN tblDepartment
						   
6. SELF JOIN - Used to join a table to itself as if the table where two tables.
 
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

JOIN - Multiple Tables
A multiple join is a use of more than one join in a single query. The joins used may be all of the same type, or their types can differ. 
We’ll begin our discussion by showing an example query that uses two joins of the same type. Take a look at the query below.

SELECT v.name, c.name,  p.lastname
FROM vehicle v
INNER JOIN color c ON  v.color_id = c.id
INNER JOIN person p ON v.person_id = p.id ;

The query invokes two INNER JOINs in order to join three tables: vehicle, person and color. Only those records that have a match in each table will be returned.

If you have a lot of tables you are joining, it may be best to do preliminary work to create a 'base' from table and instead of doing inner joins, do a LEFT
JOIN so that your results will always include records from the 'base' table.

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
See also TroubleshootandOptimize\RowBasedOperations

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
         DENSE_RANK() OVER (PARTITION BY Gender ORDER BY Salary DESC) AS Salary_Rank
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

****************
9.  Dynamic SQL
****************
/*
See example of Dynamic SQL in:
1. Set xref - SET ANSI_NULLS
  
Can you generate and execute dynamic SQL in a different database than the one your code is in?
Yes, because the USE <database> command can be inserted into a dynamic SQL batch.

What are some objects that cannot be referenced in T-SQL by using variables?
Objects that you cannot use variables for in T-SQL commands include the database name in a USE statement,
the table name in a FROM clause, column names in the SELECT and WHERE clauses, and lists of literal values
in the IN() and PIVOT() functions.

The sp_executesql system stored procedure was introduced as an alternative to using the EXEC command
for executing dynamic SQL. It both generates and executes a dynamic SQL string.

The ability to parameterize means that sp_excutesql avoids simple concatenations like those used in the EXEC
statement. As a result, it can be used to help prevent SQL injection.

Implement Logic which uses Dynamic Sql and System Metadata.

List all Tables in a sql Server.
https://www.youtube.com/watch?v=z1HFiXt6KKQ

*************************************************************************************************************

Program: Temp
Author : Jesse Olivarez
Date : 2020/05/18
Purpose:
Program allow you to select Predict table to search based on @Choice Paramter.  Will find
characters that are not in @SRCHVAL for field @TB_TABLE_TYPE

Results Columns
Table   - Table Name
Found   - Number of records found that are Potentialy Binary

Detail information can be looked at by uncommenting code at the bottom, entering specific table
and re-running from top

*/

DECLARE @SRCHVAL NVARCHAR(30)
DECLARE @TBLNM VARCHAR(40)
DECLARE @TB_TABLE_TYPE VARCHAR (30)
DECLARE @TB_DATA VARCHAR (30)
DECLARE @DYNSQL NVARCHAR (MAX)

SET @SRCHVAL = N'%[^A-Z0-9a-z_ -./><:%|*@=;?]%' 
DECLARE @CHOICE  VARCHAR (3)
--
-- !! SET CHOICE BEFORE RUNNING
--
-- 1 - Predict Name 'IAPAY-TABLES
-- 2 - Predict Name 'IASYS-TABLES
-- 3 - Predict Name 'IAZSS-DOCUMENTATION'
-- 4 - Predict Name 'IAFPR-CONTROL-TABLES'
-- 5 - Predict Name 'IAFRS-BUDGET-TABLES'
-- 6 - Predict Name 'IASYS-DATA'
SET @CHOICE = 1
--
--
SELECT @TBLNM = 
CASE @CHOICE
-- Predict Name 'IAPAY-TABLES'
WHEN 1 THEN '[FAMISMod].[dbo].[PayTables]'
WHEN 2 THEN '[FAMISMod].[dbo].[SYSTables]'
WHEN 3 THEN '[FAMISMod].[dbo].[ZSSDocumentation]'
WHEN 4 THEN '[FAMISMod].[dbo].[FPRControlTables]'
WHEN 5 THEN '[FAMISMod].[dbo].[FRSBudgetTables]'
WHEN 6 THEN '[FAMISMod].[dbo].[SYSData]'
ELSE 'UNKNOWN'
END;
SELECT @TB_TABLE_TYPE = 
CASE @CHOICE 
WHEN 1 THEN 'WT_TYP_CD'
WHEN 2 THEN 'TB_GEN_TABLE_TYPE'
WHEN 3 THEN 'ZD_TOPIC_ID'
WHEN 4 THEN 'PT_TABLE_TYPE'
WHEN 5 THEN 'BX_GEN_TABLE_TYPE'
WHEN 6 THEN 'DA_TABLE_TYPE'
ELSE 'UNKNONW'
END;
SELECT @TB_DATA = 
CASE @CHOICE
WHEN 1 THEN 'WT_DATA'
WHEN 2 THEN 'TB_GEN_DATA'
WHEN 3 THEN 'ZD_TOPIC_NAME'
WHEN 4 THEN 'PT_TBL_DATA'
WHEN 5 THEN 'BX_GEN_DATA'
WHEN 6 THEN 'DA_DATA_1'
ELSE 'UNKNONWN'
END;          

-- Note! the LIKE Verb and the Quotes that are necessary without using a Parm
--SET @DYNSQL = ' 
--  SELECT DISTINCT ' + @TB_TABLE_TYPE + ',' +  
--  'COUNT(' + @TB_TABLE_TYPE +  ') OVER (ORDER BY ' + @TB_TABLE_TYPE + 
--  ') AS FOUND
--  FROM ' + @TBLNM + ' WHERE ' + @TB_DATA + ' LIKE  ''' + @SRCHVAL + '''' 

-- SELECT @DYNSQL 

-- EXECUTE sp_executesql @DYNSQL

-- Note! Much Nicer using Parm, Using Parms is also better to prevent SQL Injection
SET @DYNSQL = ' 
  SELECT DISTINCT ' + @TB_TABLE_TYPE + ',' +  
  'COUNT(' + @TB_TABLE_TYPE +  ')  AS FOUND
  FROM ' + @TBLNM + ' WHERE ' + @TB_DATA + ' LIKE  @SRCHVALParm ' +
  'GROUP BY ' + @TB_TABLE_TYPE 


SELECT @DYNSQL 

-- EXECUTE sp_executesql @DYNSQL
EXECUTE sys.sp_executesql @statement = @DYNSQL,@params = N'@SRCHVALParm NVARCHAR(30)',@SRCHVALParm = @SRCHVAL

-- 
-- Uncomment to show detail for tables - set @TB-TABLE_TYPE_VALUE
-- Run again from top
--
--DECLARE @DYNSQL2 NVARCHAR (MAX)
--DECLARE @TB_TABLE_TYPE_VALUE   VARCHAR(30)
--SET @TB_TABLE_TYPE_VALUE = 'PATTERN2007ME'
--SET @DYNSQL2 = 
--'SELECT ' + @TB_TABLE_TYPE + ',' + @TB_DATA + ' FROM ' +  @TBLNM  +
--' WHERE ' +  @TB_TABLE_TYPE + ' = ''' + @TB_TABLE_TYPE_VALUE +  '''' + ' AND '  
--+ @TB_DATA + ' LIKE ''' +  @SRCHVAL + ''''    

---- Only uncomment if you want to see actual SQL
------SELECT @DYNSQL2 

--EXECUTE sp_executesql @DYNSQL2

-- Note! Above was re-written to use Parms @SRCHVALParm
SET @DYNSQL2 = 
'SELECT ' + @TB_TABLE_TYPE + ',' + @TB_DATA + ' FROM ' +  @TBLNM  +
' WHERE ' +  @TB_TABLE_TYPE + ' = ''' + @TB_TABLE_TYPE_VALUE +  '''' + ' AND '  
+ @TB_DATA + ' LIKE @SRCHVALParm '    
 

-- Only uncomment if you want to see actual SQL
--SELECT @DYNSQL2 

EXECUTE sp_executesql 
@statement = @DYNSQL2,@params = N'@SRCHVALParm NVARCHAR(30)',@SRCHVALParm = @SRCHVAL

*/