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




*/