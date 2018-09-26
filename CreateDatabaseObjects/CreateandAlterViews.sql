/*
  Create and alter views (simple statements)
  - Create indexed views; create views without using the bulit in tools;
    CREATE, ALTER, DROP


  - Indexed Views
    https://docs.microsoft.com/en-us/sql/relational-databases/views/create-indexed-views?view=sql-server-2017 
 
  Disadvantages
  - Cannot issue a DML Command (INSERT, UPDATE, DELETE) on multiple base tables
    Will have to create 'Instead of insert' trigger.
	https://www.youtube.com/watch?v=MseKoztMpoo&list=PL08903FB7ACA1C2FB&index=45


*/