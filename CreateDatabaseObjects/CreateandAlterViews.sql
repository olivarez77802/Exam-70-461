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

  


*/