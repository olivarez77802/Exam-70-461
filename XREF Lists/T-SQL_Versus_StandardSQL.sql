/*  T-SQL versus standard SQL

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






*/