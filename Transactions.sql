/*
Manage Transactions
  - Mark a transaction; understanding begin tran, commit, and rollback; implicit versus explicit
    transactions; isolation levels; scope and type of locks; trancount.
	https://www.microsoft.com/en-us/learning/exam-70-461.aspx



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

*/