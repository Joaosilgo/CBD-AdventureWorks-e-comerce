USE [master]
GO
IF EXISTS (SELECT * FROM msdb.sys.backup_devices WHERE (name = N'Backup Projeto_CBD'))
begin
EXEC master.dbo.sp_dropdevice @logicalname = N'Backup Projeto_CBD'
end
GO
 
EXEC master.dbo.sp_addumpdevice  @devtype = N'disk', @logicalname = N'Backup Projeto_CBD', @physicalname = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\Backup Projeto_CBD.bak'
GO