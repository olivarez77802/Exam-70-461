/*
SQL Injection

1. QUOTENAME
10.Examples

**************
QUOTENAME
**************
Syntax
QUOTENAME ( 'character_string' [ , 'quote_character' ] )

'quote_character'
Is a one-character string to use as the delimiter. Can be a single quotation mark ( ' ),
a left or right bracket ( [] ), a double quotation mark ( " ), a left or right parenthesis
 ( () ), a greater than or less than sign ( >< ), a left or right brace ( {} ) or a backtick ( ` ).
 NULL returns if an unacceptable character is supplied. If quote_character is not specified, brackets are used.
https://docs.microsoft.com/en-us/sql/t-sql/functions/quotename-transact-sql?view=sql-server-2017

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
-- IF quote CHARACTER IS NOT supplied brackets ARE used
SELECT QUOTENAME('abc[]def');  