/*
SELECT Statement
https://www.youtube.com/watch?v=R9pXnHIFj_8&index=10&list=PL08903FB7ACA1C2FB

Operators and Wild Cards
=
!= or <>
>=
<
<=
IN
BETWEEN
LIKE
NOT   - Not in a list, range

%  -  Specifies zero or more characters
_  -  Specifies exacly one characters
[] -  Any character with in the brackets
[^] - Not any character with in the brackets

--------------------------------------------------------------------------------------------
Elements of a SELECT Statement
1. SELECT - Defines which columns to return
2. FROM - Defines table to query
3. WHERE - Filters returned data using a predicate  --- May not be used with Aggregate Functions
4. GROUP BY - Arranges rows by groups - Used with Aggregate Functions
5. HAVING - Filters groups by predicate
6. ORDER BY - Sorts the results

Logical Order - The order in which a query is written is not the order
                in which it is evaluated in SQL Server.

5. SELECT   <select list>
1. FROM     <table source>
2. WHERE    <search condition>
3. GROUPBY  <group by list>
4. HAVING   <search condition>
6. ORDER BY <order by list>

DATEPART, DATEADD, DATEDIFF Functions
Select DATEPART(weekday, '2012-08-30 19:45:31.793') -- returns 5
SELECT DATEPART(MONTH, '2012-08-30 19:45:31.793')   -- returns 8
SELECT DATENAME(weekday, '2012-08-30 19:45:31.793') -- returns Thursday
SELECT DATEADD(DAY, 20, '2012-08-30 19:45:31.793') -- Returns 2012-09-19 19:45:31.793
SELECT DATEDIFF(MONTH, '11/30/2005', '01/31/2006') - Returns 2

https://www.youtube.com/watch?v=eYsizQVa_EU&index=27&list=PL08903FB7ACA1C2FB

--------------------------------------------------------------------------------------------
Examples

SELECT DISTINCT City from tblPerson

SELECT * FROM tblPerson Where City != 'London"

SELECT * FROM tblPerson Where Age BETWEEN 20 AND 25

SELECT * FROM tblPerson Where City LIKE 'L%'



*/

-- Example - Get Age
SELECT dbo.fnComputeAge('11/30/2005')

Alter function fnComputeAge(@DOB DateTime)
returns nvarchar(50)
AS
BEGIN
DECLARE @tmpdate datetime, @years int, @months int, @days int

SELECT @tmpdate = @DOB
SELECT @years = DATEDIFF(YEAR, @tmpdate, GETDATE()) -
                CASE
				   WHEN (MONTH(@DOB) > MONTH(GETDATE())) OR
				        (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE()))
				   THEN 1 ELSE 0
				END

SELECT @tmpdate = DATEADD(YEAR, @years, @tmpdate)

SELECT @months = DATEDIFF(MONTH, @tmpdate, GETDATE()) -
                 CASE
				    WHEN DAY(@DOB) > DAY(GETDATE())
					THEN 1 ELSE 0
				 END

SELECT @tmpdate = DATEADD (MONTH, @months, @tmpdate)

SELECT @days = DATEDIFF(DAY, @tmpdate, GETDATE())

Declare @Age nvarchar(50)
Set @Age = CAST(@years as nvarchar(4)) + ' Years ' + CAST(@months as nvarchar(2)) + ' Months ' + Cast(@days as nvarchar(2)) + ' Days Old '
return @Age
-- SELECT @years AS Years, @months AS Months, @days as Days
END

