/*
INSERT INTO

Had to learn how to refresh intellisense in order for the new tables to get recognized.
https://stackoverflow.com/questions/1362531/sql-server-invalid-object-name-but-tables-are-listed-in-ssms-tables-list


*/
USE DEVELOPMENT
/*
Insert a record into dbo.ZIPS
*/

INSERT INTO ZIPS ([ZIP-FROM],[ZIP-THRU], [FY-KEY])
VALUES (75701, 75703, 721);
SELECT * FROM dbo.ZIPS

/*
Copy the dbo.ZIPS Table to dbo.ZIP2
*/
USE Development
INSERT INTO dbo.ZIPS2
SELECT * FROM dbo.ZIPS

/*
Now check INSERT
*/
SELECT * FROM dbo.ZIPS2


