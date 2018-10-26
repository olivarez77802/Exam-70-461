/*
Manage Transactions
  - Mark a transaction; understanding begin tran, commit, and rollback; implicit versus explicit
    transactions; isolation levels; scope and type of locks; trancount.
	https://www.microsoft.com/en-us/learning/exam-70-461.aspx

Log File Information
http://www.techbrothersit.com/2015/03/how-to-delete-huge-data-from-sql-server.html


BEGIN TRANSACTION - Marks the starting point of an explicit, local transaction.  Explicit transactions start with
the BEGIN TRANSACTION statement and end with the COMMIT and ROLLBACK statement.
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/begin-transaction-transact-sql?view=sql-server-2017

TRANSACTIONS
SQL Server operates in the following transaction modes:
1. Autocommit transactions - Each individual statement is a transaction. (A Behind the scenes BEGIN and COMMIT is done)
2. Explicit transactions - Each transaction is explicitly started with the 'BEGIN TRANSACTION' statement
   and explicitly ended with a 'COMMIT' or 'ROLLBACK' statement.
3. Implicit transactions - A new transaction is implicitly started when the prior transaction completes, but
   each transaction is explicitly completed with a COMMIT or ROLLBACK statement.
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/transactions-transact-sql?view=sql-server-2017

AUTOCOMMIT Mode
https://www.youtube.com/watch?v=J9VP5CILdP4

Transactions

A transaction is a group of database commands that change the data stored in a database.  A transaction, is treated as a single unit.
A transaction ensures that, either all of the commands succeed, or none of them.  If one of the commands in the transaction
fails, all of the commands fail, and any data that was modified in the database is rolled back.  In this way, transactions 
maintain the integrity of data in the database.

Transaction processing follows these steps:
1. Begin a transaction
2. Process database commands
3. Check for errors.
   If errors occurred
       rollback the transaction
   else
       commit the transaction

ISOLATION LEVEL
  - SQL's default isolation level is 'Read committed'.  This means read only committed data.

If you execute the below statements -  Other users will not be able to see updated data untiL the 'End transaction' has been done.
This is because SQL Isolation Level is read committed meaning only read committed data.  To read uncommitted data you would have 
to issue the below command:
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Begin Transaction
Update tblProduct set QtyAvailable = 300 where Productid = 1

https://www.youtube.com/watch?v=shkt9Z5Gz-U&index=57&list=PL08903FB7ACA1C2FB


TRANSACTIONS ACID Test

A transaction is a group of database commands that are treated as a single unit. A
successful transaction must pass the 'ACID' test.  It must be:
(A)tomic, (C)onsistent, (I)solated, (D)urable

Atomic - All statements in the transaction either completed successfully or they
were rolled back.  The task that the set of operations represent is either accomplished
or not, but in any case not left half-done.

Consistent - All data touched by the transaction is left in a logically consistent
state.  No orphan data. 

Isolated - The transaction must affect data without interferring with other concurrent
transactions, or being intefered with by them.  This prevents transactions from
making changes to data based on uncommitted information, for example
changes to a record that are subsequently rolled back.  Most databases use locking
to maintain transaction level.

Durable - Once a change is made, it is permanent.  If a system error or power failure
occurs before a set of commands is complete, those commands are undone and the 
data is restored to its original state once the system begins running again.

https://www.youtube.com/watch?v=VLc4ewu6lUI&list=PL08903FB7ACA1C2FB&index=58

/*
SQL Server Concurrent Transactions

Common concurrency problems
* Dirty Reads
* Lost Updates
* Nonrepeatable reads
* Phantom Reads

SQL Server Transaction Isolation Levels / Concurrency problem XREF
* Read uncommitted - Dirty Reads; Lost Updates; Nonrepeatable reads; Phantom Reads
* Read committed (Default) - Lost Update; Nonrepeatable reads; Phantom Reads
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

@@TRANCOUNT
https://docs.microsoft.com/en-us/sql/t-sql/functions/trancount-transact-sql?view=sql-server-2017

Nested Transactions in SQL
https://www.youtube.com/watch?v=MGFfQyJMO9E

COMMIT TRANSACTION
- When used in nested transactions, commits of the inner transactions do not free resources or make their modifications
  permanent.  The data modifications are made permanent and resources freed only when the outer transaction is committed.
  When @@TRANCOUNT is finally decrememented to 0, then entire transaction is committed.
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/commit-transaction-transact-sql?view=sql-server-2017


Differences between Serializable and Snapshot isolation Levels
Serializable isolation is implemented by acquiring locks which means the resources are locked for the duration
of the current transaction.  This isolation level does not have any concurrency side effects but at the cost of
significant reduction in concurrency.

Snapshot isolation doesn't acquire locks, it maintains versioning in Tempdb.  Since, snapshot isolation does 
not lock resources, it can significantly increase the number of concurrent transactions while providing the 
same level of data consistency as serializable isolation does.   
https://www.youtube.com/watch?v=9NVu17LjPSA

*/