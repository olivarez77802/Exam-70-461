/*
See also WorkwithData/Implement-Subqueries.sql
See also QueryDataByUsingSelect.sql
See also XREF Lists/Distinct_Versus_Duplicate.sql

Combine Datasets
- Differences between UNION and UNION ALL; CASE versus ISNULL versus COALESCE; 
  Modify data by using MERGE statements.

1. COALESCE
2. CASE  (See Also SettingAVariable; QueryDataByUsingSelect) 
3. ISNULL
4. NULLIF
5. UNION and UNION ALL
6. CHOOSE 
7. IIF
8. MERGE

IIF and CHOOSE are nonstandard T-SQL functions that were added to simplify migrations
from Microsoft Access platforms.  Because these functions aren't standard and there are
simple standard alternatives with CASE expressions, it is not usually recommended that
you use them.



*******************
COALESCE Statement
******************* 

COALESCE - COAL-ESC(ape) - E
Will return the first non-null exrpession value.  If NULL is encountered will replace with Text.

SELECT Name, Color, ProductNumber, COALESCE(Color, ProductNumber) AS FirstNotNull   
FROM Products ;  
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/coalesce-transact-sql?view=sql-server-2017
For example, SELECT COALESCE(NULL, NULL, 'third_value', 'fourth_value'); returns the third value because the third value is the first value that isn't null.

COALESCE(expression1,expression2..) is equivalent to 
CASE
  WHEN (expression1 IS NOT NULL) THEN expression1
  WHEN (expression2 IS NOT NULL) THEN expression2
  ..
  ELSE expressionN
END

Comparing COALESCE and ISNULL
- Unlike ISNULL, COALESCE supports more than two inputs

-- COMPLEX Example
SET NOCOUNT ON;  
GO  
USE tempdb;  
IF OBJECT_ID('dbo.wages') IS NOT NULL  
    DROP TABLE wages;  
GO  
CREATE TABLE dbo.wages  
(  
    emp_id        TINYINT   IDENTITY,  
    hourly_wage   DECIMAL   NULL,  
    salary        DECIMAL   NULL,  
    commission    DECIMAL   NULL,  
    num_sales     TINYINT   NULL  
);  
GO  
INSERT dbo.wages (hourly_wage, salary, commission, num_sales)  
VALUES  
    (10.00, NULL, NULL, NULL),  
    (20.00, NULL, NULL, NULL),  
    (30.00, NULL, NULL, NULL),  
    (40.00, NULL, NULL, NULL),  
    (NULL, 10000.00, NULL, NULL),  
    (NULL, 20000.00, NULL, NULL),  
    (NULL, 30000.00, NULL, NULL),  
    (NULL, 40000.00, NULL, NULL),  
    (NULL, NULL, 15000, 3),  
    (NULL, NULL, 25000, 2),  
    (NULL, NULL, 20000, 6),  
    (NULL, NULL, 14000, 4);  
GO  
SET NOCOUNT OFF;  
GO  
SELECT CAST(COALESCE(hourly_wage * 40 * 52,   
   salary,   
   commission * num_sales) AS money) AS 'Total Salary'   
FROM dbo.wages  
ORDER BY 'Total Salary';  
GO  

Result:
Total Salary  
------------  
10000.00  
20000.00  
20800.00  
30000.00  
40000.00  
41600.00  
45000.00  
50000.00  
56000.00  
62400.00  
83200.00  
120000.00  
  
(12 row(s) affected)
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

The searched form of the CASE expression is more flexible.  Instead of comparing an input expression
to multiple expressions, it uses predicates in the WHEN clauses, and the first predicate that evaluates
to true determines when an expression is returned.

SELECT productid,
       productname, 
	   unitprice,
	   CASE
	     WHEN unitprice < 20.00 THEN 'Low'
		 WHEN unitprice < 40.00 THEN 'Medium'
		 WHEN unitprice >= 40.00 THEN 'High'
		 ELSE 'Unknown'
	   END AS pricerange
FROM Production.Products;

-- CASE statement example where other fields are used.
USE FAMISMod
SELECT 
CtCampusCd,
CTUIN,
dbo.fncNatDate2Date(CtPayPrdEndDt) AS 'EndDate',
CtDocId,
CtCampusCd,
  CASE WHEN ctcampuscd IN (02,04,05,10,15,16,17,18,21,22,23,24,25) THEN 'UNIVERSITY'
      WHEN CtCampusCd IN (01,06,07,09,11,12,20,26,28,30) THEN 'AGENCY'
	  ELSE 'NONE'
  END,
CtNewCampusCd,
 CASE WHEN CtNewCampusCd IN (02,04,05,10,15,16,17,18,21,22,23,24,25) THEN 'UNIVERSITY'
      WHEN CtNewCampusCd IN (01,06,07,09,11,12,20,26,28,30) THEN 'AGENCY'
	  ELSE 'NONE'
  END,
CtPaySrcCd,
CtAcctSl,
CtNewAcctSl,
CtAcctObj,
CtNewAcctObj,
CtActgAnalCd,
CtNewActgAnalCd,
CtAddedDt,
--dbo.fncNatDate2Date(CtAddedDt) AS 'AddDt',
CtAddedTime
-- INTO #TempPCT
FROM DBO.PAYCostTransferWork
WHERE CtAddedDt > 20231206 AND CtCampusCd <> CtNewCampusCd
ORDER BY CtAddedDt


Microsoft Docs CASE Statement
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/case-transact-sql?view=sql-server-2017



*******
NULLIF
*******
T-SQL supports the standard NULLIF function.  NULLIF(Col1, Col2).  Function accepts
two input expressions, returns NULL if they are equal, and returns the first input
if they are not.  If Col1 is equal to Col2, the function returns a NULL; otherwise
it returns the Col1 value.

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

The above is an equivalent to the following

CASE WHEN @a > @b  THEN 'TRUE' ELSE 'FALSE' END

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