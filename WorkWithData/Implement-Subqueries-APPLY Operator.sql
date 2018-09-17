/*

Implement sub-queries - Apply Operator

* The APPLY operator introduced in SQL Server 2005, is used to join a table to a table-valued
  function
* The Table Valued function on the right hand side of the APPLY operator gets called for each
  row from the left(also called outer table) table
* Cross Apply returns only matching rows (semantically equivalent to Inner Join)
* Outer Apply returns matching + non-matching rows (semantically equivalent to Left Outer Join).
  The unmatched columns of the table valued function will be set to NULL.

Cross Apply & Outer Apply Operator
https://www.youtube.com/watch?v=kVogo0AbatM

Examples

**************************************************************************************
Error - Will give you an error.  Does not allow an Inner Join on a Phyiscal Table and
a Table Valued Function.  !!! Must use APPLY Operator
**************************************************************************************

Select D.DepartmentName E.Name, E.Gender, E.Salary
from Department D
Inner Join fn_GetEmployeesByDepartmentId (D.Id) E
on D.Id = E.DepartmentId

***********************
APPLY Operator - Works!
***********************

Select D.DepartmentName, E.Name, E.Gender, E.Salary
from Department D
Cross Apply fn_GetEmployeeByDeparmtmentId (D.Id) E

-- on D.Id = E.DepartmentId   <-- Unlike Join - Not required

or if you also want non-matching rows use 'Outer Apply'

Select D.DepartmentName, E.Name, E.Gender, E.Salary
from Department D
Outer Apply fn_GetEmployeeByDeparmtmentId (D.Id) E

**************************
Ex. Table Valued Function
**************************

Create function fn_GetEmployeesByDepartmentId(@DepartmentId int)
returns table
as
Return
(
  Select * from Employee
  Where DeparmentmentID = @DepartmentId)
)

*/