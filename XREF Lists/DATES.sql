/* 
DATES

Data that is supposed to represent dates, people have a tendancy to use DATETIME.
DATETIME - Uses 8 bytes of storage.
DATE - Uses 3 bytes of storage.  Does not include Time
DATETIM2 - Uses 6 to 8 bytes of storage.  Provides a wider range of dates and improved
           controllable precision.
SMALLDATETIME - Uses 4 bytes of storage, recommended if it's within range.

'20070212' - Form is considered language neutral.  It is always interpreted as YMD regardless of your language.
'2007-02-12' - Is only considered langauage neutral for some DATE Types.  Recommendation is to write date in '20070212' format.

STORING DATES IN A DATETIME COLUMN
The filtered column orderdate is of a DATETIME data type representing both date and time. 
Yet the literal specified in the filter contains only a date part. When SQL Server converts
the literal to the filtered column’s type, it assumes midnight when a time part isn’t indicated. 
If you want such a filter to return all rows from the specified date, you need to ensure that you
store all values with midnight as the time.

Another important aspect of filtering date and time data is trying whenever possible to use search arguments. For example,
suppose that you need to filter only orders placed in February 2007. You can use the YEAR and MONTH functions, as in the following.

SELECT orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE YEAR(orderdate) = 2007 AND MONTH(orderdate) = 2;
However, because here you apply manipulation to the filtered column, the predicate is not considered a search argument,
and therefore, SQL Server won’t be able to rely on index ordering. You could revise your predicate as a range,
like the following.

SELECT orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE orderdate >= '20070201' AND orderdate < '20070301';
Now that you don’t apply manipulation to the filtered column, the predicate is considered a search argument,
and there’s the potential for SQL Server to rely on index ordering.

If you’re wondering why this code expresses the date range by using greater than or equal to (>=) 
and less than (<) operators as opposed to using BETWEEN, there’s a reason for this. When you are
using BETWEEN and the column holds both date and time elements, what do you use as the end value? 
As you might realize, for different types, there are different precisions. What’s more, suppose that
the type is DATETIME, and you use the following predicate:

WHERE orderdate BETWEEN '20070201' AND '20070228 23:59:59.999'

This type’s precision is three and a third milliseconds. The milliseconds part of the end point 999 
is not a multiplication of the precision unit, so SQL Server ends up rounding the value to midnight of March 1, 2007.
As a result, you may end up getting some orders that you’re not supposed to see. In short, instead 
of BETWEEN, use >= and <, and this form will work correctly in all cases, with all date and time types, 
whether the time portion is applicable or not.


Date and Time Functions
http://msdn.microsoft.com/en-us/library/ms186724(v=SQL.110).aspx

More information on Functions can be found in 
Modify Data - Work with Functions.

GETDATE is T-SQL Specific, returning the current date and time in the DATETIME data type.
CURRENT_TIMESTAMP is the same, is the same only it's the standard and hence the recommended one to use.

To get the current date, use CAST(SYSDATETIME() AS DATE).

DATEPART(month, '20120212') returns 2.  T-SQL provides the functions YEAR, MONTH, and DAY as abbreviations
to DATEPART, not requiring you to specify the 'month' in this case.

EOMONTH Function computes the respective end of the month date.  The EOMONTH(SYSDATETIME()) would return the 
end of the current month.

--- ADD and DIFF
T-SQL supports addition and difference date and time functions called DATEADD and DATEDIFF.

DATEADD(year,1,'20120212') adds one year to the specified date.
-- to add 5 days to September 1, 2011 the function would be
DATEADD(DAY, 5, '9/1/2011')

-- to subtract 5 months from September 1, 2011 the function would be
DATEADD(MONTH, -5, '9/1/2011')
DATEDIFF(day,'20110212','20120212') computes the difference in days, returning 365 days in this case.




*/
-- DATETIME data TYPE.
-- GETDATE is T-SQL Specific, returning the current date and time in SQL, your connected to a DATETIME datatype.
SELECT GETDATE()
-- CURRENT_TIMESTAMP is the same as GETDATE only its Standard( Not T-SQL), Hence it the recommended one to use.
SELECT CURRENT_TIMESTAMP
SELECT GETUTCDATE()
-- End DATETIME data type.


-- SYSDATETIME() and SYSDATETIMEOFFSET are similar, only returning the values as the more precise DATETIME2 and
-- DATETIMEOFFSET types.
SELECT SYSDATETIME()
SELECT SYSUTCDATETIME()
SELECT SYSDATETIMEOFFSET()
-- End DATETIME2, DATETIMEOFFSET types

-- Build a date from it's parts
SELECT DATEFROMPARTS(2012, 02, 12)
-- End of Month
SELECT EOMONTH(GETDATE())

-- DATEPART, DATEADD, DATEDIFF Functionsexit
Select DATEPART(weekday, '2012-08-30 19:45:31.793') -- returns 5
SELECT DATEPART(MONTH, '2012-08-30 19:45:31.793')   -- returns 8
SELECT DATENAME(weekday, '2012-08-30 19:45:31.793') -- returns Thursday
SELECT DATEADD(DAY, 20, '2012-08-30 19:45:31.793')  -- Returns 2012-09-19 19:45:31.793
SELECT DATEDIFF(MONTH, '11/30/2005', '01/31/2006')  -- Returns 2

-- https://www.youtube.com/watch?v=eYsizQVa_EU&index=27&list=PL08903FB7ACA1C2FB
