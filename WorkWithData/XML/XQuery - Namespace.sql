--
--  
--
--  https://www.w3schools.com/xml/xpath_syntax.asp
--  XPATH is a subset of XQUERY
--  /   Selects from the root node
--  //  Selects nodes in the document from the current node that match the selection no matter where they are
--  .	Selects the current node
--  ..	Selects the parent of the current node
--  @	Selects attributes
--
-- THE DEFAULT NAMESPACE
-- If you use a default element namespace, the namespace is not included for the elements in the resulting XML; 
-- it is included for the attributes. Therefore, only the first and third queries are completely equivalent.
-- In addition, when you use the default element namespace, you can’t define your own namespace abbreviation.
-- You should prefer an explicit namespace definition to using the default element namespace.
-- 
DECLARE @x AS XML;
SET @x='
<CustomersOrders xmlns:co="TK461-CustomersOrders">
  <co:Customer co:custid="1" co:companyname="Customer NRZBB">
    <co:Order co:orderid="10692" co:orderdate="2007-10-03T00:00:00" />
    <co:Order co:orderid="10702" co:orderdate="2007-10-13T00:00:00" />
    <co:Order co:orderid="10952" co:orderdate="2008-03-16T00:00:00" />
  </co:Customer>
  <co:Customer co:custid="2" co:companyname="Customer MLTDN">
    <co:Order co:orderid="10308" co:orderdate="2006-09-18T00:00:00" />
    <co:Order co:orderid="10926" co:orderdate="2008-03-04T00:00:00" />
  </co:Customer>
</CustomersOrders>';
-- Namespace in prolog of XQuery
SELECT @x.query('
(: explicit namespace :)
declare namespace co="TK461-CustomersOrders";
//co:Customer[1]/*') AS [Explicit namespace];
-- Default namespace for all elements in prolog of XQuery
SELECT @x.query('
(: default namespace :)
declare default element namespace "TK461-CustomersOrders";
//Customer[1]/*') AS [Default element namespace];
-- Namespace defined in WITH clause of T-SQL SELECT
WITH XMLNAMESPACES('TK461-CustomersOrders' AS co)
SELECT @x.query('
(: namespace declared in T-SQL :)
//co:Customer[1]/*') AS [Namespace in WITH clause];
--Here is the abbreviated output.
--Explicit namespace
----------------------------------------------------------------------------------
--<co:Order xmlns:co="TK461-CustomersOrders" co:orderid="10692" co:orderd

--Default element namespace
----------------------------------------------------------------------------------
--<Order xmlns="TK461-CustomersOrders" xmlns:p1="TK461-Customers

--Namespace in WITH clause
----------------------------------------------------------------------------------
--<co:Order xmlns:co="TK461-CustomersOrders" co:orderid="10692" co:orderd
