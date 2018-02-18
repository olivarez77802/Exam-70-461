/*
FUNCTIONS 

Work with functions.  Understand deterministic, non-deterministic functions; scalar and table values; apply built-in scalar functions; create and alter user-defined functions (UDFs)

There are 3 types of User Defined Functions
1. Scalar Functions              - returns a single value
2. Inline table-valued functions
3. Multi-statement table valued functions

Scalar functions 
  -- may or may not have parameters, but always return a single (scalar) value.
  -- Can be used both in the SELECT and the WHERE Clause
  
Stored Procedures
   -- You cannot use Stored Procedures in a SELECT or WHERE Clause 
 

To create a function use the following syntax

CREATE FUNCTION Function_name (@Parameter1 DataType, @Parameter2 DataType,,, @ParmeterN DataType)  
RETURNS return_datatype
AS
BEGIN
  -- Function Body
  RETURN return_datatype

END

  
*/

-- SELECT SQUARE(3) AS SQR

-- When you execute the below it will automatically store dbo.CalcuateAge under the
-- directory FUNCTIONS/Scalar-valued functions
--

--CREATE FUNCTION CalculateAge(@DOB Date)
--RETURNS INT
--BEGIN
--DECLARE @Age INT

--SET @Age = DATEDIFF(YEAR, @DOB, GETDATE()) - 
--           CASE
--		     WHEN (MONTH(@DOB) > MONTH(GETDATE())) OR
--			      (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE()))
--			 THEN 1
--			 ELSE 0
--		   END
-- RETURN @Age
-- END

SELECT dbo.CalculateAge('11/17/1965') AS AGE

-- Sp_helptext CalculateAge     -- Can be used to display contents of function




  