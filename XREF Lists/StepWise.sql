/*
Step Wise Refinement
- Sometimes it may be better to do Step Wise Refinement when writing SQL, allowing you to get a better view of the data

1.  DISTINCT (Do a GROUP BY and ORDER BY first, since it will do this automatically)


***************************************************************************
DISTINCT (Does remove duplicates)
***************************************************************************

Note! - The bad thing about this method is that you cannnot bring in other supplemental fields, same short coming as GROUP BY
Think of the logical order of SQL (FROM, WHERE,GROUP BY,HAVING,SELECT,ORDER BY).  When you do a DISTINCT SQL in the background 
basically has to do an implicit 'GROUP BY' and 'ORDER BY'.  So it makes sense the columns are limited to what would be listed in 
the 'GROUP BY' and 'ORDER BY'.   Before using DISTINCT it may be best to write query using GROUP BY first and then change to DISTINCT.


*/
