/* 
DATES

Data that is supposed to represent dates, people have a tendancy to use DATETIME.
DATATIME - Uses 8 bytes of storage.
DATE - Uses 3 bytes of storage.  Does not include Time
DATETIM2 - Usees 6 to 8 bytes of storage.  Provides a wider range of dates and improved
           controllable precision.
SMALLDATETIME - Uses 4 bytes of storage, recommended if it's within range.

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