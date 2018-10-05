/*
Work with functions
* Understand deterministic, non-determininistic; scalar and table values; apply built in scalar
  functions; create and alter user-defined functions (UDFs)
  
There are 3 types of User Defined Functions
1. Scalar Functions              - returns a single value
2. Inline table-valued functions
3. Multi-statement table valued functions

Scalar functions 
  -- may or may not have parameters, but always return a single (scalar) value.
  -- Can be used both in the SELECT and the WHERE Clause
  
Stored Procedures
   -- You cannot use Stored Procedures in a SELECT or WHERE Clause 
 
-- Scalar Function
To create a function use the following syntax

CREATE FUNCTION Function_name (@Parameter1 DataType, @Parameter2 DataType,,, @ParmeterN DataType)  
RETURNS return_datatype
AS
BEGIN
  -- Function Body
  RETURN return_datatype

END

 
INLINE TABLE 

INLINE TABLE FUNCTIONS returns a TABLE 

1. We specify TABLE as the return type, instead of any scalar data type
2. The function body is not enclosed between BEGIN and END Block.
3. The structure of the table that gets returned, is determined by the SELECT statement
   within the function. 

1. Inline Table Valued functions can be used to achieve the functionality 
    of parameterized views since Parametrized views are not possible.
2. The table returned by the table valued function, can also be used
    in joins with other tables. 
3. You can call a VIEW as the underlying table. 
4. You can update the underlying Table using INLINE Table Function 

https://www.youtube.com/watch?v=hs4mReAzESc&list=PL08903FB7ACA1C2FB&index=31




MULTI STATEMENT TABLE VALUED FUNCTIONS 

Differences  between INLINE versus MULTI Statement value Functions
1. In an Inline Table Valued function, the RETURNS clause cannot contain the structure
   of the table, the function returns.  Where as, with the multi-statement table valued
   function, specify the structure of the table that gets returned.
   
2.  Inline Table Valued function cannot have BEGIN and END Block, where as the multi-statement
    function can have.

3. Inline Table valued functions are better for performance, than multi-statement table
   valued functions.  

4. It's possible to update the underlying table using an inline table, but not possible using
   a multi-statement table valued function.  

https://www.youtube.com/watch?v=EgYW7tsNP6g&list=PL08903FB7ACA1C2FB&index=32
*/

-- SELECT SQUARE(3) AS SQR

-- When you execute the below it will automatically store dbo.CalcuateAge under the
-- directory FUNCTIONS/Scalar-valued functions
--

-- Scalar Function

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


-- MULTI STATEMENT TABLE Valued Function
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


USE AdventureWorks2014
Select *
From  dbo.fn_EmployeesByGender('F') AS E
JOIN dbo.Person.Person  AS P
ON E.BusinessEntityID = P.BusinessEntityID

Select * From  dbo.fn_EmployeesByGender('F')



String Functions

ASCII(Character expression)  - Returns the ASCII code of a given character expression
CHAR(Integer expression) - Converts an Integer ASCII code to a character.
LTRIM(Character expression) - Removes blanks on the left handside of the given character
RTRIM(Character expression) - Removes blanks on the right hand side of the given character expression
LOWER(Character expression) - Converts all characters in the given Character expression to lowercase letters.
UPPPER(Character expression) - Converts all the characters in the given Character_Expression to uppercase letters
REVERSE('Any_String_Expression) - Reverses all the characters in the given string expression
LEN(String_Expression) - Returns the count of total characters, in the given string expression, excluding the blanks at the end of the expression.

For a complete list go to SSMS Object Exporer  Programmability folder / Functions / System Functions / String Functions
https://www.youtube.com/watch?v=qJFr-R76r9A&list=PL08903FB7ACA1C2FB&index=22

LEFT(Character_Expression,Integer_Expression) - Returns the specified number of characters from the left hand side of the given character expression.
RIGHT(Character_Expression, Integer_Expression) - Returns the specified number of characters from the right hand side of the given character expression.
CHARINDEX('Expression_To_Find', 'Expression_To_Search, 'Start_Location') - Returns the starting position of the specified expression in a character string
SUBSTRING('Expression','Start','Length') - Returns substring(part of the string), from the given expression.
https://www.youtube.com/watch?v=vN4sy5nHn6k&list=PL08903FB7ACA1C2FB&index=23

REPLICATE(String to Replicate, Number of Times to Replicate)
SPACE(Number of spaces)
PATINDEX("%Patern%", Expression) - Returns the starting position of the first occurence.  PATINDEX allows the use of wildcards (CHARINDEX does not allow wildcards).
REPLACE(String Expression, Pattern, Replacement Value)
STUFF(Orignal Expression, Start, Length, Replacement expression)
https://www.youtube.com/watch?v=ALnM6d7OQUs&list=PL08903FB7ACA1C2FB&index=24

*/

SELECT ASCII('A')
SELECT CHAR(65)

DECLARE @Start INT
SET @START = 65
WHILE (@START <= 90)
BEGIN
  PRINT CHAR(@START)
  SET @START = @START + 1
END

SELECT RIGHT('ABCDEF',4)

/* A third parameter Start Location is optional */
DECLARE @EMAIL VARCHAR(30)
SET @EMAIL = 'pam@bbb.com'
SELECT CHARINDEX('@', @EMAIL)

SELECT SUBSTRING(@EMAIL,6,7)

SELECT SUBSTRING(@EMAIL, CHARINDEX('@', @EMAIL),7)

SELECT REPLICATE('*',5)

SELECT SUBSTRING(@EMAIL,1,2) + REPLICATE('*',5)

SELECT SUBSTRING(@EMAIL,1,2) + REPLICATE('*',5) +
       SUBSTRING(@EMAIL, CHARINDEX('@',@EMAIL), LEN(@EMAIL) - CHARINDEX('@',@EMAIL) +1) 

SELECT @EMAIL,
       SPACE(5),
	   @EMAIL

SELECT @EMAIL,
       REPLACE(@EMAIL,'.com','.net')

SELECT STUFF(@EMAIL, 2, 3, '*****')