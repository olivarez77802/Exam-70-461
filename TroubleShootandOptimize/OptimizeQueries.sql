/*
Optimize Queries
- Understand statistics; read query plans; plan guides; DMVs; hints; statistics IO; Dynamic vs. parameterized queries;
  describe the different join types (HASH, MERGE, LOOP) and describe the scenarios they would be used in

Displaying Query Statistics
  * Understanding Pages and Extents
  * SET STATISTICS TIME 
  * SET STATTSTICS IO

  UPDATE STATISTICS table_or_indexed_view_name
  https://docs.microsoft.com/en-us/sql/t-sql/statements/update-statistics-transact-sql?view=sql-server-2017

  DBCC FREEPROCCACHE    (Command issued after upating statistics, may not want to do in a production environment)
  https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-freeproccache-transact-sql?view=sql-server-2017
  
  Statistic Basics
  https://www.red-gate.com/simple-talk/sql/performance/sql-server-statistics-basics/

  Index Metadata and Statistics Update Date for SQL Server
  https://www.mssqltips.com/sqlservertip/1550/index-metadata-and-statistics-update-date-for-sql-server/

  PAGES and Extents
  https://www.youtube.com/watch?v=CMqYr5U8Z3A

  Clustered Index - Determines the physical order of data in a table.  A table can only have one
  clustered index.   A primary key constraint will automatically create a clustered index on that
  column.  The index can contain multiple columns (a composite index), like the way a telephone
  directory is organized by last name and first name.   Accessing data in Clustered index is
  faster than NonClustered index, because the NonClustered index has to refer back to the table,
  if the selected column is not present in the index.  Clustered index determines the storage
  order of rows in a table, and hence doesn't require additional disk space, but where as Non 
  Clustered table is stored separately from the table, additional storage space is required.


  Execute sp_helpindex tblEmployee    <--- Will allow you to see clustered index


  NonClustered Index - The same as an index in a book.  The data is stored in one place the
  index is stored in another place.  The index will have pointers to the storage location of
  data.  A table can have more than one non-clustered index.  

  Clustered versus Non-Clustered Indexes
  https://www.youtube.com/watch?v=NGslt99VOCw&index=36&list=PL08903FB7ACA1C2FB

  Query Plans
  - See what's going on behind the scenes.  Determine the execution plan used by SQL Server.
  Uses:
    - Optimizing queries
	- Determine which indexes where used
  Two options to view:
    - Actual execution plan
	  Requires the query to be executed
	- Estimated execution plan
	  May not be correct.
 
  Data Access Methods 
    Scan
	- Examines every row in the table or index
	- Not optimal
	Seek
	- Uses Inexes
	- Optimal

  Join Algorithms  - Merge Join, Loop Join, and Hash Join
   
      Merge Join - Data is presorted, Most effecient Join
   
      Loop Join - Nested Loops.  One table is much smaller than the other.  Smaller table is searched for
                  values that match larger table.
   
      Hash Join - Larger tables and unsorted data.  Slowest type of join.

  Query Hint Concepts
     - Control how SQL Server will execute a query.  Which index to use.  How to lock data.  Typically you want to avoid!
	 - Locking Hints
	   Row Lock - Force locks at the row level
	   PageLock - Force locks at the page level
	   Tablock - Force locks at the table level
	 - Index and Parameter Hints
	   FORCESCAN - Scans the index or table
	   FORCESEEK - Seeks at the index or table
	   OPTIMIZE FOR UNKNOW - Tells SQL Server to create a query plan where the value for the parameter will change frequently.
	   
  Dynamic Management Objects
     - Used to see what's goin on behind the scenes.  Finds out how SQL Server is using resources.  Identifies problem queries.
	 - Views are treated like tables.
	 - Functions accept parameters. Parameters are often other database objects. 
	 - Execution plan only tells you about one query.  Dynamic Management Objects tells you what's going on at a Higher level.

  Index Dynamic Management Objects
     sys.dm_db_index_usage_stats     - Determines which indexes are (or aren't) being used
	 sys.dm_db_missing_index_details - Determines what indexes SQL Server thinks should be added.
	 sys.dm_db_index_physical_stats  - Determine how an index is using disk space.
	 sys.dm_tran_database_transactions - Information about transactions in the database.
	 sys.dm_tran_session_transactions - Information about transactions for sessions
	 sys.dm_tran_locks                - Information about data locked for transactions 

  Dynamic SQL
     - Allows for the creation of SQL on the fly
	 - Concerns - Performance.  Use sp_executesql
	 - Security - SQL Injection Attacks.  Allows an attacker to inject their own SQL statments. Use parameters.

	 EXECUTE sp_executesql <SQL> , <Parameter definitions>, <Parameter Values>

	 Example:
	   DECLARE @sql nvarchar(500) = 'SELECT Firstname, Lastname FROM Person.Contact WHERE Lastname 
	                                 FROM Person.Contact
									 WHERE LastName = @LastName;
	   DECLARE @parameterDefinitions nvarchar(500) = '@LastName nvarchar(50)';
	   EXECUTE sp_executesql @sql, @parameterDefinitions, @Lastname = 'Harrison';

  Dynamic versus Parameterized
  Advantages and Disadvantages of Dynamic SQL and Stored Procedures
  - Separating database logic from business logic - Stored procedure Advantage; Dynamic SQL Disadvantage change requires change to client code
  - Network traffic - Stored Procedure Advantage; Dynamic SQL DisAdvatage requires entire SQL statement to be sent
  - SQL Injection attacks - Stored Procedure Advantage (Stored procedure prevents SQL Injection); Dynamic SQL open doors for SQL Injection
  - Cached query plans reuse - Stored Procedure Advantages - reuses stored procedures; Dynamic SQL Disadvantage does not reuse
  - Maintenance - Stored Procedure Advantage; 
  - Implement flexible logic - Dynamic SQL Advantage
  https://www.youtube.com/watch?v=imSuP9vSjfk&index=147&list=PL08903FB7ACA1C2FB
   
  QUERY OPTIMIZATION
  https://app.pluralsight.com/player?course=sql-server-2012-querying-pt1&author=christopher-harrison&name=sql-server-2012-querying-pt1-m10&clip=0&mode=live

  **************************
  Working Statistic Examples
  ***************************
  Employee is a table in SO-ESI-SQL2 (dev) Database TAMUSDW01

  -- Example 1  - Tables (sys.stats, sys.stats_columns)

  sys.stats and sys.stats_columns system views are useful for retrieving high-level information; however,
  they provide no insight into actual distribution statistics.

      SELECT s.stats_id StatsID,
             s.name StatsName, 
             sc.stats_column_id StatsColID, 
             c.name ColumnName 
      FROM sys.stats s 
      INNER JOIN sys.stats_columns sc
            ON s.object_id = sc.object_id AND s.stats_id = sc.stats_id
      INNER JOIN sys.columns c
            ON sc.object_id = c.object_id AND sc.column_id = c.column_id 
       WHERE OBJECT_NAME(s.object_id) = 'Employee'
       ORDER BY s.stats_id, sc.column_id;

-- Example 2   Table sys.indexes

	SELECT name AS index_name,
	   STATS_DATE(OBJECT_ID, index_id) AS statistics_update_date
	FROM sys.indexes
	WHERE OBJECT_ID = OBJECT_ID('dbo.Employee');

-- Example 3
	DBCC SHOW_STATISTICS (table, index)  <-- Provide Distribution Statistics
	DBCC SHOW_STATISTICS ('Employee', PK_Employee)  

************************************
Query Plans
************************************
SET STATISTICS PROFILE ON   - Very Useful to put on top of your query's.
https://learn.microsoft.com/en-us/sql/t-sql/statements/set-statistics-profile-transact-sql?view=sql-server-ver16
When STATISTICS PROFILE is ON, each executed query returns its regular result set, followed by an additional result set that shows a profile of the query execution.
The additional result set contains the SHOWPLAN_ALL columns for the query and these additional columns.
Rows 	Actual number of rows produced by each operator
Executes 	Number of times the operator has been executed

SET STATISTIC PROFILE ON
SELECT *
FROM dbo.table AS T1
JOIN dbo.table2 as T2
   ON T1.key = T2.key

SET STATISTICS IO, TIME ON

****************************************
POOR Performing Operators
****************************************
-SCAN
-PARRALLELISM
-IMPLICIT CONVERSION




*/