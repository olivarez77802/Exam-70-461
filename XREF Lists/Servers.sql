/*
Servers

FAMISMOD is stored in sea-fa-sql(dev)  You can use SSO_APPS_INTEG to access SEACOMMON in sea-esi-sql(dev)
TRS is stored in sea-edw-sql(dev)
SEACOMMON is stored in sea-esi-sql(dev).  

Example
SELECT 
[EarningCode]
,[TimeAndEffortInstitutionalBasePayFlag]
FROM SSO_APPS_INTEG.SEACommon.dbo.EarningCode
*/
Linked Servers IN SQL Server
https://www.c-sharpcorner.com/uploadfile/suthish_nair/linked-servers-in-sql-server-2008/

EXEC sys.sp_linkedservers
FINANCE IS SEA-FA-SQL
FINANCE_DEV IS SEA-FA-SQLDEV

SELECT * FROM sys.servers

Linked Servers allows you to connect to other database instances on the same server or on another machine or remote servers.

OPENQUERY
https://learn.microsoft.com/en-us/sql/t-sql/functions/openquery-transact-sql?view=sql-server-ver16

Syntax
OPENQUERY ( linked_server ,'query' ) 
linked_server
Is an identifier representing the name of the linked server.

' query '
Is the query string executed in the linked server. The maximum length of the string is 8 KB.

-- Won't work  - Needs Linked Server Name
-- SELECT * FROM OPENQUERY([SEA-FA-SQL], 'SELECT * FROM FAMISMOD.dbo.FRSTables');
-- Works same as SEA-FA-SQL 
SELECT * FROM OPENQUERY([FINANCE], 'SELECT * FROM FAMISMOD.dbo.FRSTables');
-- Looks at Prod.  Like it.. will be usefull!
SELECT * FROM OPENQUERY([SEA-FA-SQL], 'SELECT * FROM FAMISMOD.dbo.FRSTables');
SELECT * FROM OPENQUERY([SEA-FA-SQL], 'SELECT * FROM FAMISMOD.dbo.SysRouteDoc WHERE RdDocId = (''ECT02CTAINLM'')');

-- Won't work - Needs Linked Server Name.
-- SELECT * FROM OPENQUERY([SEA-FA-SQLDEV], 'SELECT * FROM FAMISMOD.dbo.FRSTables');
-- Works same as SEA-FA-SQLDEV
SELECT * FROM OPENQUERY([FINANCE_DEV], 'SELECT * FROM FAMISMOD.dbo.FRSTables');
---
---
---
Prod examples of OPENQUERY Found in FAMISMOD.dbo.spTimeandEffortFlagSync

From: Nace, Rick <r-nace@tamus.edu> 
Sent: Friday, February 28, 2025 1:01 PM
To: Moore, Marc <Marc.Moore@tamus.edu>; Olivarez, Jesse <Jesse-Olivarez@tamus.edu>
Cc: Kessner, Dewayne <dkessner@tamus.edu>
Subject: RE: TeamDynamix Service Request SLA Violation (FW: Error on current T&E do...)

There won’t be a noticeable difference because it’s joining all data.  In both cases, the entire remote dataset will
be returned to the local SQl server then joined to the local object.  If there was a where clause limiting the remote sql data, 
the openquery approach would be noticeably faster as the filtering would be performed at the remote server and the 
smaller results set returned to the local server as opposed to the 4 part naming where all the filtering occurs in the
local sql server (so entire source would be pulled from remote and then filtered locally without ability to utilize indexing).

Rick

From: Olivarez, Jesse 
Sent: Friday, February 28, 2025 1:53 PM
To: Moore, Marc <Marc.Moore@tamus.edu>; Nace, Rick <r-nace@tamus.edu>
Cc: Kessner, Dewayne <dkessner@tamus.edu>
Subject: RE: TeamDynamix Service Request SLA Violation (FW: Error on current T&E do...)

Updated in Dev.  Let me know if you want run the update in Dev. Or if you will be finishing this up, prior to moving it to Test.

Thanks - Jesse

From: Moore, Marc <Marc.Moore@tamus.edu> 
Sent: Friday, February 28, 2025 12:54 PM
To: Olivarez, Jesse <Jesse-Olivarez@tamus.edu>; Nace, Rick <r-nace@tamus.edu>
Cc: Kessner, Dewayne <dkessner@tamus.edu>
Subject: RE: TeamDynamix Service Request SLA Violation (FW: Error on current T&E do...)

Hi Jesse. I’m getting the TDX change going to release the SEACommon.vEarningCode view on Thursday.

I put it in Test today and I can re-do that on Monday if it gets stomped by the restore.

Perhaps this stylistic, but I’d simplify the query to something like:

SELECT SEACommonEarnCdTbl.EarningCode, LEFT(SEACommonEarnCdTbl.TimeAndEffortInstitutionalBasePayFlag,1) SCTEFlg, FamisModEarnCdTbl.EarningCode,FamisModEarnCdTbl.TimeAndEffort
FROM SSO_APPS_INTEG.SEACommon.dbo.vEarningCode SEACommonEarnCdTbl
INNER JOIN famismod.dbo.vPayEarningCodes FamisModEarncdTbl
ON SEACommonEarnCdTbl.EarningCode = FamisModEarnCdTbl.EarningCode
WHERE LEFT(SEACommonEarnCdTbl.TimeAndEffortInstitutionalBasePayFlag,1) <> FamisModEarnCdTbl.TimeAndEffort

In this scenario I don’t see a material advantage to the OPENQUERY approach – although to be fair, I do not know everything about
linked server calls.

Let me know if you need anything else from me!

Thanks,

Marc

From: Olivarez, Jesse <Jesse-Olivarez@tamus.edu> 
Sent: Wednesday, February 26, 2025 1:31 PM
To: Nace, Rick <r-nace@tamus.edu>; Moore, Marc <Marc.Moore@tamus.edu>
Cc: Kessner, Dewayne <dkessner@tamus.edu>
Subject: RE: TeamDynamix Service Request SLA Violation (FW: Error on current T&E do...)

Thanks Rick, yes that explains it.  Will work on doing the update once Marc has gotten a chance to get on same page
(thinking may need to add something to let us know this stored procedure made updates).

-Jesse

From: Nace, Rick <r-nace@tamus.edu> 
Sent: Wednesday, February 26, 2025 12:44 PM
To: Olivarez, Jesse <Jesse-Olivarez@tamus.edu>; Moore, Marc <Marc.Moore@tamus.edu>
Cc: Kessner, Dewayne <dkessner@tamus.edu>
Subject: Re: TeamDynamix Service Request SLA Violation (FW: Error on current T&E do...)

Sso_apps_integ is a linked server reference.  Any linked server that has a {_env} appended to end of name represents a
targeted environment different from the connection.  The linked server without the environment reference is targeted to
the same env as the connection so will always provide 'consistent' data.  Hope that provides a better explanation.

