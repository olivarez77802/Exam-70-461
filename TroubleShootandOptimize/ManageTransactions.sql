/*
Manage Transactions
  - Mark a transaction; understanding begin tran, commit, and rollback; implicit versus explicit
    transactions; isolation levels; scope and type of locks; trancount.
	https://www.microsoft.com/en-us/learning/exam-70-461.aspx

1. Transaction 
2. ACID 
3. Transaction modes. (Covers understanding begin tran,commit, and rollback; implicit versus explicit transactions)
4. Mark a transaction
5. Nested Transactions
6. Isolation Levels
7. Scope and Type of Locks


**********************************
1. Transaction
**********************************

All Operations that in any way write to the database are treated by SQL Server as transactions.  This includes
1. DML - Data Manipulation Language statements such as INSERT, UPDATE, and DELETE
2. DDL - Data Definition Languaage statements such as CREATE TABLE and CREATE INDEX.
Technically, even single SELECT statements are a type of transaction in SQL, these are called read-only transactions.

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

Note:  The transaction starts with the 'BEGIN' coommand and may include more than one SQL statement.

The ACID acronym is used to describe the properties of transactions.

*********************************
2. ACID 
*********************************

A transaction is a group of database commands that are treated as a single unit. A
successful transaction must pass the 'ACID' test.  It must be:
(A)tomic, (C)onsistent, (I)solated, (D)urable

Atomic - All statements in the transaction either completed successfully or they
were rolled back.  The task that the set of operations represent is either accomplished
or not, but in any case not left half-done.  Example an UPDATE command that would update
500 rows in a table at the point in time that the transaction begins.  The command will
not finish until exactly all 500 rows are updated.  If something happens the transaction
will get rolled back.   You cannot commit partial transactions. No Nested Commits.

Consistent - All data touched by the transaction is left in a logically consistent
state.  No orphan data. 

Isolated - The transaction must affect data without interferring with other concurrent
transactions, or being intefered with by them.  This prevents transactions from
making changes to data based on uncommitted information, for example
changes to a record that are subsequently rolled back.  Most databases use locking
to maintain transaction level.

Durable - Every transaction endures through an interruption of service.  When service
is restored, all committed transactions are rolled forward (committed changes  to 
the database are completed) and all uncommitted transactions are rolled back (uncommitted
changes are removed).  SQL maintains durability by using the database transaction log.
Every database change is written to the transaction log with the original version of the
data.

https://www.youtube.com/watch?v=VLc4ewu6lUI&list=PL08903FB7ACA1C2FB&index=58



**********************************
3. TRANSACTION MODES
**********************************
See Also 
SET_XREF.sql
Implicit_Defaults.sql

SET IMPLICIT_TRANSACTIONS {ON | OFF}
When ON, the system is in IMPLICIT transaction mode.  This means that if @@TRANCOUNT = 0, any of the following 
Transact-SQL Statements begins a new transaction.  It is equivalent to an unseen BEGIN TRANSACTION being exectuted first:
ALTER TABLE, FETCH, REVOKE, BEGIN TRANSACTION, GRANT, SELECT, CREATE, INSERT, TRUNCATE TABLE, DELETE, OPEN, UPDATE, DROP.
https://docs.microsoft.com/en-us/sql/t-sql/statements/set-implicit-transactions-transact-sql?view=sql-server-ver15

@@TRANCOUNT -  Is really a variable to define Levels.

TRANSACTION Modes
SQL Server operates in the following transaction modes:
1. Autocommit transactions - Mode used when SET IMPLICIT TRANSACTIONS OFF (This is the default.) Each individual statement is a transaction. 
   (A Behind the scenes BEGIN and COMMIT is done) You do not issue any surrounding transactional commands such as 'BEGIN TRAN, ROLLBACK TRAN, 
   or COMMIT TRAN'.  The @@TRANCOUNT value is not normally detectable for that command.

2. Implicit transactions - Mode used when SET IMPLICIT TRANSACTIONS ON.  A new transaction is implicitly started when the prior transaction completes, but
   each transaction is explicitly completed with a COMMIT or ROLLBACK statement.  Do not need a 'BEGIN TRANSACTION' this is implicit.
   In the implicit transaction mode, when you issue one or more DML or DDL statements, or a SELECT statement, SQL starts
   a transaction and increments @@TRANCOUNT to 1.

3. Explicit transactions - Mode used when SET IMPLICIT TRANSACTION OFF (This is the default, so you may not see this command). 
   Each transaction is explicitly started with the 'BEGIN TRANSACTION' statement
   and explicitly ended with a 'COMMIT' or 'ROLLBACK' statement.  In an explicit transaction, as soon as you issue
   the 'BEGIN TRAN' command, the value of @@TRANCOUNT is incremented by 1.

4. Explicit transactions can be used in implicit transaction mode (SET IMPLICIT TRANSACTION ON), but if you start an explicit transaction the 
   value of @@TRANCOUNT will increment from 0 to 2 immedidately after the 'BEGIN TRAN' command.  This is the 
   same as a nested transaction.  Not a good practice to do this.

https://docs.microsoft.com/en-us/sql/t-sql/language-elements/transactions-transact-sql?view=sql-server-2017

Autocommit Mode (SET IMPLICIT TRANSACTIONS OFF)
The database acts as if every single command is wrapped with BEGIN..COMMIT.
In the autocommit mode, single data modification and DDL T-SQL statements are executed in the context of a transaction that will
be automatically committed when the statement succeeds, or automatically rolled back if the statement fails.
The autocommit mode is the default transaction management mode. The simple state diagram in Figure 12-1 illustrates the autocommit mode.
https://www.youtube.com/watch?v=J9VP5CILdP4
 
SET AUTOCOMMIT OFF - Have to explicitly type 'COMMIT' or 'ROLLBACK'.  
SET AUTOCOMMIT ON  - COMMIT or ROLLBACK is Implicit.  This is the default.  SET IMPLICIT TRANSACTIONS OFF

A transaction in autocommit mode with no COMMIT required.
In the autocommit mode, you do not issue any surrounding transactional commands such as BEGIN TRAN, ROLLBACK TRAN, or COMMIT TRAN. 
Further, the @@TRANCOUNT value (for the user session) is not normally detectable for that command, though it would be in a data 
modification statement trigger. Whatever changes you make to the database are automatically handled, statement by statement, 
as transactions. Remember, autocommit is the default operation of SQL Server.  SET IMPLICIT TRANSACTIONS OFF is also the default.

Implicit Transaction Mode
In the implicit transaction mode, when you issue one or more DML or DDL statements, or a SELECT statement, SQL Server starts a transaction, 
increments @@TRANCOUNT, but does not automatically commit or roll back the statement. You must issue a COMMIT or ROLLBACK interactively 
to finish the transaction, even if all you issued was a SELECT statement.
Implicit transaction mode is not the SQL Server default. You enter that mode by issuing the following command.
SET IMPLICIT_TRANSACTIONS ON;
You can also issue the following command. However, this command just effectively issues the first command for you.
SET ANSI_DEFAULTS ON;
As soon as you do any work—that is, make changes to the database data—a transaction automatically begins. 
Figure 12-2 illustrates how this works.
https://docs.microsoft.com/en-us/sql/t-sql/statements/set-ansi-defaults-transact-sql?view=sql-server-ver15
 
Figure 12-2. An implicit transaction using COMMIT or ROLLBACK.
As soon as you enter any command to change data, the value of @@TRANCOUNT becomes equal to 1, indicating that you
are one level deep in the transaction. You must then manually issue a COMMIT or a ROLLBACK statement to finish the
transaction. If you issue more DML or DDL statements, they also become part of the transaction.
Some advantages to using implicit transactions are:
•	You can roll back an implicit transaction after the command has been completed.
•	Because you must explicitly issue the COMMIT statement, you may be able to catch mistakes after the command is finished.
Some disadvantages to using implicit transactions are:
•	Any locks taken out by your command are held until you complete the transaction. Therefore, you could end up blocking
    other users from doing their work.
•	Because this is not the standard method of using SQL Server, you must constantly remember to set it for your session.
•	The implicit transaction mode does not work well with explicit transactions because it causes the @@TRANCOUNT value
    to increment to 2 unexpectedly.
•	If you forget to commit an implicit transaction, you may leave locks open.

Note that implicit transactions can span batches.

MORE INFO IMPLICIT TRANSACTIONS
For more details about implicit transactions, see the Books Online for SQL Server 2012 article
“SET IMPLICIT_TRANSACTIONS (Transact-SQL)” at http://msdn.microsoft.com/en-us/library/ms187807.aspx.

Explicit Transaction Mode
An explicit transaction occurs when you explicitly issue the BEGIN TRANSACTION or BEGIN TRAN command to start a transaction.  

In an explicit transaction, as soon as you issue the BEGIN TRAN command, the value of @@TRANCOUNT is incremented by 1. Then you
issue your DML or DDL commands, and when ready, issue COMMIT or ROLLBACK.
You can run explicit transactions interactively or in code such as stored procedures.
Explicit transactions can be used in implicit transaction mode (SET IMPLICIT_TRANSACTIONS ON), but if you start an explicit transaction when running your session
in implicit transaction mode, the value of @@TRANCOUNT will increment from 0 to 2 immediately after the BEGIN TRAN command. 
This effectively becomes a nested transaction. As a result, it is not considered a good practice to let @@TRANCOUNT
increase beyond 1 when using implicit transactions.
What happens if any of your data modification or DDL statements encounter an error? Some errors cause the entire transaction to roll back,
but others, such as foreign key violations do not cause all the statements to roll back. To ensure that your transactions behave correctly,
you need to add error handling to your code.

EXAM TIP
Note that transactions can span batches. This includes both implicit transactions and explicit transactions—that is, GO statements.
However, it is often a best practice to make sure that each transaction takes place in one batch.

Log File Information
http://www.techbrothersit.com/2015/03/how-to-delete-huge-data-from-sql-server.html


BEGIN TRANSACTION - Marks the starting point of an explicit, local transaction.  Explicit transactions start with
the BEGIN TRANSACTION statement and end with the COMMIT and ROLLBACK statement.
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/begin-transaction-transact-sql?view=sql-server-2017

****************************************************************************
4. MARK a Transaction
****************************************************************************
You can name an explicit transaction by putting the name after the BEGIN TRAN statement. Transaction names must follow the rules for SQL
Server identifiers; however, SQL Server only recognizes the first 32 characters as a unique name and ignores any remaining characters, 
so keep all transaction names to 32 characters or less in length. The transaction name is displayed in the name column of sys.dm_tran_active_transactions, 
as shown in the following example.

USE TSQL2012;
BEGIN TRANSACTION Tran1;

Note that SQL Server only records transaction names for the outermost transaction. If you have nested transactions, any names for the nested transactions are ignored.

Named transactions are used for placing a mark in the transaction log in order to specify a point to which one or more databases can be restored. When the transaction
is recorded in the database’s transaction log, the transaction mark is also recorded, as shown in the following example.

USE TSQL2012;
BEGIN TRAN Tran1 WITH MARK;
    -- <transaction work>
COMMIT TRAN; -- or ROLLBACK TRAN
-- <other work>
If you need to restore the database to the transaction mark later, you can run the following code.

RESTORE DATABASE TSQ2012 FROM DISK = 'C:\SQLBackups\TSQL2012.bak'
    WITH NORECOVERY;
GO
RESTORE LOG TSQL2012 FROM DISK = 'C:\SQLBackups\TSQL2012.trn'
    WITH STOPATMARK = 'Tran1';
GO
Note the following about using WITH MARK:

You must use the transaction name with STOPATMARK.

You can place a description after the clause WITH MARK, but SQL Server ignores it.

You can restore to just before the transaction with STOPBEFOREMARK.

You can recover the dataset by restoring with either WITH STOPATMARK or STOPBEFOREMARK.

You can add RECOVERY to the WITH list, but it has no effect.

***************************
5. Nested Transactions
***************************

NESTED TRANSACTIONS
When explicit transactions are nested—that is, placed within each other—they are called nested transactions. The behavior of 
COMMIT and ROLLBACK changes when you nest transactions.

EXAM TIP
An inner COMMIT statement has no real effect on the transaction, only decrementing @@TRANCOUNT by 1. Just the outermost COMMIT statement,
the one executed when @@TRANCOUNT = 1, actually commits the transaction.

EXAM TIP
Note that it doesn’t matter at what level you issue the ROLLBACK command. A transaction can contain only one ROLLBACK command,
and it will roll back the entire transaction and reset the @@TRANCOUNT counter to 0.

@@TRANCOUNT- can be queried to find the level of transactions.
0 - Indicates the code is not within a transaction
1 - Indicates there is active transaction
>1 - Indicates nesting level of nested transactions
Every COMMIT statement reduces the value of @@TRANCOUNT by 1, and only the outermost COMMIT statement commits the entire nested transaction.
https://docs.microsoft.com/en-us/sql/t-sql/functions/trancount-transact-sql?view=sql-server-2017

Nested Transactions in SQL
ROLLBACK versus COMMIT
ROLLBACK - Will roll back ALL open transactions.  It will ROLLBACK Everything!  Unlike a COMMIT that relates to last 'BEGIN TRAN'
COMMIT - Will only psedo-commit any "nested" transactions, it simply decrements @@TRANCOUNT.
         Committing "nested" transactions only applies to the last executed "BEGIN TRAN".
-- Tran1     @@TRANCOUNT=1
-- -- Tran2  @@TRANCOUNT=2
-- -- Tran2 COMMIT @TRANCOUNT=1
-- -- Tran3  @@TRANCOUNT=2
-- -- Tran3 COMMIT @TRANCOUNT= 1
-- Tran1    ROLLBACK @@TRANCOUNT=0
https://www.youtube.com/watch?v=MGFfQyJMO9E

COMMIT TRANSACTION
- When used in nested transactions, commits of the inner transactions do not free resources or make their modifications
  permanent.  The data modifications are made permanent and resources freed only when the outer transaction is committed.
  When @@TRANCOUNT is finally decrememented to 0, then entire transaction is committed.
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/commit-transaction-transact-sql?view=sql-server-2017



****************************************************************************
6. ISOLATION LEVEL.  
***************************************************************************
-  The 'I' in A.C.I.D.  The degreee of isolation can vary
   for readers depending on settings that their session applies.
- SQL's default isolation level is 'Read committed'.  This means read only committed data.

If you execute the below statements -  Other users will not be able to see updated data untiL the 'End transaction' has been done.
This is because SQL Isolation Level is read committed meaning only read committed data.  To read uncommitted data you would have 
to issue the below command:
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

https://www.youtube.com/watch?v=shkt9Z5Gz-U&index=57&list=PL08903FB7ACA1C2FB


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

READ COMMITTED This is the default isolation level. All readers in that session will only read data changes
that have been committed. So all the SELECT statements will attempt to acquire shared locks, and any underlying
data resources that are being changed by a different session, and therefore have exclusive locks, will block 
the READ COMMITTED session.

READ UNCOMMMITED This isolation level allows readers to read uncommitted data. This setting removes the shared 
locks taken by SELECT statements so that readers no longer are blocked by writers. However, the results of a 
SELECT statement could read uncommitted data that was changed during a transaction and then later was rolled 
back to its initial state. This is called reading dirty data.

READ COMMITTED SNAPSHOT This is actually not a new isolation level; it is an optional way of using the default 
READ COMMITTED isolation level, the default isolation level in Windows Azure SQL Database. This isolation level
has the following traits: Often abbreviated as RCSI, it uses tempdb to store original versions of changed data.
The READ COMMITTED SNAPSHOT option is set at the database level and is a persistent database property.
RCSI is not a separate isolation level; it is only a different way of implementing READ COMMITTED,
preventing writers from blocking readers. RCSI is the default isolation level for Windows Azure SQL Database.

EXAM TIP
Isolation levels are set per session. If you do not set a different isolation level in your session, all your transactions
will execute using the default isolation level, READ COMMITTED. For on-premise SQL Server instances, this is READ COMMITTED.
In Windows Azure SQL Database, the default isolation level is READ COMMITTED SNAPSHOT.

If your session is in the READ COMMITTED isolation level, is it possible for one of your queries to read uncommitted data?
Yes, if the query uses the WITH (NOLOCK) or WITH (READUNCOMMITTED) table hint. The session value for the isolation level does 
not change, just the characteristics for reading that table.

Is there a way to prevent readers from blocking writers and still ensure that readers only see committed data?
Yes, that is the purpose of the READ COMMITTED SNAPSHOT option within the READ COMMITTED isolation level. Readers see earlier versions
of data changes for current transactions, not the currently uncommitted data.

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



Differences between Serializable and Snapshot isolation Levels
Serializable isolation is implemented by acquiring locks which means the resources are locked for the duration
of the current transaction.  This isolation level does not have any concurrency side effects but at the cost of
significant reduction in concurrency.

Snapshot isolation doesn't acquire locks, it maintains versioning in Tempdb.  Since, snapshot isolation does 
not lock resources, it can significantly increase the number of concurrent transactions while providing the 
same level of data consistency as serializable isolation does.   
https://www.youtube.com/watch?v=9NVu17LjPSA

******************************************
7. Scope and Type of Locks
******************************************
Basic Locking
To preserve the isolation of transactions, SQL Server implements a set of locking protocols. At the basic level, there are two general modes of locking:

1. Shared locks Used for sessions that read data—that is, for readers

2.  Exclusive locks Used for changes to data—that is, writers

Can readers (shared locks) block readers?  No, because shared locks are compatible with other shared locks.
.
Can readers block writers (exclusive locks)?Yes, even if only momentarily, because any exclusive lock request has to wait until the shared lock is released.

*/