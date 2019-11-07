/*
See also 
ModifyingData/StoredProcedures
ModifyingData/WorkwithFunctions
Tables_or_Tables.sql
Scope.sql
WorkwithData/QueryDataByUsingSelect

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
*/