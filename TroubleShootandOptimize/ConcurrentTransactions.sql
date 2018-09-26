/*
SQL Server Concurrent Transactions

Common concurrency problems
* Dirty Reads
* Lost Updates
* Nonrepeatable reads
* Phantom Reads

SQL Server Transaction Isolation Levels / Concurrency problem XREF
* Read uncommitted - Dirty Reads; Lost Updates; Nonrepeatable reads; Phantom Reads
* Read committed - Lost Update; Nonrepeatable reads; Phantom Reads
* Repeatable read - Phantom reads
* Snapshot        - None - No Concurrency side effects
* Serializable    - None - No Concurrency side effects

https://www.youtube.com/watch?v=TWv2jpmxaf8&list=PL08903FB7ACA1C2FB&index=70

Microsoft Docs - TRANSACTION ISOLATION LEVEL
https://docs.microsoft.com/en-us/sql/t-sql/statements/set-transaction-isolation-level-transact-sql?view=sql-server-2017

Dirty Read
* A dirty read happens when one transaction is permitted to read data that has been modified
  by another transaction that has not yet been committed.  In most cases this would not cause
  a problem.  However, if this first transaction is rolled back after the second reads the
  data, the second transaction has dirty data that does not exist anymore.

  The default ISOLATION LEVEL is 'Read Committed', so by Default Dirty Read should not happen. The 
  ISOLATION Level would have to be set to 'Read Uncommitted' for Dirty Reads to happen.  This done
  with the command 'Set transaction isolation level read uncommitted'.
  https://www.youtube.com/watch?v=5ZEchu2WnD4&index=71&list=PL08903FB7ACA1C2FB

Lost Updates
* Lost update problem happens when 2 transactions read and update the same data
-- Tranaction 1 
Begin Transaction
Declare @ItemsInStock int
Select @ItemsInStock = ItemsInStock
from tblInventory where Id = 1
Waitfor Delay '00:00:10'
SET @ItemsInStock = @ItemsInStock - 1
Update tblInventory
Set ItemsInStock = @ItemsInStock where id = 1
Print @ItemsInStock
Commit transaction
--Transaction 2  - Set up to complete before Transaction 1
Begin Transaction
Declare @ItemsInStock int
Select @ItemsInStock = ItemsInStock
from tblInventory where Id = 1
Waitfor Delay '00:00:1'
SET @ItemsInStock = @ItemsInStock - 2
Update tblInventory
Set ItemsInStock = @ItemsInStock where id = 1
Print @ItemsInStock
Commit transaction
--- Transaction 1 will silently overwrite the update made in Transaction 2 causing the Lost Update
You will need to set the Isolation Level in both Transactions to Repeatable Read by issuing command
'Set Transaction Isolation Level Repeatable Read'.  Repeatable Read, Snapshot, and Serialization isolation
levels do not have this side effect.

Repeatable reads isolation level uses additional locking on rows that are read by the current transaction,
and prevents them from being updated or deleted elsewhere.  This solves the lost updat problem

https://www.youtube.com/watch?v=jD0c4X0tSc8&index=72&list=PL08903FB7ACA1C2FB

Non repeatable reads

Non repeatable read happens when one tranaction reads the same data twice and another transaction
updates that data in between the first and second read of transaction one.
-- Transaction 1
Begin Transaction
Select ItemsInStock from tblInventory
where Id = 1

waitfor delay '00:00:10'

select ItemsInStock from tblInventory
where Id = 1
commit transaction

-- Transaction 2
Update tblInventory set ItemsInStock = 5
where Id = 1

Transaction 2 completes immediately.  Transaction 1 gives a result of 10; Transaction 2 gives a result of 5.  This is because
we are not able to repeat the read (why they call it Non repeatable reads).  The default isolation level is 'read committed'.
Issing the command 'set transaction isolation level repeatable read' in Transaction 1.  This will
prevent Transaction 2 from updating until Transaction 1 has committed.

https://www.youtube.com/watch?v=d5QNpsezNTs&index=73&list=PL08903FB7ACA1C2FB

Phantom reads

Phantom reads happen when one transaction executes a query twice and it gets a different
number of rows in the result set each time.  This happens when a second transaction inserts
a new row that matches the WHERE clause of the query executed by the query.

-- Transaction 1
Begin Transaction
Select * from tblEmployees
where Id between 1 and 3

waitfor delay '00:00:10'

Select * from tblEmployees
where Id between 1 and 3
commit transaction
-- Transaction 2
Insert into tblEmployees values (2, "Marcus")

The first transaction gives a result of 2 rows, the second transaction gives a result of 3 rows.  This is because
of phanom read.  Transactin 2 executes immediately.   The default is read committed.  To fix the phantom read problem
we will have to set the isolation leve to serializable and snapshot.  The other isolation levels have the phantom
read problem.  Need to change transaction 1 so that the command 'set transaction isolation level serializable' is set
to solve the problem.   Once this is done transaction 2 will be blocked until Transaction 1 has committed.

https://www.youtube.com/watch?v=_UQ9Pu2W7Zg&index=74&list=PL08903FB7ACA1C2FB


MICROSOFT DOC - DATABASE SET Options
https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-database-transact-sql-set-options?view=sql-server-2017

MICROSOFT DOC - Locking and Row Versioning Basics
https://docs.microsoft.com/en-us/sql/2014-toc/sql-server-transaction-locking-and-row-versioning-guide?view=sql-server-2014#Lock_Basics

*/