/*
  Create and alter views (simple statements)
  - Create indexed views; create views without using the bulit in tools;
    CREATE, ALTER, DROP

Views versus Indexed Views
- A standard or non-indexed view, is just a stored SQL Query.  When we try to retrieve data
from the view, the data is actually retrieved from the underlying base tables.  So a view is just
a virtual table it does not store any data.
- An Index View gets materialized.  This means the view is now capable of storing data.


1. Views
2. Indexed Views

***************
Views
***************

 Advantages
  - A View is a virtual table.  View is a saved SELECT query.
  - Views can be used to implement row and column level security.
  - Views can be used to present aggregated data and hide details

  Disadvantages
  - If you update a view based on multiple tables it may not update correctly.
    Cannot issue a DML Command (INSERT, UPDATE, DELETE) on multiple base tables
    Will have to create 'Instead of insert' trigger.
	https://www.youtube.com/watch?v=MseKoztMpoo&list=PL08903FB7ACA1C2FB&index=45

  
  Updating a View
   A view can be updated under certain conditions which are given below −
      The SELECT clause may not contain the keyword DISTINCT.
	  The SELECT clause may not contain summary functions.
	  The SELECT clause may not contain set functions.
	  The SELECT clause may not contain set operators.
	  The SELECT clause may not contain an ORDER BY clause.
	  The FROM clause may not contain multiple tables.
	  The WHERE clause may not contain subqueries.
	  The query may not contain GROUP BY or HAVING.
	  Calculated columns may not be updated.
	  All NOT NULL columns from the base table must be included in the view in order for the INSERT query to function.

So, if a view satisfies all the above-mentioned rules then you can update that view. The following code block has an example
to update the age of Ramesh.

SQL > UPDATE CUSTOMERS_VIEW
   SET AGE = 35
   WHERE name = 'Ramesh';
This would ultimately update the base table CUSTOMERS and the same would reflect in the view itself.

*******************
INDEXED VIEWS
*******************
Indexed Views
    https://docs.microsoft.com/en-us/sql/relational-databases/views/create-indexed-views?view=sql-server-2017 
    Requirements for an index view
	1.  Verify SET options are correct for all existing tables that will be referenced in the view.
	2.  Verfiy the SET options for the session are set correctly before you create any tables and the view.
	3.  Verify that the view definition is deterministic.
	4.  Create the view by using the 'WITH SCHEMABINDING' Option.
	5.  Create the unique clustered index on the view.
	6.  The base tables in the view, should be referenced with 2 part name
	7.  If GROUP BY is specified, the view select list must contain a COUNT_BIG(*) expression

-- Definitions
Deterministic Functions
   Always return the same result anytime they are called, provided the database state has not changed. 
   SQUARE(); POWER(); SUM(); AVG() and COUNT();

Non-Deterministic Functions
    May return different results any time they are called.  GETDATE() and CURRENTTIMESTAMP()

RAND() may be deterministic if you provide seed value.  RAND() may be non-deterministic if you do
not provide the seed value.


-- Examples
USE AdventureWorks2012;  
GO  
--Set the options to support indexed views.  
SET NUMERIC_ROUNDABORT OFF;  
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,  
    QUOTED_IDENTIFIER, ANSI_NULLS ON;  
GO  
--Create view with schemabinding.  
IF OBJECT_ID ('Sales.vOrders', 'view') IS NOT NULL  
DROP VIEW Sales.vOrders ;  
GO  
-- Notice the Sales.OrderHeader
CREATE VIEW Sales.vOrders  
WITH SCHEMABINDING  
AS  
    SELECT SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS Revenue,  
        OrderDate, ProductID, COUNT_BIG(*) AS COUNT  
    FROM Sales.SalesOrderDetail AS od, Sales.SalesOrderHeader AS o  
    WHERE od.SalesOrderID = o.SalesOrderID  
    GROUP BY OrderDate, ProductID;  
GO  
--Create an index on the view.  
CREATE UNIQUE CLUSTERED INDEX IDX_V1   
    ON Sales.vOrders (OrderDate, ProductID);  
GO  
--This query can use the indexed view even though the view is   
--not specified in the FROM clause.  Notice the 'Sales.OrderHeader'  
SELECT SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS Rev,   
    OrderDate, ProductID  
FROM Sales.SalesOrderDetail AS od  
    JOIN Sales.SalesOrderHeader AS o ON od.SalesOrderID=o.SalesOrderID  
        AND ProductID BETWEEN 700 and 800  
        AND OrderDate >= CONVERT(datetime,'05/01/2002',101)  
GROUP BY OrderDate, ProductID  
ORDER BY Rev DESC;  
GO  
--This query can use the above indexed view.  
SELECT  OrderDate, SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS Rev  
FROM Sales.SalesOrderDetail AS od  
    JOIN Sales.SalesOrderHeader AS o ON od.SalesOrderID=o.SalesOrderID  
        AND DATEPART(mm,OrderDate)= 3  
        AND DATEPART(yy,OrderDate) = 2002  
GROUP BY OrderDate  
ORDER BY OrderDate ASC;  
GO  




*/