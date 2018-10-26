/* Joins

Types of Joins
* INNER JOIN - Returns rows when there is a match in both tables.
* LEFT JOIN - Returns all rows from the left table, even if there are no matches in the right table.
* RIGHT JOIN - Returns all rows from the right table, even if there are no matches on the left table.
* FULL JOIN - Returns rows when there is a match in one of the tables.
* SELF JOIN - Used to join a table to itself as if the table where two tables.
* CARTESIAN JOIN - Returns the Cartesian product of the sets of records from two or more joined tables.

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

    
*/
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