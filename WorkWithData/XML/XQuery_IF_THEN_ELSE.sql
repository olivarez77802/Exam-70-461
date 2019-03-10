--
-- XQuery also supports conditional if..then..else expressions with the following syntax.
-- if (<expression1>)
-- then
--  <expression2>
-- else
--  <expression3>
--
-- XQuery Functions
-- Just as there are many data types, there are dozens of functions in XQuery as well. 
-- They are organized into multiple categories. The data() function, used earlier in the chapter, 
-- is a data accessor function. Some of the most useful XQuery functions supported by SQL Server are:
--
-- Numeric functions ceiling(), floor(), and round()
-- String functions concat(), contains(), substring(), string-length(), lower-case(), and upper-case()
-- Boolean and Boolean constructor functions not(), true(), and false()
-- Nodes functions local-name() and namespace-uri()
-- Aggregate functions count(), min(), max(), avg(), and sum()
-- Data accessor functions data() and string()
-- SQL Server extension functions sql:column() and sql:variable()
--
-- You can easily conclude what a function does and what data types it supports from the function
-- and category names. For a complete list of functions with detailed descriptions, 
-- see the Books Online for SQL Server 2012 article “XQuery Functions against the xml Data Type” 
-- at http://msdn.microsoft.com/en-us/library/ms189254.aspx
--
DECLARE @x AS XML = N'
<Employee empid="2">
  <FirstName>fname</FirstName>
  <LastName>lname</LastName>
</Employee>
<Employee empid="3">
  <FirstName>Jesse</FirstName>
  <LastName>Olivarez</LastName>
</Employee>
';
DECLARE @v AS NVARCHAR(20) = N'FirstName';
SELECT @x.query('
 if (sql:variable("@v")="FirstName") then
  /Employee/FirstName
 else
   /Employee/LastName
') AS FirstOrLastName;
GO
