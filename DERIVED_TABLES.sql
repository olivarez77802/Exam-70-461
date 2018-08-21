/*
Derived Tables

Dervied Tables are available only in the context of the current query.

Select DeptName, TotalEmployees
from
   (
     Select DeptName, DepartmentId, COUNT(*) as TotalEmployees
	 from tblEmployee
	 join tblDepartment
	 on tblEmployee.DepartmentId = tblDepartment.DeptId
	 group by DeptName, DepartmentId

    )
as EmployeeCount
Where TotalEmployees >= 2
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