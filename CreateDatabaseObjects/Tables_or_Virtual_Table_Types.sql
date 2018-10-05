/*
Different ways Tables can be created or ways to simulate a table:
1. CTE 
2  #TempTable 
3. Derived Query
4. In-Line Table Value Function
5. Multi statement table valued function
5. Subqueries

CTE                            
--------------------          
- Only lasts for                  
  duration of query               
                                     
- Must be used immed-	           
  iately after query

- Require a semicolon
  on the SQL Statement
  preceding CTE

Temp Table
----------------------
- Lasts for a session

Derived Query
----------------------
- Only lasts for duration of query
- Basically a subquery, except it is always in the FROM Clause.  The reason it is called
  derived is because it functions as a table.

Inline Table Valued Function
-----------------------------
- Structure of the table that gets returned, is determined by the SELECT statement with in the function.
- The table returned by the table valued function, can also be used in joins with other tables.
- Function gets stored in Functions/Table-valued Functions

Table Valued Function
----------------------
- Can be used with APPLY operator to simulate an INNER JOIN or OUTER JOIN

Subqueries
----------
- Subqueries are used in JOIN and WHERE Clause.  Predicates are used
  when used with WHERE Clause.

Table Variable
--------------
- See TRS dbo.fncGetPayHistoryDaysHoursWorkedAsOf



*/