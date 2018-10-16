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