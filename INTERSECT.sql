/*
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
*/