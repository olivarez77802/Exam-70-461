/**** COALESCE Versus ISNULL Versus CASE */

/* COALESCE - COAL-ESC(ape) - E
 Will return the first non-null exrpession value.  If NULL is encountered will replace with Text.
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