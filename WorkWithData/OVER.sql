/*
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

  
