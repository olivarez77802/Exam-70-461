/*
  Create and alter views (simple statements)
  - Create indexed views; create views without using the bulit in tools;
    CREATE, ALTER, DROP

 Advantages
  - A View is a virtual table.  View is a saved SELECT query.
  - Views can be used to implement row and column level security.
  - Views can be used to present aggregated data and hide details

  Disadvantages
  - If you update a view based on multiple tables it may not update correctly.
    Cannot issue a DML Command (INSERT, UPDATE, DELETE) on multiple base tables
    Will have to create 'Instead of insert' trigger.
	https://www.youtube.com/watch?v=MseKoztMpoo&list=PL08903FB7ACA1C2FB&index=45

- Indexed Views
    https://docs.microsoft.com/en-us/sql/relational-databases/views/create-indexed-views?view=sql-server-2017 
    Requirements for an index view
	1.  Verify SET options are correct for all existing tables that will be referenced in the view.
	2.  Verfiy the SET options for the session are set correctly before you create any tables and the view.
	3.  Verify that the view definition is deterministic.
	4.  Create the view by using the 'WITH SCHEMABINDING' Option.
	5.  Create the unique clustered index on the view.

  
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


*/