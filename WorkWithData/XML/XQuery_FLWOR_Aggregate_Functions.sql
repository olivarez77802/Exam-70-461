-- What is FLWOR?
-- FLWOR (pronounced "flower") is an acronym for "For, Let, Where, Order by, Return".
-- A FLWOR expression is actually a 'for' loop. You can use it to iterate through a 
-- sequence returned by an XPath expression.
--
-- For - selects a sequence of nodes
-- Let - binds a sequence to a variable
-- Where - filters the nodes
-- Order by - sorts the nodes
-- Return - what to return (gets evaluated once for every node)
--
-- https://www.w3schools.com/xml/xquery_flwor.asp

-- The let clause allows variable assignments and it avoids repeating the same expression many times.
-- The let clause does not result in iteration.
-- Example:
-- let $x = (1 to 5)
-- return <test>{$x}</test>   <-- Result is <test>1 2 3 4 5</test>
--
-- 
-- The for clause selects all book elements under the Customer element into a variable called $i.
-- Example: 
DECLARE @X AS XML;
SET @X=N'
<root>
  <a>10<b>20</b><c>30</c></a>
  <d>40</d><e>50</e>
</root>';
SELECT
  @x.query('*') AS Complete_Sequence,
  @x.query('data(*)') AS Complete_Data,
  @x.query('data(root/a/b)') AS Element_b_Data,
  @x.query('data(root/a/c)') AS Elment_c_Data,
  @x.query('data(root/e)') AS Element_e_Data;
GO

/*
  XQuery Value Comparison Operators
*/
DECLARE @xvar AS XML = N'';
SELECT @xvar.query('(5) lt (10)');
SELECT @xvar.query('(5) gt (10)');
SELECT @xvar.query('(10) eq 10');
SELECT @xvar.query('(10) ne 10')
GO

/*
Example
*/
DECLARE @x AS XML;
SET @x='
<CustomersOrders>
  <Customer custid="1" companyname="Customer NRZBB">
    <Order orderid="10692" orderdate="2007-10-03T00:00:00" />
    <Order orderid="10702" orderdate="2007-10-13T00:00:00" />
    <Order orderid="10952" orderdate="2008-03-16T00:00:00" />
  </Customer>
  <Customer custid="2" companyname="Customer MLTDN">
    <Order orderid="10308" orderdate="2006-09-18T00:00:00" />
    <Order orderid="10926" orderdate="2008-03-04T00:00:00" />
  </Customer>
</CustomersOrders>';
SELECT @x.query('
for $i in //Customer
return
   <OrdersInfo>
      { $i/@companyname }
      <NumberOfOrders>
        { count($i/Order) }
      </NumberOfOrders>
      <LastOrder>
        { max($i/Order/@orderid) }
      </LastOrder>
   </OrdersInfo>
');
/*
XQuery Example 2
*/

DECLARE @x xml
SET @x = '
  <Orders>
    <Order OrderID="100" OrderDate="1/30/2012">
	   <OrderDetail ProductID="1" Quantity="3">
	      <Price>350</Price>
	   </OrderDetail>
	   <OrderDetail ProductID="2" Quantity="8">
	      <Price>500</Price>
	   </OrderDetail>
	   <OrderDetail ProductID="3" Quantity="10">
	      <Price>700</Price>
	   </OrderDetail>
	</Order>
	<Order OrderID="200" OrderDate="2/15/2012">
	   <OrderDetail ProductID="4" Quantity="5">
	      <Price>120</Price>
	   </OrderDetail>
	</Order>
  </Orders>'

  SELECT @x.query('/Orders/Order/OrderDetail')

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

