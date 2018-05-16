/*
Stored Procedure

EXEC spFilmList 150, 180, 'star'  - Can be done after the Stored Procedure is executed
EXEC spFileList @MinLength=150, @MaxLength=180, @Title='star'  - Alternate way of writing parameters
EXEC spFileList @MaxLength=180, @Title='star'  - Uses Default Value for MinLength since it is optional 

USE Movies
GO -- Begins new batch statments
CREATE PROC spFilmList
      (
	     @MinLength AS INT = 0,     -- Providing a Default Value will automatically make the parameter optional.   You can also set the Defualt values to 'NULL'.     
		 @MaxLength AS INT
		 @Title AS VARCHAR(MAX)     -- Defines Maxium length of characters
		 @FilmCount INT OUTPUT      -- Output parmameter
	  )
AS
BEGIN  --  Not Required but nice to use (Same with END Statement)
SELECT
  FilmName,
  FilmRunMinutes
FROM 
  tblFilm
WHERE FileRunMinutes >= @MinLength  AND
      FilmRunMinutes <= @MaxLength AND
	  FilmName LIKE '%' + @Title + '%'
ORDER BY FilmName ASC
END

*/