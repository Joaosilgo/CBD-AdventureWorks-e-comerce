use [Projeto_CBD]
exec sp_replicationdboption @dbname = N'Projeto_CBD', @optname = N'publish', @value = N'true'
GO
-- Adding the transactional publication
use [Projeto_CBD]
exec sp_addpublication @publication = N'Promos', @description = N'Transactional publication of database ''Projeto_CBD'' from Publisher ''DESKTOP-4A1F72T''.', @sync_method = N'concurrent', @retention = 0, @allow_push = N'true', @allow_pull = N'true', @allow_anonymous = N'false', @enabled_for_internet = N'false', @snapshot_in_defaultfolder = N'true', @compress_snapshot = N'false', @ftp_port = 21, @ftp_login = N'anonymous', @allow_subscription_copy = N'false', @add_to_active_directory = N'false', @repl_freq = N'continuous', @status = N'active', @independent_agent = N'true', @immediate_sync = N'false', @allow_sync_tran = N'false', @autogen_sync_procs = N'false', @allow_queued_tran = N'false', @allow_dts = N'false', @replicate_ddl = 1, @allow_initialize_from_backup = N'false', @enabled_for_p2p = N'false', @enabled_for_het_sub = N'false'
GO


exec sp_addpublication_snapshot @publication = N'Promos', @frequency_type = 16, @frequency_interval = 1, @frequency_relative_interval = 1, @frequency_recurrence_factor = 1, @frequency_subday = 8, @frequency_subday_interval = 1, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @job_login = null, @job_password = null, @publisher_security_mode = 1


use [Projeto_CBD]
exec sp_addarticle @publication = N'Promos', @article = N'Sales', @source_owner = N'dbo', @source_object = N'Sales', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Sales', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboSales', @del_cmd = N'CALL sp_MSdel_dboSales', @upd_cmd = N'SCALL sp_MSupd_dboSales'
GO




use [Projeto_CBD]
exec sp_addarticle @publication = N'Promos', @article = N'Sales_Product', @source_owner = N'dbo', @source_object = N'Sales_Product', @type = N'logbased', @description = null, @creation_script = null, @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual', @destination_table = N'Sales_Product', @destination_owner = N'dbo', @vertical_partition = N'false', @ins_cmd = N'CALL sp_MSins_dboSales_Product', @del_cmd = N'CALL sp_MSdel_dboSales_Product', @upd_cmd = N'SCALL sp_MSupd_dboSales_Product'
GO




