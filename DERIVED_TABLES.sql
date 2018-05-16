/*
Derived Tables

Dervied Tables are available only in the context of the current query.
*/

SELECT
P.FIRSTNAME,
P.LASTNAME,
P.BusinessEntityID,
E.AddressID,
A.City
FROM PERSON.PERSON AS P
JOIN PERSON.BusinessEntityAddress AS E
ON P.BusinessEntityID = E.BusinessEntityID
JOIN PERSON.ADDRESS AS A
ON E.AddressID = A.AddressID