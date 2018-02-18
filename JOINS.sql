/* Joins
   3 types of Joins
     * INNER JOIN
     * OUTER JOIN
     * CROSS JOINS

   INNER JOINS
*/
SELECT TOP 1000 PERS.BusinessEntityID
      ,[PersonType]
      ,[NameStyle]
      ,[Title]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[Suffix]
	  ,PHON.PhoneNumber
  FROM [AdventureWorks2014].[Person].[Person] AS PERS
  INNER JOIN Person.PersonPhone AS PHON
  ON PERS.BusinessEntityID = PHON.BusinessEntityID