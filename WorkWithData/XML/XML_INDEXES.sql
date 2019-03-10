/*
The XML data type is actually a large object type. There can be up to 2 gigabytes (GB) of data
in every single column value. Scanning through the XML data sequentially is not a very efficient way 
of retrieving a simple scalar value. With relational data, you can create an index on a filtered column,
allowing an index seek operation instead of a table scan. Similarly, you can index XML columns with specialized 
XML indexes.  The first index you create on an XML column is the primary XML index. This index contains 
a shredded persisted representation of the XML values. For each XML value in the column, the index creates 
several rows of data. The number of rows in the index is approximately the number of nodes in the XML value. 
Such an index alone can speed up searches for a specific element by using the exist() method. After creating
the primary XML index, you can create up to three other types of secondary XML indexes:
-	PATH This secondary XML index is especially useful if your queries specify path expressions. It speeds up the exist() method better than the Primary XML index. Such an index also speeds up queries that use value() for a fully specified path.
-	VALUE This secondary XML index is useful if queries are value-based and the path is not fully specified or it includes a wildcard.
-	PROPERTY This secondary XML index is very useful for queries that retrieve one or more values from individual XML instances by using the value() method.
The primary XML index has to be created first. It can be created only on tables with a clustered primary key.


XML Indexes
- Optimizes XQuery Operations on the column
- Primary XML index must be created first, before any additional XML indexes can be created
- Table must have a clustered index.. XML column cannot be the clustured index
- Primary XML index provides cardinality estimates for the query optimizer.
https://docs.microsoft.com/en-us/sql/relational-databases/xml/xml-indexes-sql-server?view=sql-server-2017



Example:
CREATE TABLE xml_tab (
  id integer primary key,
  doc xml)
GO
CREATE PRIMARY XML INDEX xml_idx on xml_tab (doc)
GO

XML Primary Index Details
- Node table is materialized
-- Base table clustered index, plus 12 columns
-- Column metadata visible with join of sys.indexes and sys.columns
-- Clustered index on
   primary key (of base table)
   id (node_id of the node table)
-- Most of the same create/alter options as SQL Index
-- Only available on columns (not variables)
-- Space Utilization is 2-5 times original data
*/