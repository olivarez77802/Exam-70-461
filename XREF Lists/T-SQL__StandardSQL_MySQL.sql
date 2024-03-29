/*  T-SQL versus standard SQL versus MYSQL
-- Below will tell you we are using Microsoft SQL Server 2017 on 2022/04/27
SELECT @@VERSION

T-SQL is a dialect of standard SQL.  SQL is a standard for both ISO and ANSI.  International 
Standards Organization and American National Standards Institute.

Writing in a standard way is considered best practice.  When you do so, your code is more portable.
When the dialect you're working with supports a standard and nonstandard way to do something, you
should always prefer the standard form as your default choice.


Examples of when to choose standard form:

1. T-SQL supports two 'not equal to' operators: <> and != .   <> is standard while != only applies to T-SQL.

2.  CAST and CONVERT Functions.  CAST is a standard.  CONVERT applies only to T-SQL.  You should only rely
    on CONVERT when you need to rely on the style argument.

3. Termination of SQL Statements.  According to standard SQL, you should terminate statements with a 
   semicolon.  T-SQL doesn't make this requirement for all statements, only in cases where there would
   be ambiguity of code elements, such as in the WITH Clause of a Common Table Expression (CTE). 


4. According to standard SQL, a SELECT query must have at minimum FROM and SELECT clause. Conversely,
   T-SQL supports a SELECT query with only a SELECT clause (no FROM Clause). 

5. COALESCE (Standard) versus ISNULL (T-SQL).

6. CURRENT_TIMESTAMP (Standard) versus GETDATE (T-SQL).

7. CASE (Standard) VERSUS IIF (T-SQL.)

Per Rick:
CURRENT_TIMESTAMP is an ANSI SQL function whereas GETDATE is the T-SQL version of that same function.
One interesting thing to note however, is that CURRENT_TIMESTAMP is converted to GETDATE() when creating 
the object within SSMS. Both functions retrieve their value from the operating system in the same way.


SQL versus MySQL   (We seem to not support MYSQL functions at this time)
https://www.simplilearn.com/tutorials/sql-tutorial/difference-between-sql-and-mysql

SQL - Is a query programming language that manages RDMS.
MYSQL - is a relational database management system that uses SQL.

SQL- Is primarily used to query and operate database systems.
MYQL - Allows you to handle, store, modify and delete data and store data in an organized way.

SQL - Does not support any connector.
MYSQL - Comes with a built-in  tool known as MySQL Workbench that facilitates creating, designing, and building databases.





*/