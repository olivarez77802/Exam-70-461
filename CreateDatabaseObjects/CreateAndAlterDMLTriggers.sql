/*
  See Also:
     ModifyDataUsing_INSERT_UPDATE_DELETE.sql
	 ERROR-HANDLING.sql

  Create and Alter DML Triggers
  - Inserted and deleted tables; nested triggers; types of triggers; update functions;
    handle multiple rows in a session; performance implications of triggers

  SQL Server there are 3 types of triggers
  1. DML (Data Manipulation Language) triggers
  2. DDL triggers
  3. Logon trigger

  DML triggers are fired automatically in response to DML events(INSERT, UPDATE, DELETE)

  DML Triggers can be classified into 2 types
  1. After triggers(Sometimes called as FOR triggers)
  2. Instead of triggers

  After triggers - fires after the triggering action. The INSERT, UPDATE, and DELETE
  statements, cause an after trigger to fire after the respective statements to complete
  execution.  You can test the join between the inserted rows and the actual table, but
  only after the insert has taken place- because this is an AFTER trigger!  AFTER triggers
  can be nested - that is you can have a trigger on Table A that updates Table B.
  After triggers must use THROW or RAISEERROR commands to cause the transaction of the DML command
  to rollback.

  INSTEAD of triggers, fires instead of the triggering action.  The INSERT, UPDATE, and
  DELETE statements, causes an INSTEAD OF trigger to fire INSTEAD OF the respective 
  statement execution.

  Trigger            INSERTED or DELETED?
  -----------------  -------------------------------------------------------------------------------------------------
  Instead of Insert  DELETED table is always empty and the INSERTED table contains the newly inserted data.
  Instead of Delete  INSERTED table is always empty and the DELETED table contains the rows deleted
  Instead of Update  DELETED Table contains OLD data (before update) and Inserted table contains NEW data(Updated data) 

  DML Trigger Functions.
  You can use two functions in your trigger code to get information about what is going on:
  1. UPDATE() - You can use this function to determine whether a particular column has been referenced by 
     an insert or UPDATE statement.  Example:
	         UPDATE Sales.OrderDetails
			 SET qty = 99
			 WHERE orderid = 10249 AND productid = 16;
			 IF UPDATE(qty)
			    PRINT 'Column qty affected';
  2. COLUMNS_UPDATED() - You can use this fuction if youknow the sequence number of the column in the table.

  -- Examples
  *********************
  1. AFTER TRIGGERS
  *********************
  -------------------------
  AFTER TRIGGER - Using FOR
  --------------------------
  --
  -- The AFTER is the default type of trigger when you specify FOR.  But you can replace FOR with either AFTER or 
  -- INSTEAD OF to determine type of triggers.
  --
  CREATE TRIGGER TriggerName
  ON [dbo].[TableName]
  FOR DELETE, INSERT, UPDATE
  AS
  BEGIN
  SET NOCOUNT ON
  END
  
  Note! - When an INSERT, UPDATE, or DELETE occurs and no rows are affected, there is no point in proceeding with the trigger.
  You can improve the performance of the trigger by testing whether @@ROWCOUNT is 0 in the very first line of the trigger. 
  It must be the first line because @@ROWCOUNT will be set back to 0 by any additional statement.  When the AFTER trigger begins,
  @@ROWCOUNT will contain the number of rows affected by the outer INSERT, UPDATE, or DELETE statement.

  ---------------------------
  AFTER TRIGGER - WITHOUT FOR
  ---------------------------
  IF OBJECT_ID(N'Sales.tr_SalesOrderDetailsDML', N'TR') IS NOT NULL
     DROP TRIGGER Sales.tr_SalesOrderDetailsDML;
  GO
  CREATE TRIGGER Sales.tr_SalesOrderDetailsDML
  ON Sales.OrderDetails
  AFTER DELETE, INSERT, UPDATE
  AS
  BEGIN
    IF @@ROWCOUNT = 0 RETURN;    -- Must be first statement
	   SET NOCOUNT ON;
	   SELECT COUNT(*) AS InsertedCount FROM Inserted;
	   SELECT COUNT(*) AS DeletedCount FROM Deleted;
  END;
   
  ----------------------
  AFTER TRIGGER - INSERT
  ----------------------

  CREATE TRIGGER tr_tblEmployee_ForInsert
  ON tblEmployee
  FOR INSERT
  AS
  BEGIN
  -- inserted table is special table only used by triggers.  Only valid
  -- in the context of a TRIGGER.  It is created in memory.  The inserted
  -- table matches the number of columns of the table in the 'ON' clause
  -- or in this case table 'tblEmployee'.  Only contains the 1 row that
  -- was inserted.
     Select * from inserted

	 Declare @Id int
	 Select @Id = Id from inserted
	 INSERT INTO tblEmployeeAudit
	 VALUES ('New employee with id = ' + CAST(@Id as nvarchar(5)) + 'is addeded at ' +
	          CAST(GETDATE()) as nvarchar(20))
  END

  -----------------------
  AFTER TRIGGER - DELETE
  -----------------------
  CREATE TRIGGER tr_tblEmployee_ForDelete
  ON tblEmploye
  FOR DELETE
  AS
  BEGIN
      Declare @Id int
	  -- deleted table is a special table used by SQL to keep a copy of the table
	  -- you just deleted.  Structure of deleted table is same as table used 
	  -- with the 'ON' clause.
	  -- 
	  Select @Id = Id from deleted

	  Insert into tblEmployeeAudit
	  values ('An existing employee with Id = 'An existing employee with id = ' + 
	           Cast(@Id as nvarchar(5)) +
			   'is deleted at ' +
			   cast(GETDATE() as nvarchar(20))
			   )
  END
  https://www.youtube.com/watch?v=k0S4P-a6d5w&index=43&list=PL08903FB7ACA1C2FB

  ---------------------------------------------------------------------
  AFTER TRIGGER - UPDATE
  UPDATE - The After trigger for UPDATE event, makes use of
  both the inserted and deleted tables.  The inserted table contains the 
  updated data and the deleted table contains the old data.
  -----------------------------------------------------------------------
  CREATE TRIGGER tr_tblEmployee_ForUpdate
  on tblEmployee
  for Update
  as
  Begin
  -- deleted table contains data before update
     Select * from deleted
  -- inserted table contains data after update
	 Select * from inserted
  End

  https://www.youtube.com/watch?v=P_BREQy6bOo&list=PL08903FB7ACA1C2FB&index=44

  *********************************
  2. INSTEAD OF TRIGGERS -  INSERT 
  *********************************
  -- Used when issuing a DML command using a view that tries to alter multiple
  -- base tables.
  CREATE TRIGGGER tr_vWEmployeeDetails_InsteadofInsert
  ON vWEmployeeDetails
  Instead of Insert
  AS
  BEGIN
      Select * from inserted
	  Select * from deleted
  END
  https://www.youtube.com/watch?v=MseKoztMpoo&list=PL08903FB7ACA1C2FB&index=45

 -----------------------------
  INSTEAD OF TRIGGER - UPDATE 
 -----------------------------
  Create Trigger tr_vWEmployeeDetails_InsteadOfUpdate
  ON vWEmployeeDetails
  INSTEAD OF UPDATE
  AS
  BEGIN
       -- If EmployeeID is updated
	   if (Update(Id))
	   Begin
	      Raiseerror('Id cannot be changed', 16,1)
		  Return
	   End
	   
	   -- If DeptName is updated
	   if (Update(DeptName))
	   Begin
	      Declare @DeptId int

		  Select @DeptId = DeptId
		  from tblDepartment
		  join inserted
		  on inserted.DeptName = tblDepartment.DeptName

		  if (@DeptId is Null)
		  Begin
		     Raiseerror ('Invalid Department Name', 16, 1)
			 Return
		  End

		  Update tblEmployee set DepartmentId = @DeptId
		  from inserted
		  join tblEmployee
		  on tblEmployee.Id = inserted.id
 END

 --------------------------- 
 INSTEAD OF TRIGGER - DELETE 
 ---------------------------- 
 Create Trigger tr_vWEmployeeDetails_InsteadofDelete
 on vWEmployeeDetails
 Instead of Delete
 as
 Begin
   Delete tblEmployee
   from tblEmployee
   join deleted
   on tblEmployee.Id = deleted.Id
 End
*/