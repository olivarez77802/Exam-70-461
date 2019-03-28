/*
Query and manage XML Data
-- Understand XML datatypes and their schemas and interop w/limitations and restrictions; implement XML Schemas
   and handling of XML data; XML data: how to handle in SQL Server and when and when not to use it, including
   XML Namespaces; import and export XML; XML indexing

<!-- Any comment -->
Syntax for comment.  Less than sign, Exclamation Mark, two dashes follow by two dashes and greater than sign.

XML was designed to describe data not to display data
  (HTML was designed to display data).
XML was designed to store and transport data.
XML was designed to be both machine and human readable.
XML is often used to separate data from presentation.

<?xml version="1.0" encoding="UTF-8"?> 
Declaration - 1st line of xml document.  It is optional, but if it appears it must be at the top.
The Declaration is also called the XML Prolog.  The XML Prolog does not have a closing tag!

<root>
  <child>
    <subchild>...</subchild>
  </child>
</root>
XML Documents will only have one root element
Root Elements are also called parent elements
XML Fragments - A document has a single root node.  A document without the root node is called a fragment.

<name>Samual Clinton</name>
tag - <name> (Start Tag) and </name> (End Tag).  Tags are case sensitive.
The tag <name> is different from the tag <Name>
Element names are case-sensitive
Element names must start with a letter or underscore
Element names cannot start with the letters xml (or XML, or Xml, etc)
Element names can contain letters, digits, hyphens, underscores, and periods
Element names cannot contain spaces
Element - Both the tag and the value 'Samual Clinton'

-- Empty XML Element.  Two forms produce identical results.
<element></element>
- or
<element /> 

<book xyz="a">
xyz- attribute name  "a" - attribute value
Attribute - specifies a single property for an element.  It consists of a 
name and a value separated by an equal sign.

XML type limitations
- XML type is not treated like character types
- Does not support comparison (except to NULL)
- No equality comparison
- No ORDER BY, GROUP BY
- No built in functions except ISNULL and COALESCE
- Cannot be used as a KEY Column
- Cannot be used in a UNIQUE Constraint
- Cannot be declared with COLLATE
-- Uses XML encodings
-- Always stored as UNICODE UCS-2

XML Schema
- Schema - Way of constraining the name of tags and order of tags.
- XML Schema used by XML data types must be in database.
- Create XML SCHEMA COLLECTION
  Requires literal schemas (literal strings or XML Variable)
- Collection name associated with XML Instance
  column, parameter, or variable
- XML Schemas are decomposed when stored.  They do not store annotations
  or comments.  If you want to store annotations or comments then you must
  store then in a separate XML Column.

When you check whether an XML Document complies with a schema, you validate the document.
A document with a predefined schema is said to be a Typed XML Document.

XML Data Type Methods
An XML data type includes five methods that accept XQuery as a parameter
1. query() method 
2. value() method 
3. exist() method
4. modify() method
5. nodes() method 

-- Query all of the Schema Collections that are defined or have been built in.
SELECT * FROM sys.xml_schema_collections
-- All of the built in Types
SELECT * FROM sys.xml_schema_types
-- Which columns use schema collection
SELECT * FROM sys.column_xml_schema_collection_usages

Example Schema Syntax
CREATE XML SCHEMA COLLECTION invcol
AS '<xs:schema ...
     targetNamespace = "urn:invoices">
	 ...
	</xs:schema>'
CREATE TABLE Invoices (
int id IDENTITY PRIMARY KEY,
       invoice XML(invcol)
)

Example of Loading a Schema Collection from a File
DECLARE @x XML
SET @x = (
SELECT * FROM OPENROWSET(
 BULK 'C:\invoice.xsd',
        SINGLE_BLOB
) AS x

-- Sample schema of C:\invoice.xsd
-- Notice targetNamespace will be used in XML File to connect schema.
-- xmlns - short for XML Namespace, define the elements and data types used in this schema
-- xsd, tns - short hand for the namespaces, prefixes xsd, tns can be used in schema to 
--            refer to the namespace.
-- elementFormDefault="qualified"  - indicates that any elements used by the XML instance document
--                                   which were declared must be namespace qualified.
<xsd:schema xmlns: xsd="http://www.w3.org/2001/XMLSchema"
            xmlns:tns="urn:www-company-com:invoices"
			targetNamespace="urn:wwww-company.com:invoices"
			elementFormDefault="qualified">
 
-- Load XML Schema from a file
USE Development
DECLARE @x XML
SET @x = 
(
SELECT * FROM OPENROWSET(
     BULK 'C:\Users\olivarez77802\Documents\SQL Server Management Studio\Exam70-461\WorkWithData\invoice.xsd',
	   SINGLE_BLOB) AS x
)


-- Example of using variable to create an XML Schema Collection
CREATE XML SCHEMA COLLECTION InvoiceType AS @x
GO


-- Using SCHEMA Collection
-- 'document' restricts to documents only (one root node) versus Fragments(more than one root element)
CREATE TABLE invoice_docs (
invoiceid INTEGER PRIMARY KEY IDENTITY,
invoice XML(document InvoiceType)
)
GO

-- Check schema information
SELECT * FROM sys.xml_schema_collections
SELECT * FROM sys.xml_schema_namespaces
SELECT * FROM sys.column_xml_schema_collection_usages

-- Insert an Invoice
INSERT INTO invoice_docs(invoice)
SELECT * FROM OPENROWSET(
BULK 'C:\Users\olivarez77802\Documents\SQL Server Management Studio\Exam70-461\WorkWithData\invoice.xml',
SINGLE_BLOB) AS x
GO

-- If you try to Insert will give error because it doesn't follow Schema Definition
USE Development
INSERT INTO invoice_docs(invoice)
SELECT * FROM OPENROWSET(
BULK 'C:\Users\olivarez77802\Documents\SQL Server Management Studio\Exam70-461\WorkWithData\invoice2.xml',
SINGLE_BLOB) as x
GO

-- Sku number has to be between 100 and 999 
USE DEVELOPMENT
insert invoice_docs values('
<inv:Invoice xmlns:inv="urn:www-company-com:invoices">
  <inv:InvoiceID>1000</inv:InvoiceID>
  <inv:CustomerName>Jane Smith</inv:CustomerName>
  <inv:LineItems>
    <inv:LineItem>
      <inv:Sku>1134</inv:Sku>
      <inv:Description>ColaK/inv:Description>
      <inv:Price>0.95</inv:Price>
    </inv:LineItem>
  </inv:LineItems>
</inv:Invoice>
')

-- Errors because it does not have root element
insert invoice_docs values('
   <inv:LineItem xmlns:inv="urn:www-company-com:invoices">
      <inv:Sku>124</inv:Sku>
	  <inv:Description>Cola</inv:Descripition>
	  <inv:Price>0.95</inv:Price>
   </inv:LineItem>
   ')

-- check schema information
SELECT * FROM sys.xml_schema_collections
SELECT * FROM sys.xml_schema_namespaces
SELECT * FROM sys.xml_schema_elements
SELECT * FROM sys.xml_schema_attributes
SELECT * FROM sys.xml_schema_types
SELECT * FROM sys.column_xml_schema_collection_usages
SELECT * FROM sys.parameter_xml_schema_collection_usages

USE Development
DECLARE @x XML
SET @x = 
(
SELECT * FROM OPENROWSET(
     BULK 'C:\Users\olivarez77802\Documents\SQL Server Management Studio\Exam70-461\WorkWithData\invoice_v2.xsd',
	   SINGLE_BLOB) AS x
)

-- Adding _v2 schema to existing collection
ALTER XML SCHEMA COLLECTION InvoiceType ADD @x
GO

-- Insert into Schema that accepts V1 and V2 schemas 
USE Development
INSERT INTO invoice_docs(invoice)
SELECT * FROM OPENROWSET(
BULK 'C:\Users\olivarez77802\Documents\SQL Server Management Studio\Exam70-461\WorkWithData\invoice3.xml',
SINGLE_BLOB) AS x
GO

***********************************************************************************
XQUERY Tutorial
XQUERY is to XML what SQL is to databases.
https://www.w3schools.com/xml/xquery_intro.asp
In XQuery, there are seven kinds of nodes:
1. element
2. attribute
3. text
4. namespace
5. processing-instruction
6. comment
7. document (root)

XQuery Syntax Rules
1. XQuery is case sensitive
2. XQuery elements, attributes, and variables must be valid XML Names
3. An XQuery string value can be single or double quotes
4. An XQuery variable is defined with a $ followed by a name, e.g. $bookstore
5. XQuery comments are delimited by (: and :), e.g. (: XQuery Comment :)

XQuery Conditional Expressions
"If-Then-Else" expressions are allowed in XQuery.
Example:
for $x in doc("books.xml")/bookstore/book
return if ($x/@category="children")
then <child>{data($x/title)}</child>
else <adult>{data($x/title)}</adult>

**************************************************************************************
XPath Syntax
https://www.w3schools.com/xml/xpath_syntax.asp
XPath uses path expressions to select nodes or node-sets in an XML Document.  
Selecting Nodes:
1. nodename  - selects all nodes with the name "nodename"
2. /         - selects from the root node
3. //        - selects nodes in the document from the current node that match the selection
               no matter where they are.
4. .         - The period '.' selects the current node
5. ..        - The double '..' selects the parent of the current node
6. @         - Selects attributes

Selecting Unknown Nodes
XPath Wildcards can be used to select unknow XML Nodes
*         - Matches any Element   node
@*        - Matches any Attribute node
node()    - Matches any Node      of any kind 
comment() - Matches amy comment   nodes
processing-instruction() - Matches any processing instruction node
text()    - Matches any Text      node (or nodes without any tags). 


****************************************************************************************

USE Development
SELECT *
FROM invoice_docs

SELECT Invoice 
FROM invoice_docs

SELECT I.InvoiceID
FROM invoice_docs as I

USE Development
SELECT invoice.query('
(: this is a valid XQuery :)
*
')
FROM invoice_docs

-- XQuery Language Reference
-- https://docs.microsoft.com/en-us/sql/xquery/xquery-language-reference-sql-server?view=sql-server-2017
USE Development
SELECT invoice.query('
(: this is a valid XQuery :)
declare namespace inv="urn:www-company-com:invoices";
/inv:Invoice/inv:InvoiceID
')
FROM invoice_docs



XML Indexes
The XML data type is actually a large object type.  There can be up to 2GB of
data in every single column value.  Scanning through XML data sequentially is
not a very efficient way of retrieving a simple scalar value.  You can index XML 
columns with specialized XML indexes.  The first index you create on an XML column
is the primary XML index.  After creating the primary XML index, you can create up
to three other types of secondary XML indexes:
1. PATH - This secondary index is useful if your queries specify path expressions.
2. VALUE- This secondary index is useful if your queries are value-based.
3. PROPERTY - This secondary index is useful for queries that retrieve one or more values
              from individual XML instances.


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

XML Tutorial
https://www.w3schools.com/xml/default.asp

XML Schema Tutorial
https://www.w3schools.com/xml/schema_intro.asp


XML Basics
https://www.youtube.com/watch?v=qhBdS-JGZmk

XML Basics for Beginners
https://www.youtube.com/watch?v=nyk8QO08grM

Microsoft XML
https://docs.microsoft.com/en-us/sql/relational-databases/xml/xml-data-sql-server?view=sql-server-2017

Load XML Data
https://docs.microsoft.com/en-us/sql/relational-databases/xml/load-xml-data?view=sql-server-2017

Import and Export of XML Data
https://docs.microsoft.com/en-us/sql/relational-databases/import-export/examples-of-bulk-import-and-export-of-xml-documents-sql-server?view=sql-server-2017

XML Schema
https://www.youtube.com/watch?v=cibKLYjrCjk

Microsoft XML Schema
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-xml-schema-collection-transact-sql?view=sql-server-2017

Microsoft XML Index
https://docs.microsoft.com/en-us/sql/t-sql/statements/create-xml-index-transact-sql?view=sql-server-2017

XML Datatypes and Columns
https://docs.microsoft.com/en-us/sql/relational-databases/xml/xml-data-type-and-columns-sql-server?view=sql-server-2017

Using XML and XQuery Effectively with SQL Server
https://app.pluralsight.com/library/courses/sql-server-xml/table-of-contents

BULK INSERT
https://docs.microsoft.com/en-us/sql/t-sql/statements/bulk-insert-transact-sql?view=sql-server-2017

RAW, AUTO, PATH
Flavors of 'FOR XML':
1. XML RAW -  Element name is named 'row'
2. XML AUTO - Table names are your Elements
3. XML PATH - Looks more like traditional XML with 'row' as ROOT and Table Columns are child elements.
4. XML EXPLICIT - Included for Backward compatiblity only.

EXPLICIT and PATH options - You can manually define the XML returned.  With these two options,
you have total control of the XML returned.  The PATH mode uses standard XML XPATH expressions
to define the elements and attributes of the XML you are creating.

In PATH mode, column names and aliases serve as XPath expressions. XPath expressions define the 
path to the element in the XML generated.  Path is expressed in a heirarchial way; levels are 
delimited with the slash (/) character.   By default, every column becomes an element; if you
want to generate attribute-centric XML, prefix the alias name with the '@' characters.
Example:

Here is an example of a simple XPATH query.

SELECT Customer.custid AS [@custid],
 Customer.companyname AS [companyname]
FROM Sales.Customers AS Customer
WHERE Customer.custid <= 2
ORDER BY Customer.custid
FOR XML PATH ('Customer'), ROOT('Customers');

The query returns the following output.

<Customers>
  <Customer custid="1">
    <companyname>Customer NRZBB</companyname>
  </Customer>
  <Customer custid="2">
    <companyname>Customer MLTDN</companyname>
  </Customer>
</Customers>

*/
USE AdventureWorks2014
-- Auto - Automatically; Defaults to type nvarchar
SELECT TOP 5 *
FROM HumanResources.Employee
FOR XML Auto
-- Type set it to XML DataType
SELECT TOP 5 *
FROM HumanResources.Employee
FOR XML Auto, TYPE

-- Elements ...Nice format to show Elements.. Each column represented as Elements
SELECT TOP 5 *
FROM HumanResources.Employee
FOR XML Auto, TYPE, ELEMENTS

-- Adds Root Element
SELECT TOP 5 *
FROM HumanResources.Employee
FOR XML Auto, TYPE, ELEMENTS, ROOT

-- Put your own name on the ROOT
SELECT TOP 5 *
FROM HumanResources.Employee
FOR XML Auto, TYPE, ELEMENTS, ROOT('RootName')

-- Modify Column names
SELECT BusinessEntityID AS myBusinessEntityID
      ,OrganizationNode as myorgnode
      ,LoginID AS myLoginID
	  ,JobTitle AS myJobTitle
	  ,BirthDate AS myBirthDate
FROM HumanResources.Employee as Employees
FOR XML AUTO, TYPE, ELEMENTS, Root('myRoot')

-- RAW('myEmployees') Will override 'AS Employees'
-- When you use RAW keyword and you have NULL Data the element is skipped
-- Null data is also skipped using AUTO
-- Look at OrganizationNode to see example of Null Data being skiped using
-- both RAW and AUTO
SELECT BusinessEntityID AS myBusinessEntityID
      ,OrganizationNode as myorgnode
      ,LoginID AS myLoginID
	  ,JobTitle AS myJobTitle
	  ,BirthDate AS myBirthDate
FROM HumanResources.Employee as Employees
FOR XML RAW('myEmployees'), TYPE, ELEMENTS, Root('myRoot')

-- XML Namespaces
-- https://docs.microsoft.com/en-us/sql/relational-databases/xml/add-namespaces-to-queries-with-with-xmlnamespaces?view=sql-server-2017
--
WITH XMLNAMESPACES ('uri' as ns1)  
SELECT ProductID as 'ns1:ProductID',  
       Name      as 'ns1:Name',   
       Color     as 'ns1:Color'  
FROM Production.Product  
WHERE ProductID=316 or ProductID=317  
FOR XML RAW ('ns1:Prod'), ELEMENTS  

--- Example of doing a Bulk Import
--- SINGLE_BLOB - Tells SQL Server to figure out the encoding, SINGLE_BLOB avoids encoding problems.
USE Development
INSERT INTO T(XmlCol)  
SELECT * FROM OPENROWSET(  
   BULK 'C:\Users\olivarez77802\Documents\SQL Server Management Studio\Exam70-461\WorkWithData\xmlresult.xml',  
   SINGLE_BLOB) AS x;  


-----
DECLARE @X AS XML
SET @X = N'
<CustomersOrders>
 <Customer custid="1">
  <!-- Comment 111 -->
  <companyname>Customer NRZBB</companyname>

  '