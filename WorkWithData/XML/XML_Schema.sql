/* XML Schema
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
A document with a predefined schema is said to be typed XML Document.

Instructions to review a Schema.
1. Open invoice.xsd in Visual Studio
2. Double click invoice.xsd .. Notice targetNamespace="urn:www.company-com:invoices"
3. Open invoice.xml... Notice Invoice xmlns:inv="urn:wwww-company.com:invoices"
4. Could not Bulk Insert - Believe this was a permission issue.  I had to manually Hardcode XSD and XML
5. Load XSD .. You can then use commands to see collection
6. Once Loaded the Insert will fail if it doesn't meet XSD criteria.

Create an XSD File
https://www.youtube.com/watch?v=22d3PN_l-Wg

*/

-- Query all of the Schema Collections that are defined or have been built in.
SELECT * FROM sys.xml_schema_collections
-- All of the built in Types
SELECT * FROM sys.xml_schema_types
-- Which columns use schema collection
SELECT * FROM sys.column_xml_schema_collection_usages

-- Example Schema Syntax
CREATE XML SCHEMA COLLECTION invcol
AS '<xs:schema ...
     targetNamespace = "urn:invoices">
	 ...
	</xs:schema>'
CREATE TABLE Invoices (
int id IDENTITY PRIMARY KEY,
       invoice XML(invcol)
)

-- Example of Loading a Schema Collection from a File
DECLARE @x XML
SET @x = (
SELECT * FROM OPENROWSET(
-- BULK 'C:\invoice.xsd'
 BULK 'C:\Users\Jesse-Olivarez\Documents\Repositories\Exam-70-461\WorkWithData\XML\invoice.xsd',
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
--USE Development
USE JesseTest
 --    BULK 'C:\Users\olivarez77802\Documents\SQL Server Management Studio\Exam70-461\WorkWithData\invoice.xsd',
DECLARE @x XML
SET @x = 
--(
--SELECT * FROM OPENROWSET(
--	-- BULK 'C:\Users\Jesse-Olivarez\Documents\Repositories\Exam-70-461\WorkWithData\XML\invoice.xsd',
--	-- BULK 'C:\Users\Jesse-Olivarez\Documents\Repositories\Exam-70-461\WorkWithData\XML\invoice.xsd',
--	   BULK 'C:\Users\Jesse-Olivarez\Documents\invoice.xsd',
--	   SINGLE_BLOB) AS x
--) 
N'
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:tns="urn:www-company-com:invoices"
         targetNamespace="urn:www-company-com:invoices"
         elementFormDefault="qualified">

	<!-- named typedefs and element decls -->
	<xsd:simpleType name="skuType">
		<xsd:restriction base="xsd:integer">
			<xsd:minInclusive value="100" />
			<xsd:maxInclusive value ="999" />
		</xsd:restriction>
	</xsd:simpleType>

	<xsd:complexType name="LineItem">
		<xsd:sequence>
			<xsd:element name="Sku" type="tns:skuType"/>
			<xsd:element name="Description" type="xsd:string"/>
			<xsd:element name="Price" type="xsd:double"/>
		</xsd:sequence>
	</xsd:complexType>

	<xsd:complexType name="LineItems">
		<xsd:sequence>
			<xsd:element name="LineItem" type="tns:LineItem"/>
		</xsd:sequence>
	</xsd:complexType>

	<xsd:complexType name="Invoice">
		<xsd:sequence>
			<xsd:element name="InvoiceID" type="xsd:string"/>
			<xsd:element name="CustomerName" type="xsd:string"/>
			<xsd:element name="LineItems" type="tns:LineItems"/>
		</xsd:sequence>
	</xsd:complexType>

	<xsd:element name="Invoice" type="tns:Invoice"/>
</xsd:schema>
';


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
insert invoice_docs values('
<inv:Invoice xmlns:inv="urn:www-company-com:invoices" >
 <inv:InvoiceID>1000</inv:InvoiceID>
 <inv:CustomerName>Jane Smith</inv:CustomerName>
 <inv:LineItems>
   <inv:LineItem>
     <inv:Sku>134</inv:Sku>
     <inv:Description>Cola</inv:Description>
	   <inv:Price>0.95</inv:Price>
   </inv:LineItem>
 </inv:LineItems>
</inv:Invoice>')


--INSERT INTO invoice_docs(invoice)
--SELECT * FROM OPENROWSET(
---- BULK 'C:\Users\olivarez77802\Documents\SQL Server Management Studio\Exam70-461\WorkWithData\invoice.xml',
--BULK 'C:\Users\Jesse-Olivarez\Documents\Repositories\Exam-70-461\WorkWithData\XML\invoice.xml',
--SINGLE_BLOB) AS x
GO

-- If you try to Insert will give error because it doesn't follow Schema Definition
--USE Development
--INSERT INTO invoice_docs(invoice)
--SELECT * FROM OPENROWSET(
--BULK 'C:\Users\olivarez77802\Documents\SQL Server Management Studio\Exam70-461\WorkWithData\invoice2.xml',
--SINGLE_BLOB) as x
--GO

-- Sku number has to be between 100 and 999 
-- USE DEVELOPMENT
USE JesseTest
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
