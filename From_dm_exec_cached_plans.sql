EXEC dbo.PERSON_SELECT

SELECT cp.usecounts, cp.cacheobjtype, cp.objtype
FROM sys.dm_exec_cached_plans as cp