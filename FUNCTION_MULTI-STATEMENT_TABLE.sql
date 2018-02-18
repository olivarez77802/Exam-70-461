/*
MULTI STATEMENT TABLE VALUED FUNCTIONS 

Differences  between INLINE versus MULIT Statement value Functions
1. In an Inline Table Valued function, the RETURNS clause cannot contain the structure
   of the table, the function returns.  Where as, with the multi-statement table valued
   function, specify the structure of the table that gets returned.
   
2.  Inline Table Valued function cannot have BEGIN and END Block, where as the multi-statement
    function can have.

3. Inline Table valued functions are better for performance, than multi-statement table
   valued functions.  

4. It's possible to update the underlying table using an inline table, but not possible using
   a multi-statement table valued function.  

*/
Select * From dbo.fn_MSTVF_GetEmployees()

--CREATE FUNCTION fn_MSTVF_GetEmployees()
--RETURNS @TABLE Table(JobTitle nvarchar(40), Birthdate DATE, Gender nvarchar(10))
--AS
--BEGIN
--INSERT INTO @TABLE
--SELECT 
--      JobTitle
--      ,[BirthDate]
--      ,Gender
--FROM [AdventureWorks2014].[HumanResources].[Employee]
--RETURN
--END 

