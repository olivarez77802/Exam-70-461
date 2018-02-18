USE AdventureWorks2014
SELECT
p1.FirstName,
p1.LastName,
p2.PhoneNumber
FROM Person.Person p1
INNER JOIN Person.PersonPhone p2
on p1.BusinessEntityID = p2.BusinessEntityID