USE [msdb]
GO

--sp_helplogins






DECLARE @jobId BINARY(16)

SELECT @jobId = job_id FROM msdb.dbo.sysjobs WHERE (name = N'Full Database Projeto_CBD Backup')
IF (@jobId IS NOT NULL)
BEGIN
    EXEC msdb.dbo.sp_delete_job @jobId
END
GO
DECLARE @jobID BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'Full Database Projeto_CBD Backup', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DESKTOP-4A1F72T\joao2', @job_id = @jobID OUTPUT
select @jobID
GO



go

--DECLARE @jobId BINARY(16)
--DECLARE @server_nameS varchar(max)
--SELECT  * FROM msdb.dbo.sysjobservers. WHERE (name = N'Full Database Projeto_CBD Backup')
--SELECT @jobId = job_id FROM msdb.dbo.sysjobs WHERE (name = N'Full Database Projeto_CBD Backup')
--IF (@jobId IS NOT NULL)
--BEGIN
   -- EXEC msdb.dbo.sp_delete_jobserver @jobId, @server_name 
--END


EXEC msdb.dbo.sp_add_jobserver @job_name=N'Full Database Projeto_CBD Backup', @server_name = N'DESKTOP-4A1F72T'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'Full Database Projeto_CBD Backup', @step_name=N'Full Database Projeto_CBD Backup', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BACKUP DATABASE [Projeto_CBD] TO  [Backup Projeto_CBD] WITH NOFORMAT, NOINIT,  NAME = N''master-Full Database Projeto_CBD Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO', 
		@database_name=N'Projeto_CBD', 
		@flags=0
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Full Database Projeto_CBD Backup', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DESKTOP-4A1F72T\joao2', 
		@notify_email_operator_name=N'', 
		@notify_netsend_operator_name=N'', 
		@notify_page_operator_name=N''
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'Full Database Projeto_CBD Backup', @name=N'Full Database Projeto_CBD Backup', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20190915, 
		@active_end_date=20201231, 
		@active_start_time=400, 
		@active_end_time=015959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO
