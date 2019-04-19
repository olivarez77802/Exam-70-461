/*
NULL XREF - Listing Ways of Handling NULLS in SQL

NULL is a mark for a missing value- Not a value in itself.  The correct usage of the term is either "NULL mark" or just "NULL".

4 Different ways of replacing a Null Value:
  A. COALESCE
  B. CASE
  C. ISNULL
  D. CONCAT - Substitutes a NULL input with an empty string (or skips the string)
See ModifyData/CombineDatasets.sql for more info. 

NULL   
https://www.w3schools.com/sql/sql_null_values.asp

What's important from a perspective of coding with T-SQL is to realize that if the database your querying supports NULLs,
their treatment if far from being trivial.   You need to carefully understand what happens when NULLs are involved in the
data your manipulating with various query constructs, like filtering, sorting, grouping, joining, or intersecting. Hence
with every piece of code you write with T-SQL, you want to ask yourself whether NULLs are possible in the data your 
interacting with.  If the answere is yes, you want to make sure you understand the treatment of NULLs in your query, and
ensure that your tests address treatment of NULLs specifically.

-- CONCATENATION
T-SQL supports two ways to concatenate strings- one with the plus(+) operator, and another with the CONCAT function.

SELECT empid, country, region, city,
  country + N',' + region + N',' + city AS location
FROM HR.Employees;

When any of the inputs is NULL, the + operator returns a NULL.  That standard behavior can be changed by turning
of a session option called 'CONCAT_NULL_YIELDS_NULL' (Not recommended).
Another option is to use the COALESCE( ) Function.  COALESCE(N',' + region,N'')  - will return an empty string when
a NULL is encountered.  Another way of doing this is to use CONCAT Function which, unlike the '+' operator, substitutes
a NULL input with an empty string.  Example CONCAT(country, N',' + region,N',' + city).

-- Using Indexes
COALESCE and ISNULL can impact performance when you are cobmining datasets; for example, with
joins or when you are filtering data.  Example: You have two tables T1 and T2 and you need to 
join them based on a match between T1.col1 and T2.col1.  The attributes do allow NULLS.  Normally,
a comparison between to NULLs yields unknown, and this causes the row to be discarded.  You want
to treat two NULLS as equal.  What some do in sucha case is use COALESCE or ISNULL to substitute
a NULL with a value that they know cannot appear in the data.  
For example, if the attributes are integers, and you know that you have only positive integers 
in your data (you can even have constraints that ensure this), you might try to use the predicate 
COALESCE(T1.col1, -1) = COALESCE(T2.col1, -1), or ISNULL(T1.col1, -1) = ISNULL(T2.col1, -1). 
The problem with this form is that, because you apply manipulation to the attributes you’re comparing, 
SQL Server will not rely on index ordering. This can result in not using available indexes efficiently.
Instead, it is recommended to use the longer form: T1.col1 = T2.col1 OR (T1.col1 IS NULL AND T2.col1 IS NULL), 
which SQL Server understands as just a comparison that considers NULLs as equal. With this form, SQL Server
can efficiently use indexing.

-- NULL when used with Predicates
SELECT empid, firstname, lastname, country, region, city
FROM HR.Employees
WHERE region <> N'WA';

The above set will return an empty result set (pretend there are regions only equal to WA and NULLS).

You have to specify 'IS NULL'.  Note! - If you said 'region = NULL' this would be false.   In SQL 
two NULLS are not consider equal to each other.   the expression NULL = NULL is, in fact, unknown—not true.
T-SQL provides the predicate IS NULL to return a true when the tested operand is NULL.
SELECT empid, firstname, lastname, country, region, city
FROM HR.Employees
WHERE region <> N'WA'
   OR region IS NULL;

-- Columns that allow NULLS
The below will work if shippeddate DID NOT allow NULLS.
SELECT orderid, orderdate, empid
FROM Sales.Orders
WHERE shippeddate = @dt;

The below logic is needed in order to get NULLS if shipped date was set up to allow NULLS.
SELECT orderid, orderdate, empid
FROM Sales.Orders
WHERE shippeddate = @dt
   OR (shippeddate IS NULL AND @dt IS NULL);


*/