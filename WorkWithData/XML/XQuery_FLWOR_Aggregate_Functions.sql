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
