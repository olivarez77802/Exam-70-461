/*
See also 
ModifyingData/StoredProcedures
ModifyingData/WorkwithFunctions
Tables_or_Tables.sql
Scope.sql
WorkwithData/QueryDataByUsingSelect

SQL Server Functions
https://www.w3schools.com/sql/sql_ref_sqlserver.asp


Functions versus Stored Procedures
Calling a Function

Function XREF
1. Inline Table Valued Function
2. Multistatement Table Valued Function


**************************
Calling a Function
**************************
-- Use in a Select and precede with dbo.fn..
-- Note!!! Having a function in a select statement can be expensive..will need to filter as much as possible
--         may not be feasible to use.
SELECT dbo.fnComputeAge('11/30/2005')

*********************************
Stored Procedure versus Function
*********************************
1.  Stored Procedures can return zero, single or multiple values.
    Functions must return a single value(which may be scalar or a table).
2.  We can use transaction in Stored Procedures.   You can't use transaction in 
    UDF(User Defined Function).
3.  Stored Procedures can have input/output parameters.  User Defined Function
    can only have input parameters.
4.  We can call a function from Stored Procedures.  We can't call a Stored Procedure from function.
5.  We can NOT use stored procedures in SELECT/WHERE/HAVING statements.   We can use User
    Defined Functions in SELECT/WHERE/HAVING statements.
6.  We can use exception handing in Try-Catch block in Stored Procedure.   We can Not use 
    Try-Catch block in User Defined Function.

https://stackoverflow.com/questions/1179758/function-vs-stored-procedure-in-sql-server#

*/