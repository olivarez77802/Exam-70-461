/*
JSON used in SQL

JSON is used when you have data that you want to store in your database where the schema may not be known in advance
or it may vary significantly,  it is not pratical to design a table for the data.   JSON is a semi-structured data
interchange format.

JSON - JavaScript Object Notation.  Lightweight data-interchange format.  Stores data and is Human readable. It is 
Language Independent.

JSON is:
- A collection of name-value pairs. Delimited by braces and commas
- Store mulitple different types of data as a Hierarchy
- Contains an array of values or objects.  [JSON Array]  , {JSON Object}, "name" : value
- Value can be a number, string, boolean, array ([ ]), object { } or null

Advantages of JSON
1. Good Performance
2. Much lighter than other data exchange formats
3. JavaScript native support.

Uses nvarchar(max) data type.  Stores JSON documents up to 2GB in size.
If your JSON < 8kb it is recommended to have NVARCHAR(4000).

https://learn.microsoft.com/en-us/sql/relational-databases/json/json-data-sql-server?view=sql-server-ver16


Convert JSON collections to a rowset

You don't need a custom query language to query JSON in SQL Server. To query JSON data, you can use standard T-SQL. If you must create a query or report on JSON data, 
you can easily convert JSON data to rows and columns by calling the OPENJSON rowset function. For more information, see Convert JSON Data to Rows and Columns with 
OPENJSON (SQL Server).

1. Query JSON Documents

2. Convert Table Data into JSON

3. Importing and Parsing JSON
3.a  - Importing JSON Files from Disk using OPENROWSET
3.b  - Importing JSON Objects Directly from a String using OPENJSON


4. Lax & Strict Mode


Temporal Tables
https://learn.microsoft.com/en-us/sql/relational-databases/tables/temporal-tables?view=sql-server-ver16
 - Temporal Tables were introduced in ANSI SQL 2011
 - Provide information about data in a table
 * At any point in time
 * Instead of what's available now
 * Like a window into your data's past
 * Critical feature to audit SQL Server data

Benefits of using Temporal Tables
- Auditing data changes and performing data forensices
- Reconstructing state of the data as of any date
- Calculating trends over time
- Maintaining a slowly changing dimension for decision support applications
- Recovering from accidental data loss

System Versioned Tables
- Temporal Table
* Keeps the current data
* Just like your normal tables
* Has few additional fields
* Period columns
* Period of validity

- History Table
* Keeps previous values of the data
* With an entry per each change
* Each change having a period of validity
* Used to retrieve value of a row for a period
* Changes are stored automatically

Creating Temporal Tables
- Anonymous history table
- Default history table
- user-defined history table

Create Table in usual manner.  It will then create an additonal table
called dbo.PostsTemporal

CREATE TABLE Posts (

)
WITH
  (
    SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.PostsHistory)
  );


Selecting Data from Temporal Tables
- AS OF <datatime>
- FROM <startdatetime> TO <enddatetime>
- BETWEEN <startdatetime> AND <enddatetime>
- CONTAINED IN (<startdatetime> , <enddatetime>
- ALL

Example:
SELECT Id, Score, Title, CreationDate, OwnerUserId
FROM PostsTemporaral
FOR SYSTEM_TIME AS OF '2019-09-16 20:05:45'
WHERE Id=9850


/*
1.  Querying JSON Documents  - Query JSON Tables that contain JSON Data 
JSON_VALUE (expression,path)

JSON_VALUE(jsonData, '$.employee.birth')
- Retrieves a scalar value, like numbers or text

JSON_Query (expression, path)
- Returns an object, an array, or another JSON document

JSON_MODIFY()
- Update a value within a JSON Document

ISJSON()
- Checks to see if text has a valid JSON Format or structure



*/

/*
2.  Convert Table data into JSON
For JSON PATH - Defines the structure of your JSON string
For JSON AUTO - Structure of your JSON string created automatically

Examples
*/
USE FAMISMOD
SELECT TOP 3 FBVBCAMPUSCD AS [main.CC],
FBVBFISCALYY AS [main.FY], 
FBCAMPUSNAME AS [main.CAMPNM]
FROM dbo.FRSTables AS main
WHERE 
FBVBVOTBLTYPE = 'FZ' AND
FBVBFISCALYY = 2022
-- FOR JSON PATH
-- FOR JSON AUTO
-- FOR JSON PATH, ROOT('LEVEL1');



/*
3.a  - Importing JSON Files from Disk using OPENROWSET


OPENROWSET
Functions used for reading data from many sources
- BULK IMPORT
- Read JSON files from disk or network
- Returns a table with a single column
  * Bulk
  * Loads entire file content as a text value

SYNTAX:
OPENROWSET
( { 'provider_name' 
    , { 'datasource' ; 'user_id' ; 'password' | 'provider_string' }
    , {   <table_or_view> | 'query' }
   | BULK 'data_file' ,
       { FORMATFILE = 'format_file_path' [ <bulk_options> ]
       | SINGLE_BLOB | SINGLE_CLOB | SINGLE_NCLOB }
} )

Provider name examples are Microsoft.Jet.OLEDB.4.0, SQLNCLI, or MSDASQL.
Data source can be file path C:\SAMPLES\Northwind.mdb' for Microsoft.Jet.OLEDB.4.0 provider, or connection string Server=Seattle1;Trusted_Connection=yes; for SQLNCLI provider.


Example:
DECLARE @JSONFILE VARCHAR (MAX);
SELECT @JSONFILE = BulkColumn
FROM OPENROWSET (BULK 'C:\Documents\jsonfile.json', SINGLE_CLOB) as j;

PRINT @JSONFILE;

IF (ISJSON(@JSONFILE)=1) PRINT 'It is valid JSON'


3.b  - Importing JSON Objects Directly from a String using OPENJSON

OPENJSON
- Function used to parse JSON text
* Returns objects and properties
* As rows and columns

Rowset view over a JSON Document

Explicitly specifies columns
* Paths used to populate each column

Use OPENJASON in the FROM clause
* Returns a set of rows
* Like a table, view, or table-valued function

*/

DECLARE @json NVARCHAR(MAX);

SET @json = N'[
  {"id": 2, "info": {"name": "John", "surname": "Smith"}, "age": 25},
  {"id": 5, "info": {"name": "Jane", "surname": "Smith"}, "dob": "2005-11-04T12:00:00"}
]';


SELECT *
FROM OPENJSON(@json) WITH (
    id INT 'strict $.id',
    firstName NVARCHAR(50) '$.info.name',
    lastName NVARCHAR(50) '$.info.surname',
    age INT,
    dateOfBirth DATETIME2 '$.dob'
    );

/*
Example 2
*/
DECLARE @JSON2 VARCHAR(1000);  
SET @JSON2 = '[ {"CC": "00", "FY": "2022", "CAMPNM": "MASTER CAMPUS" },
               {"CC": "01", "FY": "2022", "CAMPNM": "SYSTEM ADMIN & GENERAL OFFICES" },
               {"CC": "02", "FY": "2022", "CAMPNM": "TEXAS A&M UNIVERSITY" } 
             ]';

SELECT * 
FROM OPENJSON(@JSON2)
WITH (
  CC VARCHAR(02),
  FY VARCHAR (04),
  CAMPNM VARCHAR (30)
  ); 

/*
4. Lax and Strict Mode
Used in PATH to indicate how to handle the missing properties
Strict requires the property to be available in the JSON text or an error is raised
Lax will not raise an error if the property is not available.  Default mode is lax.

- strict$ - Will raise an error because Post.Badges does not exist
JSON_VALUE(Post_json, 'strict$.Post.Badges')

- lax$ - Will not raise an erro even though Comments does not exist
JSON_VALUE(Post_json, 'lax$.Post.Comments')

*/

  