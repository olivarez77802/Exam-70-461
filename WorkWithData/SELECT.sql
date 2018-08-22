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

Examples

SELECT DISTINCT City from tblPerson

SELECT * FROM tblPerson Where City != 'London"

SELECT * FROM tblPerson Where Age BETWEEN 20 AND 25

SELECT * FROM tblPerson Where City LIKE 'L%'



*/