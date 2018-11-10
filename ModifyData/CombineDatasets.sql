/*

Combine Datasets
- Differences between UNION and UNION ALL; CASE versus ISNULL versus COALESCE; 
  Modify data by using MERGE statements.

1. COALESCE
2. CASE
3. ISNULL
2. UNION and UNION ALL
3. CHOOSE 
4. IIF
5. MERGE

4 Different ways of replacing a Null Value:
  A. COALESCE
  B. CASE
  C. ISNULL
  D. CONCAT - Substitutes a NULL input with an empty string (or skips the string)
*******************
COALESCE Statement
******************* 

COALESCE - COAL-ESC(ape) - E
Will return the first non-null exrpession value.  If NULL is encountered will replace with Text.

SELECT Name, Color, ProductNumber, COALESCE(Color, ProductNumber) AS FirstNotNull   
FROM Products ;  
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/coalesce-transact-sql?view=sql-server-2017

***************
CASE Statememnt
***************

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

Microsoft Docs CASE Statement
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/case-transact-sql?view=sql-server-2017

*******
ISNULL
*******
ISNULL (check_expression, replacement value)
SELECT Description, DiscountPct, MinQty, ISNULL(MaxQty, 0.00) AS 'Max Quantity'  
FROM Sales.SpecialOffer;  

https://docs.microsoft.com/en-us/sql/t-sql/functions/isnull-transact-sql?view=sql-server-2017

*******************
UNION and UNION ALL
*******************
/*
UNION


UNION - Does not include Duplicates.   Sorts the output.  There is a performance penalty since we have to do a Distinct SORT.

UNION ALL - Will include all rows including duplicates.  Output is not sorted.

Note: For UNION and UNION ALL to work the Number, DataTypes, and the order of the columns in the select statement should be the same.

Compare with GROUPING Sets
*/
USE AdventureWorks2014
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
  See GROUPING SETS for an easier more effecient way of doing the above
*/

******
CHOOSE
******
-- Returns the item at the specified index from a list of values
SELECT JobTitle, HireDate, CHOOSE(MONTH(HireDate),'Winter','Winter', 'Spring','Spring','Spring','Summer','Summer',   
                                                  'Summer','Autumn','Autumn','Autumn','Winter') AS Quarter_Hired  
FROM HumanResources.Employee  
WHERE  YEAR(HireDate) > 2005  
ORDER BY YEAR(HireDate); 

https://docs.microsoft.com/en-us/sql/t-sql/functions/logical-functions-choose-transact-sql?view=sql-server-2017

*****************
IIF - Instant IF
*****************
IIF (boolean_expression, true_value, false_value)

DECLARE @a int = 45, @b int = 40;  
SELECT IIF ( @a > @b, 'TRUE', 'FALSE' ) AS Result;  

******
MERGE
******
The conditional behavior described for the MERGE works best when the two tables have a complex mixture
of matching characteristics.  Example, inserting a row if it does not exist, or updating the row
if it does not match.

-- Create a temporary table variable to hold the output actions.  
DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20));  

MERGE INTO Sales.SalesReason AS Target  
USING (VALUES ('Recommendation','Other'), ('Review', 'Marketing'), 
              ('Internet', 'Promotion'))  
       AS Source (NewName, NewReasonType)  
ON Target.Name = Source.NewName  
WHEN MATCHED THEN  
UPDATE SET ReasonType = Source.NewReasonType  
WHEN NOT MATCHED BY TARGET THEN  
INSERT (Name, ReasonType) VALUES (NewName, NewReasonType)  
OUTPUT $action INTO @SummaryOfChanges;  

-- Query the results of the table variable.  
SELECT Change, COUNT(*) AS CountPerChange  
FROM @SummaryOfChanges  
GROUP BY Change;  
https://docs.microsoft.com/en-us/sql/t-sql/statements/merge-transact-sql?view=sql-server-2017

*/ 