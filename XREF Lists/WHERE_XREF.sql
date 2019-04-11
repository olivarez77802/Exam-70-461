/*
WHERE XREF - Different ways of using WHERE Clause

1. Finding Rows containing a value with WildCard
2. Finding Rows that are in a List of Values
3. Finding Rows that have a value between values
4. INSERT using WHERE
5. DELETE using WHERE
6. JOIN using WHERE
7. VIEWS using WHERE
8. HAVING used with WHERE
9. WHERE used in DERIVED Query
10. WHERE used in SubQuery
11. WHERE used with a SCALAR UDF (User defined function)
https://docs.microsoft.com/en-us/sql/t-sql/queries/where-transact-sql?view=sql-server-2017

**********************************************
Finding Rows containing a value with WildCard
**********************************************

SELECT EmployeeKey, LastName
FROM DimEmployee
WHERE LastName LIKE ('%Smi%');

*********************************************
Finding Rows that are in a List of Values
*********************************************

SELECT EmployeeKey, LastName
FROM DimEmployee
WHERE LastName IN ('Smith', 'Godfrey', 'Johnson');

*************************************************
Finding Rows that have a value between values
*************************************************
SELECT EmployeeKey, LastName
FROM DimEmployee
WHERE EmployeeKey Between 100 and 200;

SELECT orderid, unitprice, qty
FROM Sales.Orderdetails
WHERE qty BETWEEN @Lowqty AND @Highqty
*************************************************
INSERT using WHERE
*************************************************
INSERT INTO TABLE1
SELECT * FROM TABLE2
WHERE AGE = 18;

INSERT tbl_A (col, col2)  
SELECT col, col2   
FROM tbl_B   
WHERE NOT EXISTS (SELECT col FROM tbl_A A2 WHERE A2.col = tbl_B.col);  

******************
DELETE using WHERE
******************
DELETE FROM CUSTOMERS
WHERE ID = 6;

****************
JOIN using WHERE
****************
SELECT E.UIN, E.SSN, NAME, A.ADDRESS, A.STATE
FROM EMP  AS E
JOIN ADDRESS AS A
ON (E.UIN = A.UIN)
WHERE A.STATE = 'TX'

*****************
WHERE using VIEWS
*****************
CREATE VIEW view_name AS
SELECT column_names(s)
FROM table_name
WHERE condition 
https://www.w3schools.com/sql/sql_quickref.asp

************************
HAVING used with WHERE
************************
SELECT Column_name, aggregrate_function(columnname)
FROM table_name
WHERE column_name operator value
GROUP BY column_name
HAVING aggregrate_function(column_name) operator value

****************************
WHERE used in DERIVED Query
****************************
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

-- Derived Query #2
SELECT sub.*
FROM (
      SELECT *
	  FROM tutorial.sf_crime
	  WHERE day_of_week = 'Friday'
	  ) sub
WHERE sub.resolution = 'NONE'

************************
WHERE used with SubQuery
SQL EXISTS Operator - https://www.w3schools.com/sql/sql_exists.asp
************************
SELECT C.Firstname,
       C.Lastname,
	   C.EmailAddress
FROM PersonContact AS C
WHERE C.ContactID IN (SELECT ContactID
                      FROM Sales.SalesOderHeader);

-- EXIST Example
SELECT C.Firstname,
       C.Lastname,
	   C.EmailAddress
FROM PersonContact AS C
WHERE EXIST IN (SELECT soh.ContactID
                FROM Sales.SalesOderHeader AS soh
				WHERE soh.Contactid = c.Contactid);
--
INSERT tbl_A (col, col2)  
SELECT col, col2   
FROM tbl_B   
WHERE NOT EXISTS (SELECT col FROM tbl_A A2 WHERE A2.col = tbl_B.col);  

****************************
WHERE used with a Scalar UDF
****************************
A scalar UDF in the WHERE clause that restricts a result set is executed once
for every row in the referenced table.
See WorkWithFunctions.sql


*/