/*
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
  execution.

  INSTEAD of triggers, fires instead of the triggering action.  The INSERT, UPDATE, and
  DELETE statements, causes an INSTEAD OF trigger to fire INSTEAD OF the respective 
  statement execution.

  Trigger            INSERTED or DELETED?
  -----------------  -------------------------------------------------------------------------------------------------
  Instead of Insert  DELETED table is always empty and the INSERTED table contains the newly inserted data.
  Instead of Delete  INSERTED table is always empty and the DELETED table contains the rows deleted
  Instead of Update  DELETED Table contains OLD data (before update) and Inserted table contains NEW data(Updated data) 

  -- Examples
  *********************
  INSERT TRIGGER
  *********************
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

  **********************
  DELETE TRIGGER
  **********************
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

  *********************
  UPDATE TRIGGER    - The After trigger for UPDATE event, makes use of
  both the inserted and deleted tables.  The inserted table contains the 
  updated data and the deleted table contains the old data.
  *********************
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

  *********************
  INSTEAD OF INSERT - TRIGGER
  *********************
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

  ****************************
  INSTEAD OF UPDATE - TRIGGER
  ****************************
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
		  joint tblEmployee
		  on tblEmployee.Id = inserted.id
 END

 ***************************
 INSTEAD OF DELETE - Trigger
 ***************************
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