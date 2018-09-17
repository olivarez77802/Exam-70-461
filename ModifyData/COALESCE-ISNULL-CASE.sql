/**** COALESCE Versus ISNULL Versus CASE */

/* COALESCE - COAL-ESC(ape) - E
 Will return the first non-null exrpession value.  If NULL is encountered will replace with Text.

 Logical Query Processing  - The Order in which a query is written is not the order in which it is evaluated by SQL Server.
 5.  SELECT
 1.  FROM
 2.  WHERE
 3.  GROUP BY
 4.  HAVING
 6.  ORDER BY

 Microsoft Docs CASE Statement
 https://docs.microsoft.com/en-us/sql/t-sql/language-elements/case-transact-sql?view=sql-server-2017

 The CASE expression evaluates its conditions sequentially and stops with the first condition whose condition is satisfied.


 Using CASE Expressions in SELECT Clauses
 * T-SQL CASE Expressions return a single (scalar) value
 * CASE Expressions may be used in:
   SELECT Column list
   WHERE or HAVING Clause
   ORDER BY clause
 * CASE returns results result of an expression
 * In SELECT clause, CASE behaves as calculated column requiring an alias

 CASE p.Persontype
  WHEN 'IN' THEN 'Informer'
  WHEN 'EM' THEN 'Empath'
  ELSE 'Mystery'
 END AS PersonType

 */ 
USE ADVENTUREWORKS2014
SELECT TOP 1000 
       [Title]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[Suffix]
      ,COALESCE( Title, Suffix, MiddleName, LastName, 'Text') AS COALESCEX
  FROM [AdventureWorks2014].[Person].[Person]

 -- ISNULL - Will replace Null Values
SELECT TOP 1000 
       [Title]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[Suffix]
      ,ISNULL (Suffix,'No Suffix') AS SUFFIX 
	  ,ISNULL (MiddleName, 'No Middle Name') AS MIDDLE
  FROM [AdventureWorks2014].[Person].[Person]

-- CASE Statement

  SELECT TOP 1000 
       [Title]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[Suffix]
      ,CASE 
	    WHEN Title IS NULL THEN 'No Title'  
		WHEN Suffix IS NULL THEN 'No Suffix' ELSE Title
	  END	    
  FROM [AdventureWorks2014].[Person].[Person]