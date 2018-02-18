/*
INLINE TABLE 

INLINE TABLE FUNCTIONS returns a TABLE 

1. We specify TABLE as the return type, instead of any scalar data type
2. The function body is not enclosed between BEGIN and END Block.
3. The structure of the table that gets returned, is determined by the SELECT statement
   within the function. 

*/
/*
   1. Inline Table Valued functions can be used to achieve the functionality 
      of parameterized views since Parametrized views are not possible.
   2. The table returned by the table valued function, can also be used
      in joins with other tables. 
   3. You can call a VIEW as the underlying table. 
   4. You can update the underlying Table using INLINE Table Function 
*/
USE AdventureWorks2014
Select *
From  dbo.fn_EmployeesByGender('F') AS E
JOIN dbo.Person.Person  AS P
ON E.BusinessEntityID = P.BusinessEntityID

Select * From  dbo.fn_EmployeesByGender('F')

/* 
Example of Updating the underlying Table using INLINE Table Function
*/
Update dbo.fn_EmployeesByGender('F') SET Gender = 'M' WHERE BusinessEntityID = 2

-- Sp_HELPTEXT fn_EmployeesByGender 

/* Stores the following under directory Functions/Table-valued Functions
*/
--CREATE FUNCTION fn_EmployeesByGender(@Gender nvarchar(10))
--RETURNS TABLE
--AS
--RETURN (SELECT 
--      JobTitle
--      ,[BirthDate]
--      ,[MaritalStatus]
--      ,Gender
--      ,[HireDate] 
--FROM [AdventureWorks2014].[HumanResources].[Employee]
--WHERE Gender = @Gender) 



  