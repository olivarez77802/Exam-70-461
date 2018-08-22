/*
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