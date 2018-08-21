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

--------------------------------------------------------------------------------------------
Examples

SELECT DISTINCT City from tblPerson

SELECT * FROM tblPerson Where City != 'London"

SELECT * FROM tblPerson Where Age BETWEEN 20 AND 25

SELECT * FROM tblPerson Where City LIKE 'L%'



*/