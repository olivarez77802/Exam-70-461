/*
See Also Tables_or_Virtual_Table_Types.sql

Work with functions
* Understand deterministic, non-determininistic; scalar and table values; apply built in scalar
  functions; create and alter user-defined functions (UDFs)

1. Determininstic and Non-Deterministic
2. Create and Alter functions (UDFs)
3. SQL Server built in functions (String Functions)
   https://www.w3schools.com/sql/sql_ref_sqlserver.asp
4. SQL Server Math/Numeric Functions
   

Deterministic versus Non-Deterministic
- Deterministic Functions - Always return the same result anytime they are called provided 
  the database state has not changed.  All aggregate functions are deterministic functions. 
  Examples: SQUARE(); POWER(); SUM();AVG() and COUNT().
- Non-Deterministic Functions - May return different results anytime they are called.  
  GETDATE() and CURRENTTIMESTAMP()
- RAND() may be determininistic if you provide the seed value.  RAND() will be non-deterministic
  if you do not provide seed value.
  
There are 3 types of (UDF) User Defined Functions
1. Scalar Functions                       - returns a single value
2. Inline table-valued functions          - returns a table
3. Multi-statement table valued functions - The RETURN statement just ends the function and is not used to send data back. 

Scalar Functions versus Stored Procedures
-- You cannot use Stored Procedures in a SELECT or WHERE Clause
-- Scalar Functions do allow you to use in a SELECT or WHERE Clause 

UDF Performance Considerations
How a function is used can have a dramatic impact on the performance of the queries that you execute.
Specifically, scalar UDFs need to be very efficient because they are executed once for every row in a 
result set or sometimes for an entire table.   A scalare UDF in the SELECT list, when applied to column
values, is executed for every single row retrieved.   A scalar UDF in the WHERE clause that restricts
a result set is executed once for every row in the referenced table.

Ensuring Ordering is Deterministic (We know the Query will always be the same)
* Include all columns or expressions from the SELECT statement in ORDER BY Clause
  Otherwise, the query results are not guarenteed to be deterministic.
Example:
SELECT ProductID, SUM(OrderQty) AS 'Total Orders'
FROM Sales.SalesOrderDetail
WHERE UnitPrice < 50.00
GROUP BY ProductID
HAVING SUM(OrderQty) > 4000
ORDER BY SUM(OrderQty) DESC, ProductID

* To be deterministic ordering must be unique.

WITH ENCRYPTION and SCHEMABINDING
Encrypting a function definition using WITH ENCRYPTION Option:
You can encrypt stored procedures text using WITH ENCRYPTION OPTION.  Along the same
lines, you can also encrypt a function text.  Once encrypted, you cannot view the
text of the function, using sp_helptext system stored procedure.  If you try, you will
get a message stating 'The text for object is encrypted.' 

Create a function WITH SCHEMABINDING option:
Schemabinding, specified the function is bound to the database objects that it references.
When SCHEMABINDING is specified, the base objects cannot be modifed in any way that
would affect the function defiintion.  The function definition itself must first be modified
or dropped to removed dependencies on the object that is to be modified.
https://www.youtube.com/watch?v=WNoTgfg3mGc

--------------------------------------------------------------------------------------------------------------
Difference in:
Stored Procedure, Scalar Function, Inline Table Function, Table Variable, Multistatement Table Value Function
-------------------------------------------------------------------------------------------------------------- 
Functions / Procedures with Return Statements:
1. Stored Procedure - RETURN.  A stored procedure ends when the T-SQL batch ends, but you can cause the procedure
                               to exit by using the RETURN command.
-- Two Return Statements.  1st one is RETURNS second one is RETURN
2. Scalar Function - Second RETURN is at bottom RETURN datatype.
3. Inline Table - RETURNS TABLE AS RETURN - Both RETURN(S) on same line
4. Mulistatement - RETURNS @TABLE  - Second RETURN at the end.  Nothing followed by RETURN.

-- Scalar
CREATE Function FnTemp (Parameters Type)
RETURN datatype
AS 
BEGIN
 ..
 ..
 RETURN datatype
END

-- Inline Table --------------------------------------------------
CREATE FUNCTION FnTemp(Parameters Type)
RETURNS TABLE AS RETURN
(
..
)

CREATE FUNCTION [dbo].[udfGetProductList]
(@SafetyStockLevel SMALLINT
)
RETURNS TABLE
AS
RETURN
(SELECT Product.ProductID, 
        Product.Name, 
        Product.ProductNumber
 FROM Production.Product
 WHERE SafetyStockLevel >= @SafetyStockLevel)


-- Table Variable --------------------------------------------------
DECLARE @TempTable TABLE
(
  Variables Types
)
INSERT INTO @TempTable
SELECT.. FROM...

-- Multi Statement Table
CREATE FUNCTION fnTemp
RETURNS @TempTable (Paramters Type)
INSERT INTO @TempTable
SELECT .. FROM ..
RETURN



---------------
Scalar Function
---------------

Scalar functions 
  -- may or may not have parameters, but always return a single (scalar) value.
  -- Can be used both in the SELECT and the WHERE Clause

CREATE FUNCTION Function_name (@Parameter1 DataType, @Parameter2 DataType,,, @ParmeterN DataType)  
RETURNS return_datatype
AS
BEGIN
  -- Function Body
  RETURN return_datatype

END

Example 2.   

 SELECT SQUARE(3) AS SQR

 When you execute the below it will automatically store dbo.CalcuateAge under the
 SSMS directory Database/Programmability/Functions/Scalar-valued functions


 Scalar Function

CREATE FUNCTION CalculateAge(@DOB Date)
RETURNS INT
BEGIN
DECLARE @Age INT

SET @Age = DATEDIFF(YEAR, @DOB, GETDATE()) - 
           CASE
		     WHEN (MONTH(@DOB) > MONTH(GETDATE())) OR
			      (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE()))
			 THEN 1
			 ELSE 0
		   END
 RETURN @Age
 END

SELECT dbo.CalculateAge('11/17/1965') AS AGE

-- Sp_helptext CalculateAge     -- Can be used to display contents of function


------------- 
INLINE TABLE 
--------------
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

See also APPLY Operator in Implement-Subqueries.sql used to join INLINE TABLES.
CROSS APPLY same as INNER JOIN.  OUTER APPLY same as LEFT OUTER JOIN.

https://www.youtube.com/watch?v=hs4mReAzESc&list=PL08903FB7ACA1C2FB&index=31


CREATE FUNCTION Sales.fn_FilteredExtension
(
  @lowqty AS SMALLINT,
  @highqty AS SMALLINT
 )
RETURNS TABLE AS RETURN
(
    SELECT orderid, unitprice, qty
    FROM Sales.OrderDetails
    WHERE qty BETWEEN @lowqty AND @highqty
);

---------------------------------------
MULTI STATEMENT TABLE VALUED FUNCTIONS 
---------------------------------------

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


--------------------------------------------------------------------------------------------
3. SQL Server Built in Functions (String Functions)
--------------------------------------------------------------------------------------------

ASCII(Character expression)  - Returns the ASCII code of a given character expression
CHAR(Integer expression) - Converts an Integer ASCII code to a character.
TRIM(CHARACTER expression) - Removes FROM Beginning AND END but NOT IN middle
SELECT TRIM('#! ' FROM '    #SQL R#!cks Tutorial!     ') AS TrimmedString; 
LTRIM(Character expression) - Removes blanks on the left handside of the given character
RTRIM(Character expression) - Removes blanks on the right hand side of the given character expression
LOWER(Character expression) - Converts all characters in the given Character expression to lowercase letters.
UPPPER(Character expression) - Converts all the characters in the given Character_Expression to uppercase letters
REVERSE('Any_String_Expression) - Reverses all the characters in the given string expression

LEN(String_Expression) - Returns the count of total characters, in the given string expression, 
excluding the blanks at the end of the expression.
Example: LEN(N'xyz') returns 3.  Note that it returns the number of characters(not bytes), regardless
if the input is a regular character or Unicode character string.

For a complete list go to SSMS Object Exporer  Programmability folder / Functions / System Functions / String Functions
https://www.youtube.com/watch?v=qJFr-R76r9A&list=PL08903FB7ACA1C2FB&index=22

LEFT(Character_Expression,Integer_Expression) - Returns the specified number of characters from the left hand side of the given character expression.
RIGHT(Character_Expression, Integer_Expression) - Returns the specified number of characters from the right hand side of the given character expression.

CHARINDEX('Expression_To_Find', 'Expression_To_Search, 'Start_Location') - Returns the starting position of the specified
expression in a character string.  Example CHARINDEX(' ','Itzik Ben-Gan') looks for the first occurence of a space 
second occurence.

SUBSTRING('Expression','Start','Length') - Returns substring(part of the string), from the given expression.
https://www.youtube.com/watch?v=vN4sy5nHn6k&list=PL08903FB7ACA1C2FB&index=23
Example: SUBSTRING('abcde',1,3) returns 'abc'.
Note!  SUBSTRING can be used in a WHERE Clause... Neat!

REPLICATE(String to Replicate, Number of Times to Replicate)
SPACE(Number of spaces)
PATINDEX("%Patern%", Expression) - Returns the starting position of the first occurence.  PATINDEX allows the use of wildcards (CHARINDEX does not allow wildcards).

REPLACE(String Expression, Pattern, Replacement Value).  Example REPLACE('.1.2.3',',','/') substitutes all occurences of
a dot(.) with a slash(/), returning the string '/1/2/3/'.

STUFF(Orignal Expression, Start, Length, Replacement expression)
https://www.youtube.com/watch?v=ALnM6d7OQUs&list=PL08903FB7ACA1C2FB&index=24
Has four arguments.  
1. Input string 
2. Specifies from position 
3. Specifies number of characters to delete.
4. String to insert
Example STUFF(',x,y,z',1,1,'') returns 'x,y,z'.

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
SELECT CHARINDEX('@', @EMAIL)   /* Result is 4 */

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

FORMAT
Syntax
FORMAT(value, format, culture)
value 	Required. The value to be formatted
format 	Required. The format pattern
culture 	Optional. Specifies a culture (from SQL Server 2017)
https://www.w3schools.com/sql/func_sqlserver_format.asp
SELECT FORMAT(123456789, '##-##-#####'); 
/*
Used in dbo.spFRSVoucherBatDt

	Send the UIN with a leading 0 and so it's 9 digits to match program FCAR196.   If you don't send a leading 0 then SQL will send '30177663' and
	when it computes it for zoned decimal to prepare for packed field it will generate the value 301776630 with the 0 trailing so the FORMAT 
	statement ensures there's a leading 0 for the 9 digit field.
	*/
	SELECT FORMAT(ISN,'000000000') AS '** ISN',
	     VoVchr, 
	   VoItemNbr 
	FROM #TempVoucherTbl
*/

TRANSLATE
Return the string from the first argument AFTER the characters specified in the second argument are translated into the characters specified in the third argument:
Syntax
TRANSLATE(string, characters, translations)
string 	Required. The input string
characters 	Required. The characters that should be replaced
translations 	Required. The new characters 
https://www.w3schools.com/sql/func_sqlserver_translate.asp
SELECT TRANSLATE('3*[2+1]/{8-4}', '[]{}', '()()'); // Results in 3*(2+1)/(8-4) 
SELECT TRANSLATE('Monday', 'Monday', 'Sunday'); // Results in Sunday

-- REPLACE and TRANSLATE produce same 'This is a test'
SELECT REPLACE (REPLACE (REPLACE (REPLACE ('th!5 !s @ +es+', '+', 't'), '@', 'a'), '!', 'i'), '5', 's')
SELECT TRANSLATE ('th!5 !s @ +es+', '+@!5', 'tais')

SELECT TRANSLATE ('Rem#ove $Spe*cial','$#*','123')
SELECT TRANSLATE ('Rem#ove $Spe*cial','$#*','   ')
SELECT REPLACE(TRANSLATE ('Rem#ove $Spe*cial','$#*','***'),'*','')

SELECT STUFF(@EMAIL, 2, 3, '*****')

-----------------------------------------------------
4. SQL SERVER Math/Numeric Functions
-----------------------------------------------------
https://www.w3schools.com/sql/sql_ref_sqlserver.asp
/*
The SIGN() function returns the sign of a number.

This function will return one of the following:

    If number > 0, it returns 1
    If number = 0, it returns 0
    If number < 0, it returns -1

Example:
SELECT SIGN(255.5)    -- Returns 1
SELECT SIGN(0.00)     -- Returns 0
SELECT SIGN(-3)       -- Return -1 
*/
