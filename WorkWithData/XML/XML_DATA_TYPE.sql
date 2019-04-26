/*

XML Datatypes and Columns
https://docs.microsoft.com/en-us/sql/relational-databases/xml/xml-data-type-and-columns-sql-server?view=sql-server-2017


Although XML could be stored as simple text, plain text representation means having no knowledge
of the structure built into an XML document. You could decompose the text, store it in multiple
relational tables, and use relational technologies to manipulate the data. Relational structures
are quite static and not so easy to change. Think of dynamic or volatile XML structures. 
Storing XML data in a native XML data type solves these problems, enabling functionality attached to 
the type that can accommodate support for a wide variety of XML technologies.

XML type limitations
- XML type is not treated like character types
- Does not support comparison (except to NULL)
- No equality comparison
- No ORDER BY, GROUP BY
- No built in functions except ISNULL and COALESCE
- Cannot be used as a KEY Column
- Cannot be used in a UNIQUE Constraint
- Cannot be declared with COLLATE
- Uses XML encodings
- Always stored as UNICODE UCS-2

An XML data type includes five methods that accept XQuery as a parameter.
The methods support querying (the query() method), retrieving atomic values (the value() method),
checking existence (the exist() method), modifying sections within the XML data (the modify() method) 
as opposed to overwriting the whole thing, and shredding XML data into multiple rows in a result 
set (the nodes() method).

-------------------------------------------
Using the XML Data Type for Dynamic Schema
-------------------------------------------
You create the schema collection by using the 'CREATE XML SCHEMA COLLECTION' T-SQL Statement.
Creating the schema is a task that should not be taken lightly.  If you make an error in the
schema, some invalid data might be accepted and some valid data might be rejected.
 

XML Data Type Methods  
An XML data type includes five methods that accept XQuery as a parameter
1. query() method 
2. value() method 
3. exist() method
4. modify() method
5. nodes() method 

*/

-----
DECLARE @X AS XML
SET @X = N'
<CustomersOrders>
 <Customer custid="1">
  <!-- Comment 111 -->
  <companyname>Customer NRZBB</companyname>
  <Order orderid="10692">
   <orderdate>2007-10-13T00:00:00</orderdate>
  </Order>
  <Order orderid="10702">
    <orderdate>2008-03-16T00:00:00</orderdate>
  </Order>
  <Order orderid="10952">
    <orderdate>2008-03-16T00:00:00</orderdate>
  </Order>
  </Customer>
  <Customer custid="2">
    <!-- Comment 222 -->
	<companyname> Customer MLTDN</companyname>
	<Order orderid="10308">
	  <orderdate>2006-09-18T00:00:00</orderdate>
	</Order>
	<Order orderid="10952">
	   <orderdate>2008-03-04T00:00:00</orderdate>
	</Order>
  </Customer>
  </CustomersOrders>';
-- Query that gets Customer nodes with child nodes
SELECT @X.query('CustomersOrders/Customer/*')
AS [1. Principal nodes];
-- Query to return ALL nodes
SELECT @X.query('CustomersOrders/Customer/node()')
AS [2. All nodes]
-- Query to retun comment nodes only
SELECT @X.query('CustomersOrders/Customer/comment()')
AS [3. Comment nodes]
-- Return all orders for customer 2
SELECT @X.query('//Customer[@custid=2]/Order')
AS [4. Customer 2 orders]
-- Return all orders with order number 10952
SELECT @X.query('//Order[@orderid=10952]')
AS [5. Orders with orderid=10952]

