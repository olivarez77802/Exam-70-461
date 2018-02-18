/*
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
 
 
*/