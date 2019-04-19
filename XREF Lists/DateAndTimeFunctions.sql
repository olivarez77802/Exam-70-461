/* Date and Time Functions
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
DATEDIFF(day,'20110212','20120212') computes the difference in days, returning 365 days in this case.






*/