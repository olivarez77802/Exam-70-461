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
<<<<<<< HEAD
tag (or MetaData) - <name> (Start Tag) and </name> (End Tag)
=======
tag - <name> (Start Tag) and </name> (End Tag).  Tags are case sensitive.
The tag <name> is different from the tag <Name>
Element names are case-sensitive
Element names must start with a letter or underscore
Element names cannot start with the letters xml (or XML, or Xml, etc)
Element names can contain letters, digits, hyphens, underscores, and periods
Element names cannot contain spaces
>>>>>>> d116f2fa07b1848aff4ea4bad4b761257bfabb60
Element - Both the tag and the value 'Samual Clinton'

-- Empty XML Element.  Two forms produce identical results.
<element></element>
- or
<element />   or <element Gender="M" Age="40" />

<book xyz="a">
xyz- attribute name  "a" - attribute value
Attribute - specifies a single property for an element.  It consists of a 
name and a value separated by an equal sign.


XQUERY Tutorial
https://www.w3schools.com/xml/xquery_intro.asp
See \Exam70-461\WorkWithData\XML\XQuery.sql

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
-- You can also include comments in your XQuery expressions. 
-- The syntax for a comment is text between parentheses and colons: (: this is a comment :). 
-- XQuery is a standard language for browsing XML instances and returning XML.
-- It is much richer than XPathexpressions, an older standard, which you can use for simple navigation only.
-- With XQuery, you can navigate as with XPath; however, you can also loop over nodes, 
-- shape the returned XML instance, and much more.
--
USE Development
SELECT invoice.query('
(: this is a valid XQuery :)
declare namespace inv="urn:www-company-com:invoices";
/inv:Invoice/inv:InvoiceID
')
FROM invoice_docs





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

*/
USE AdventureWorks2014
-- RAW - Every row is under a signal element named 'row'.
SELECT TOP 5 *
FROM HumanResources.Employee
FOR XML Raw

-- Auto - Automatically; Defaults to type nvarchar.  AUTO gives you nice XML Documents with nested elements.
SELECT TOP 5 *
FROM HumanResources.Employee
FOR XML Auto

-- ELEMENTS - Can be used with AUTO and RAW to give you elements.
SELECT TOP 5 *
FROM HumanResources.Employee
FOR XML Raw, ELEMENTS 
SELECT TOP 5 *
FROM HumanResources.Employee
FOR XML AUTO, ELEMENTS 

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

-- Modify Column names, Modify Root Name
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
-- Notice!! WITH XMLNAMESPACES is put before the 'SELECT'.
--
WITH XMLNAMESPACES ('uri' as ns1)  
SELECT ProductID as 'ns1:ProductID',  
       Name      as 'ns1:Name',   
       Color     as 'ns1:Color'  
FROM Production.Product  
WHERE ProductID=316 or ProductID=317  
FOR XML RAW ('ns1:Prod'), ELEMENTS  
--
-- Note!!  ORDER BY Clause is Very Important!  Without 'ORDER BY' Clause the order of elements
--         is unpredicatable.  Note that the 'ORDER BY' Clause is after 'FROM' and before 'FOR XML'
-- Also, the listing of the columns in the SELECT Statement is also important.  SQL uses column order 
-- to determine the nesting of elements.
-- You might be vexed by the fact that you have to take care of column order; in a relation,
-- the order of columns and rows is not important. Nevertheless, you have to realize that the
-- result of your query is not a relation; it is text in XML format, and parts of your query 
-- are used for formatting the text.
--
WITH XMLNAMESPACES ('uri' as ns1)  
SELECT ProductID as 'ns1:ProductID',  
       Name      as 'ns1:Name',   
       Color     as 'ns1:Color'  
FROM Production.Product  
ORDER BY 'ns1:ProductID'
FOR XML RAW ('ns1:Prod'), ELEMENTS 
--
--  The PATH mode uses standard XML XPath expressions to define the elements and attributes
--  of the XML you are creating.
-- 
--  PATH - In PATH mode, column names and aliases serve as XPath expressions.
--  XPath expressions define the path to the element in the XML generated. 
--  Path is expressed in a hierarchical way; levels are delimited with the slash (/) character. 
--  BY default, every column becomes an element; if you want to generate attribute-centric XML, 
--  prefix the alias name with the “at” (@) character.  Quoted from Safari Books.
--
--  XML XPATH
--  https://www.w3schools.com/xml/xml_xpath.asp
--
SELECT TOP 5 *
FROM HumanResources.Employee
FOR XML PATH 

--- Example of doing a Bulk Import
--- SINGLE_BLOB - Tells SQL Server to figure out the encoding, SINGLE_BLOB avoids encoding problems.
USE Development
INSERT INTO T(XmlCol)  
SELECT * FROM OPENROWSET(  
   BULK 'C:\Users\olivarez77802\Documents\SQL Server Management Studio\Exam70-461\WorkWithData\xmlresult.xml',  
   SINGLE_BLOB) AS x;  
