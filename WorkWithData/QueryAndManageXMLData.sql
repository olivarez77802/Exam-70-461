/*
Query and manage XML Data
-- Understand XML datatypes and their schemas and interop w/limitations and restrictions; implement XML Schemas
   and handling of XML data; XML data: how to handle in SQL Server and when and when not to use it, including
   XML Namespaces; import and export XML; XML indexing

<!-- Any comment -->
Syntax for comment.  Less than sign, Exclamation Mark, two dashes follow by two dashes and greater than sign.

XML was designed to describe data not to display data
  (HTML was designed to display data).

<?xml version="1.0" encoding="UTF-8"?> 
Declaration - 1st line of xml document.  It is optional, but if it appears it must be at the top.

<root>
  <child>
    <subchild>...</subchild>
  </child>
</root>
XML Documents will only have one root element
Root Elements are also called parent elements

<name>Samual Clinton</name>
tag - <name> (Start Tag) and </name> (End Tag)
Element - Both the tag and the value 'Samual Clinton'

<book xyz="a">
xyz- attribute name  "a" - attribute value
Attribute - specifies a single property for an element.  It consists of a 
name and a value separated by an equal sign.

XML Schema
Schema - Way of constraining the name of tags and order of tags.

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
USE Development
INSERT INTO T(XmlCol)  
SELECT * FROM OPENROWSET(  
   BULK 'C:\Users\olivarez77802\Documents\SQL Server Management Studio\Exam70-461\WorkWithData\xmlresult.xml',  
   SINGLE_BLOB) AS x;  
