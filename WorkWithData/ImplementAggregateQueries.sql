
/*
See also:
WorkwithData/QueryDatabyUsingSelect.sql
WorkwithData/ImplementSubQueries.sql
XREFLists/Tables_or_Virtual_Tables.sql

All Aggregate Functions are determininistic functions.  
Examples: SQUARE(); POWER(); SUM();AVG() and COUNT().
Deterministic functions always return the same result any
time they are called with a specific set of input values
and given the same state of the database.
See ModifyingData\WorkWithFunctions.sql
https://www.youtube.com/watch?v=WNoTgfg3mGc

Grouped Query
- Contains a grouping function, GROUP BY, or both
- Arranges queries rows in groups
- Applies data analysis using aggregate functions against the group
- Can contain aggregate functions such as COUNT,AVG, SUM, MIN, or MAX
- Can contain multiple grouping sets by using GROUPING SETS, CUBE, or ROLLUP

Function  Syntax                                Description
--------  -------------------------             ---------------------------------------------------
AVG       AVG([ALL|DISTINCT]expression          Returns Averages - ignore NULLS

COUNT     COUNT({[[ALL|DISTINCT]expression]|*}) Returns the number of items in the group;	
COUNT_BIG                                       COUNT returns an INT;COUNT_BIG returns BIGINT

MAX       MAX([ALL|DISTINCT]expression          Returns maximum

MIN       MIN([ALL|DISTINCT]expression)         Returns minimum

SUM       SUM([ALL|DISTINCT]expression)         Returns sum

 

Implement Aggregate queries
 - New analytic functions; grouping sets; spatial aggregates; apply ranking functions

 Group functions versus Window Functions.
   
   Group Functions - Use Aggregate Functions.  A query becomes a grouped query when you use a group function, a 
   GROUP BY Clause, or both.  Grouped queries will hide the details.
   
   Window Functions -Use Aggregate Functions. 
   Aggregate Functions are applied to a window of rows defined by the 
   OVER clause. Window queries do not hide the detail, the return a row for every underlying query's row.  This means
   you can mix detail and aggregated elements in the same query.
   - OVER()
   - OVER ( [<PARTITION BY clause>]
            [<ORDER BY clause>]
			[<ROW or RANGE clause>] )
   Set of rows (window) defined per function is a partitioning of result set
   Unlike group queries, window queries return row detail

   
 1. AGGREGATE Functions
 2. GROUP BY
 3. UNION and UNION ALL
 4. ROLLUP
 5. GROUPING SETS
 6. CUBE
 7. GROUPING_ID()
 8. GROUPING Function
 9. HAVING()         -- Must follow the GROUP BY clause in a query and must also precede the ORDER BY clause if used.
 A0. Analytic Functions    
     A1. OVER 
     A2. ROW_NUMBER OVER                 
     A3. RANK (See QueryDataByUsingSelect.sql) -- ORDER BY is required.
     A4. OFFSET
     A5. FRAMING https://learnsql.com/blog/define-window-frame-sql-window-functions/

-----------------------
1. AGGREGATE Functions 
-----------------------
COUNT(), AVERAGE(), SUM() Functions
https://www.w3schools.com/sql/sql_count_avg_sum.asp

Note! - Null Values are ignored
See also NULL_XREF.sql (COUNT) for more information on how Nulls are ignored.

COUNT(*) returns the number of items in a group.  This includes NULL values and duplicates
COUNT(ALL expression) evaluates expression for each row in a group, and returns the number of nonnull values.
COUNT(DISTINCT expression) evaluates expression for each row in a group, and returns the number of unique, nonnull values.
https://docs.microsoft.com/en-us/sql/t-sql/functions/count-transact-sql?view=sql-server-ver15


MIN(), MAX()
https://www.w3schools.com/sql/sql_min_max.asp

-------------
2. GROUP BY
-------------

GROUP BY
 - required when non-aggregate fields are in SELECT statement
 - Returns NULL instead of zero if the field value is NULL
 - HAVING replaces WHERE in aggregation

GROUP BY - Often used with aggregate functions (COUNT, MAX, MIN, SUM, AVG) to group the result-set by one or more columns.
https://www.w3schools.com/sql/sql_groupby.asp
See also XREF Lists/Implicit_Defaults_XREF.sql for more info. on GROUP BY.



-----------------
3. UNION, UNION ALL
-----------------

UNION - Does not include Duplicates.   Sorts the output.  There is a performance penalty since we have to do a Distinct SORT.

UNION ALL - Will include all rows including duplicates.  Output is not sorted.

Note: For UNION and UNION ALL to work the Number, DataTypes, and the order of the columns in the select statement should be the same.


UNION ALL equivalent to ROLLUP
-- Left the below just to do a comparison


SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY E.Gender, E.MaritalStatus

  UNION ALL

  SELECT E.Gender
	  ,NULL 	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY E.Gender

  UNION ALL

  SELECT NULL
	  ,E.MaritalStatus 	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY E.MaritalStatus

  UNION ALL

  SELECT NULL
	  ,NULL 	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID

-- Example of Sorting with two Union Statements.  Notice the 'Order by' at the end.
SELECT id,name,age
From Student
Where age < 15
Union
Select id,name,age
From Student
Where Name like "%a%"
Order by name

-- Example of getting Top 4
SELECT TOP 4 a.* FROM
(
    SELECT *, 1 AS Priority from Usernames WHERE Name = 'Bob'
    UNION
    SELECT *, 2 from Usernames WHERE Name LIKE '%Bob%'
) AS a
ORDER BY Priority ASC
-----------------------------------------------------------------------------
4. ROLLUP  - Most Optimal when compared to UNION ALL and GROUP BY GROUPING SETS
-----------------------------------------------------------------------------

ROLLUP - Used to do AGGREGATE Operation on Multiple Levels in a heirarchy. 
So it will automatically give you the subtotals and Grand Totals.   

The question you have to ask to determine if you can use ROLLUP, is do 
I want totals on all of the columns in the SELECT clause (you will get totals
on all the Aggregate functions used in SELECT).

UNION ALL and GROUP SETS could also be used, however, the ROLLUP verb is the easiest way
to achieve Subtotals and Grand Totals.

USE AdventureWorks2014
SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY ROLLUP(E.Gender, E.MaritalStatus)

------------------------------------
5. GROUPING SETS compared to UNION ALL
------------------------------------
 /*
 See GROUPING SETS for an easier more effecient way of doing the above
 */

SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY GROUPING SETS
   (
    (E.Gender,E.MaritalStatus),     -- Sum of Vac Hours by Gender, Marital Status
	(E.Gender),                     -- Sum of Vac Hours by Gender
	(E.MaritalStatus),              -- Sum of Vac Hours by Marital Status
	()                              -- Grand Total Vacation Hours

   )

/* The above will replace the below and is much more efficient)
*/

SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY E.Gender, E.MaritalStatus

  UNION ALL

  SELECT E.Gender
	  ,NULL 	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY E.Gender

  UNION ALL

  SELECT NULL
	  ,E.MaritalStatus 	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY E.MaritalStatus

  UNION ALL

  SELECT NULL
	  ,NULL 	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
 
 /*
-------------
6. CUBE
-------------

CUBE Provides more subtotals than does ROLLUP.  CUBE Does totals on all possible combinations.  ROLLUP does totals based on the Heirarchy Order.

CUBE VERSUS GROUP BY -- Group by doesn't have Subtotals or Grand Totals
CUBE VERSUS ROLLUP  -- Cube has more subtotals
CUBE VERSUS GROUPING SETS - Exactly the same
*/
USE ADVENTUREWORKS2014
SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY E.Gender, E.MaritalStatus


  SELECT 
   E.Gender,
   E.MaritalStatus	
  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY CUBE(E.Gender, E.MaritalStatus) 
 --  ORDER BY E.Gender DESC   -- Have to use ORDER BY Clause if you want Subtotals and Grand Totals at Bottom

   SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY ROLLUP(E.Gender, E.MaritalStatus)

    SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY 
    GROUPING SETS
	(
	(E.Gender,E.MaritalStatus),
	(E.Gender),
	(E.MaritalStatus),
	()
	)
 
--------------
7. GROUPING_ID()
--------------- 
GROUPING_ID() concatenates all of the GROUPING functions, performs the binary decimal conversion, and returns the equivalent integer.

USE ADVENTUREWORKS2014
SELECT ISNULL(E.Gender, '*') AS GENDER
	  ,ISNULL(E.MaritalStatus, '*') AS MARITAL	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
	  ,GROUPING(E.Gender) AS GP_Gender
	  ,GROUPING(E.MaritalStatus) AS GP_MS
	  ,GROUPING_ID(E.Gender, E.MaritalStatus) AS GP_ID
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY ROLLUP(E.Gender, E.MaritalStatus)
  ORDER BY GP_ID

  -- Limited to one character - prints out 'G' and 'T'

  SELECT ISNULL(E.Gender, 'Grand Total')  AS GENDER
	  ,ISNULL(E.MaritalStatus, 'Total') AS MARITAL	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
	  ,GROUPING(E.Gender) AS GP_Gender
	  ,GROUPING(E.MaritalStatus) AS GP_MS
	  ,GROUPING_ID(E.Gender, E.MaritalStatus) AS GP_ID
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY ROLLUP(E.Gender, E.MaritalStatus)
  ORDER BY GP_ID
  
------------------
8. GROUPING Function 
-------------------

GROUPING indicates whether a column in a GROUPBY list is aggregated or not. 
GROUPING returns ‘1’ for aggregated or 
                 ‘0’ for not aggregated
in the result set.


USE ADVENTUREWORKS2014
SELECT ISNULL(E.Gender, 'ALL') AS GENDER
	  ,ISNULL(E.MaritalStatus, 'ALL') AS MARITAL	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
	  ,GROUPING(E.Gender) AS 'GP_Gender'
	  ,GROUPING(E.MaritalStatus) AS 'GP_MS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY ROLLUP(E.Gender, E.MaritalStatus)

  SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
	  ,GROUPING(E.Gender) AS 'GP_Gender'
	  ,GROUPING(E.MaritalStatus) AS 'GP_MS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY ROLLUP(E.Gender, E.MaritalStatus)

/*
GROUP BY 
*/
SELECT E.Gender
	  ,E.MaritalStatus	
	  ,SUM(E.VacationHours) AS 'VAC HOURS'
  FROM [AdventureWorks2014].[Person].[Person]  AS P
  JOIN HumanResources.Employee AS E
  ON P.BusinessEntityID = E.BusinessEntityID
  GROUP BY E.Gender, E.MaritalStatus

-------------
9. HAVING Clause
--------------
Syntax

  SELECT
  FROM  
  WHERE 
  GROUP BY
  HAVING
  ORDER BY

The HAVING clause must follow the GROUP BY clause in a query and must also precede the ORDER BY clause if used.

SELECT ID, NAME, AGE, ADDRESS, SALARY
FROM CUSTOMERS
GROUP BY age
HAVING COUNT(age) >= 2;

https://www.tutorialspoint.com/sql/sql-having-clause.htm


------------------
A0. Analytic Functions
------------------

Analytic Functions
https://docs.microsoft.com/en-us/sql/t-sql/functions/analytic-functions-transact-sql?view=sql-server-2017


-----
A1. OVER
-----

OVER Clause  ... uses PARTITION BY Clause.   Will allow you to join Detail and Summary Fields in the same Row.  

The OVER clause combined with PARTITION BY is used to break up data into partitions.  The specified function
operates for each partition
Syntax: function(...) OVER (PARTITION BY col1, col2, ...)
COUNT(Gender) OVER (PARTITION BY Gender) will partition the data by GENDER. i.e. there will be 2 partitions
(Male and Female) and then the COUNT() function is applied over each partitition.

Any of the functions can be used
COUNT(), AVG(), SUM(), MIN(), MAX(), ROW_NUMBER(), RANK(), DENSE_RANK() etc.

What if we want non-aggregated values (like Name and Salary) in result set along with aggregated values

-- The below will result in an error, since Name and Salary are not in GROUP BY Clause
SELECT Name, Salary, Gender, COUNT(*) AS GenderTotal, AVG(Salary) AS AvgSal,
       MIN(Salary) AS MinSal, MAX(Salary) AS MaxSal
FROM Employees
GROUP BY Gender

- INNER JOIN using a SubQuery  (This is the long way it would be much easier to use the
                                  OVER clause PARTITION BY Clause)
    SELECT Name, Salary, Employees.Gender, Genders.GendersTotal, Genders.AvgSal,
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

Running Total
Ex.
 SELECT Name, Gender, Salary,
       SUM(Salary) OVER (ORDER BY Id) AS RunningTotal
 FROM Employees
 https://www.youtube.com/watch?v=BMzZmq12YJI

*/

SELECT 
      JobTitle
      ,[BirthDate]
      ,[MaritalStatus]
      ,Gender
      ,[HireDate] 
      ,COUNT(Gender) OVER (PARTITION BY Gender) AS PG 
      ,Count([JobTitle]) OVER (PARTITION BY Gender) AS Title
	  ,COUNT([MaritalStatus]) OVER (PARTITION BY Gender) AS MS
FROM [AdventureWorks2014].[HumanResources].[Employee] 




-- Long way of joing Detail and Summary Rows without using the OVER and PARTION BY Clause

--- Detail 
 SELECT 
      [JobTitle]
      ,[BirthDate]
      ,[MaritalStatus]
      ,D.Gender
      ,[HireDate]
	  ,Title
	  ,MS
	  ,Gen_count
  FROM [AdventureWorks2014].[HumanResources].[Employee] AS D
  INNER JOIN
-- Summary
  (SELECT
	  Gender AS GENDER
      ,Count([JobTitle]) AS Title
      ,COUNT([MaritalStatus]) AS MS
      ,COUNT(Gender) AS Gen_count
   FROM [AdventureWorks2014].[HumanResources].[Employee] 
   GROUP BY GENDER) AS S
   ON D.Gender = S.GENDER

--------------
A2. ROW_NUMBER() OVER
---------------

09/23/2019 - I had A hard TIME mixing A Derived TABLE WITH a CTE.  I had TO CREATE A #TempTable USING 'SELECT INTO' TO make it WORK.

ROW_NUMBER() Clause  ....  

Needs the OVER (ORDER BY ... Clause

ROW_NUMBER() Will start over with each Partition see second example

Since ROW_NUMBER() starts over with each partition ... if you wanted to identify duplicates this could easily be done

https://www.youtube.com/watch?v=cvrwOoGwgz8&index=109&list=PL08903FB7ACA1C2FB

Use case of ROW_NUMBER() Function is that you can Delete all Duplicate Rows.
Example:
  WITH EmployeesCTE AS
  (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY ID ORDER BY ID) AS RowNumber
	FROM Employees
  )
  DELETE FROM EmployeesCTE WHERE RowNumber > 1

--- See example below where Derived Query is used.
*/

SELECT 
      JobTitle
      ,[BirthDate]
      ,[MaritalStatus]
      ,Gender
      ,[HireDate] 
	  ,ROW_NUMBER() OVER (ORDER BY Gender) AS GEN 
FROM [AdventureWorks2014].[HumanResources].[Employee] 


SELECT 
      JobTitle
      ,[BirthDate]
      ,[MaritalStatus]
      ,Gender
      ,[HireDate] 
	  ,ROW_NUMBER() OVER (PARTITION BY Gender ORDER BY GENDER) AS GEN 
FROM [AdventureWorks2014].[HumanResources].[Employee] 


-----------------------
A3. RANK
-----------------------
RANKING - Specify ordering OF ROWS WITHIN A PARTITION.
RANKING functions include:
- DENSE_RANK
- NTILE
- RANK
- ROW_NUMBER
USE WITH OVER AND ORDER BY parameter

Window Ranking Functions
FUNCTION          DESCRIPTION
------------      ------------------------------------
DENSE_RANK        RETURNS RANK OF each ROW IN PARTITION - may INCLUDE TIES but does NOT INCLUDE gaps.

NTITLE            RETURN the number OF the GROUP IN which ROW resides AS per specified number IN INTEGER expression

RANK              RETURNS RANK OF each ROW IN PARTITION - may INCLUDE TIES AND gaps

ROW_NUMBER        RETURNS A ROW's sequential number within a partition

--------------------------
A4. OFFSET
--------------------------
Window OFFSET functions
- Enable access to values in rows other than the current row
- Allow returning a value from a row in certain offset from the current row
- Enable comparisons between rows without need for self-join
- Window offset functions include:
  1. LAG - Returns a value from a row that is a specified number of rows before current row
  2. LEAD - Returns a value from a row that is a specified number of rows after the current row
  3. FIRST_VALUE - Returns first value in the window frame
  4. LAST_VALUE - Returns last value in the window frame

  
*********************
SO-EDW-SQL2
*********************
-- Example using CTE
WITH StatusCTE
AS
(
SELECT BPPStatus, BPPStatusDescription, ROW_NUMBER() OVER (PARTITION BY BPPStatus ORDER BY BPPStatus) AS RowNumber
FROM SEACommonTransform.dbo.vEDWWorkerDim
)
SELECT StatusCTE.BPPStatus, StatusCTE.BPPStatusDescription FROM StatusCTE
WHERE StatusCTE.RowNumber = 1
ORDER BY StatusCTE.BPPStatus

-- Alternate Method using Derived Query
SELECT BPPStatus, BPPStatusDescription
FROM (SELECT BPPStatus, BPPStatusDescription, ROW_NUMBER() OVER (PARTITION BY BPPStatus ORDER BY BPPStatus) AS RowNumber
      FROM SEACommonTransform.dbo.vEDWWorkerDim) AS D
WHERE RowNumber <= 1
ORDER BY D.BPPStatus


*/