
/*
SQL Injection
See also
QueryDataByUsingSelect 9.Dynamic SQL
SET_XREF - SET ANSI_NULLS

  
Can you generate and execute dynamic SQL in a different database than the one your code is in?
Yes, because the USE <database> command can be inserted into a dynamic SQL batch.

What are some objects that cannot be referenced in T-SQL by using variables?
Objects that you cannot use variables for in T-SQL commands include the database name in a USE statement,
the table name in a FROM clause, column names in the SELECT and WHERE clauses, and lists of literal values
in the IN() and PIVOT() functions.

The sp_executesql system stored procedure was introduced as an alternative to using the EXEC command
for executing dynamic SQL. It both generates and executes a dynamic SQL string.

The ability to parameterize means that sp_excutesql avoids simple concatenations like those used in the EXEC
statement. As a result, it can be used to help prevent SQL injection.

1. QUOTENAME
2. Dynamic SQL using EXEC
3. Dynamic SQL using sp_executesql
4. Using Output Parameters with sp_executesql
10.Examples

**************
1.QUOTENAME
**************
Syntax
QUOTENAME ( 'character_string' [ , 'quote_character' ] )

'quote_character'
Is a one-character string to use as the delimiter. Can be a single quotation mark ( ' ),
a left or right bracket ( [] ), a double quotation mark ( " ), a left or right parenthesis
 ( () ), a greater than or less than sign ( >< ), a left or right brace ( {} ) or a backtick ( ` ).
 NULL returns if an unacceptable character is supplied. If quote_character is not specified, brackets are used.
https://docs.microsoft.com/en-us/sql/t-sql/functions/quotename-transact-sql?view=sql-server-2017

**************************
2. Dynamic SQL using EXEC
**************************
EXEC is an old method and is a way Hackers use SQL Injection

--#t1
IF OBJECT_ID('tempdb..#t1') IS NOT NULL
   DROP TABLE #t1
CREATE TABLE #t1 (a INT NULL);  
INSERT INTO #t1 values (NULL),(0),(1);
DECLARE @TYPE NVARCHAR (20)
DECLARE @SQL1 NVARCHAR (MAX)
SET @SQL1 =
'SELECT * FROM #t1'  
EXEC (@SQL1)

--#t2
IF OBJECT_ID('tempdb..#t2') IS NOT NULL
   DROP TABLE #t2
CREATE TABLE #t2 (companyname varchar(20), address nvarchar(60));  
INSERT INTO #t2 values ('kodak','Temple'),('ibm','austin'),('Micro','Seattle');
DECLARE @SQL2 AS NVARCHAR(4000);
DECLARE @address nvarchar(60)
-- SET @address = N'Seattle';   /*  Normal Address */
SET @address = N'''';           /*  Gives Error unclosed quotation mark */
SET @address = N''' -- ';       /*  No error it believes the last quotation is a comment */
SET @address = N''' SELECT 1 --'; /* Simiulates what a Hacker would do to issue a SQL Command */    
SET @SQL2 =
'SELECT * FROM #t2 WHERE address = ''' + @address + '''';
EXEC (@SQL2)

***********************************
3. Dynamic SQL using sp_executesql
Syntax..
sp_executesql [ @stmt = ] statement  
[   
  { , [ @params = ] N'@parameter_name data_type [ OUT | OUTPUT ][ ,...n ]' }   
     { , [ @param1 = ] 'value1' [ ,...n ] }  
]  
***********************************

IF OBJECT_ID('tempdb..#t3') IS NOT NULL
   DROP TABLE #t3
CREATE TABLE #t3 (companyname varchar(20), address nvarchar(60));  
INSERT INTO #t3 values ('kodak','Temple'),('ibm','austin'),('Micro','Seattle');
DECLARE @SQL3 AS NVARCHAR(4000);
DECLARE @addressvalue nvarchar(60);
 
SET @SQL3 =
'SELECT * FROM #t3 WHERE address = @address';

SET @addressvalue = N'Seattle'        /*  Normal Address */
--SET @addressvalue = N''''             /*  No longer Gives Error */
--SET @addressvalue = N''' -- '         /*  No error.  Not interpreteted as comment */
--SET @addressvalue = N''' SELECT 1 --' /* No longer executes SQL Command */  
EXEC sp_executesql 
     @statement = @SQL3,
	 @params = N'@address NVARCHAR(60)',
	 @address = @addressvalue; 


***************************
4. Using Output Parameters
***************************
IF OBJECT_ID('tempdb..#t4') IS NOT NULL
   DROP TABLE #t4
CREATE TABLE #t4 (companyname varchar(20), address nvarchar(60));  
INSERT INTO #t4 values ('kodak','Temple'),('ibm','austin'),('Micro','Seattle');
DECLARE @SQLString AS NVARCHAR(4000), @outercount AS int;
SET @SQLString = N'SET @innercount = (SELECT COUNT(*) FROM #t4)';
EXEC sp_executesql
    @statement = @SQLString,
	@params = N'@innercount AS int OUTPUT',
	@innercount = @outercount OUTPUT;
SELECT @outercount AS 'RowCount';


************
EXAMPLES
************
*/

DECLARE @address AS NVARCHAR(60) = '5678 rue de 1''Abbaye';
print @address
-- Will recognize quotes as they are
SELECT QUOTENAME(@address, '''');
-- Will use default [] put brackets same as leaving blank
SELECT QUOTENAME(@address, '');
-- Will use default []
SELECT QUOTENAME(@address);
-- IF quote CHARACTER IS NOT supplied BRACKETS are used
SELECT QUOTENAME('abc[]def');  