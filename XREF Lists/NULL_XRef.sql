/*
NULL XREF - Listing Ways of Handling NULLS in SQL

NULL is a mark for a missing value- Not a value in itself.  The correct usage of the term is either "NULL mark" or just "NULL".

NULL   
https://www.w3schools.com/sql/sql_null_values.asp

What's important from a perspective of coding with T-SQL is to realize that if the database your querying supports NULLs,
their treatment if far from being trivial.   You need to carefully understand what happens when NULLs are involved in the
data your manipulating with various query constructs, like filtering, sorting, grouping, joining, or intersecting. Hence
with every piece of code you write with T-SQL, you want to ask yourself whether NULLs are possible in the data your 
interacting with.  If the answere is yes, you want to make sure you understand the treatment of NULLs in your query, and
ensure that your tests address treatment of NULLs specifically.

NULL's use three valued logic
1. TRUE
2. FALSE
3. UNKNOWN - You will get this when comparing two NULLs and the row is filtered out.
Note! - Two NULLS are not considered equal to each other.   You should not use region <> N'WA' or region=NULL.
T-SQL provides the predicate 'IS NULL' to return true when the tested operand is NULL.

-- Below query will return an empty set.  Since the only regions that are <> 'N'WA' are NULL.
SELECT empid, firstname, lastname, country, region, city
FROM HR.Employees
WHERE region <> N'WA';

-- Below query will return regions that are NULL
SELECT empid, firstname, lastname, country, region, city
FROM HR.Employees
WHERE region <> N'WA'
   OR region IS NULL;

4 Different ways of replacing a Null Value:
  A. COALESCE
  B. CASE
  C. ISNULL
  D. CONCAT - Substitutes a NULL input with an empty string (or skips the string)
See CombineDatasets.sql for more details.

---------------------------------------------------------------
Indexes - Misuse of COALESCE will prevent them from being used.  
---------------------------------------------------------------

Remember that when comparing two NULLs, you get unknown and the row is filtered out. So the current form of the predicate 
doesn’t address NULL inputs correctly. Some address this need by using COALESCE or ISNULL to substitute NULLs with a value
that doesn’t exist in the data normally, as in the following.

SELECT orderid, orderdate, empid
FROM Sales.Orders
WHERE COALESCE(shippeddate, '19000101') = COALESCE(@dt, '19000101');

The problem above is that even though the solution now returns the correct result—even when the input is NULL—the predicate
isn’t a search argument. This means that SQL Server cannot efficiently use an index on the shippeddate column. 
To make the predicate a search argument, you need to avoid manipulating the filtered column and rewrite the predicate
like the following:

SELECT orderid, orderdate, empid
FROM Sales.Orders
WHERE shippeddate = @dt
   OR (shippeddate IS NULL AND @dt IS NULL);

------------------
SORTING
------------------
Another tricky aspect of ordering is treatment of NULLs. Recall that a NULL represents a missing value,
so when comparing a NULL to anything, you get the logical result unknown. That’s the case even when 
comparing two NULLs. So it’s not that trivial to ask how NULLs should behave in terms of sorting. 
Should they all sort together? If so, should they sort before or after non-NULL values? Standard
SQL says that NULLs should sort together, but leaves it to the implementation to decide whether to 
sort them before or after non-NULL values. In SQL Server the decision was to sort them before non-NULLs 
(when using an ascending direction).

*/