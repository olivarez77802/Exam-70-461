-- What is FLWOR?
-- FLWOR (pronounced "flower") is an acronym for "For, Let, Where, Order by, Return".
--
-- For - selects a sequence of nodes
-- Let - binds a sequence to a variable
-- Where - filters the nodes
-- Order by - sorts the nodes
-- Return - what to return (gets evaluated once for every node)
--
-- https://www.w3schools.com/xml/xquery_flwor.asp
--
-- The for clause selects all book elements under the Customer element into a variable called $i.
-- 
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
