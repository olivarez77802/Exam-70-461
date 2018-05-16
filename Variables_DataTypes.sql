/*
Variables and Data Types
Data Types
https://docs.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql?view=sql-server-2017


DECLARE @MyDate  DATETIME

SET @MyDate = '1980-01-01
SET @NumFilms = (SELECT COUNT(*) FROM tblFilm WHERE FilmReleaseDate >= @MyDate)

*/