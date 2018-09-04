/* Joins
   3 types of Joins
     * INNER JOIN
     * OUTER JOIN
     * CROSS JOINS

   INNER JOINS


   JOIN XREF
   -  INNER JOIN 
          same as 'CROSS APPLY' Operator
		  same as Subquery using 'IN' Operator
		  same as subquery using 'EXISTS' Operator
   -  LEFT OUTER JOIN same as 'OUTER APPLY' Operator
   
   
   Cross Apply and Outer Apply Operator
   https://www.youtube.com/watch?v=kVogo0AbatM

   In most cases JOINS are faster that sub-queries.  However,
   in cases, where you only need a subset of records from a 
   table that you are joining with, sub-queries can
   be faster.
   https://www.youtube.com/watch?v=ZEcHC_o6OFw&list=PL08903FB7ACA1C2FB&index=47



    
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