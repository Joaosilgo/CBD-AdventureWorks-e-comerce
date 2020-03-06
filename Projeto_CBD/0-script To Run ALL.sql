USE master;
go




IF EXISTS(SELECT name FROM sys.databases WHERE name = N'AdventureWorks_MixData')
begin
DROP DATABASE AdventureWorks_MixData
end
go

RESTORE DATABASE AdventureWorks_MixData  
   FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\AdventureWorks_MixData.bak' ;  
GO
USE master;
go


IF EXISTS(SELECT name FROM sys.databases WHERE name = N'Projeto_CBD')
begin
alter database Projeto_CBD set single_user with rollback immediate
--sp_removedbreplication Projeto_CBD
DROP DATABASE [Projeto_CBD]
end
GO
USE master;
go

 :r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\1-Filegroup.sql"
GO
:r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\2-BD_Central.sql"
GO
:r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\3-Schema.sql"
GO
:r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\4-Create2.sql"
GO
:r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\5-Functions.sql"
GO
:r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\6-Erros.sql"
GO
:r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\7-Migracao.sql"
GO
:r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\8-VerificacaoDaNovaBD.sql"
GO
:r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\9-Encript.sql"
GO
:r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\10-Triggers.sql"
GO
:r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\11-Permissoes.sql"
GO
:r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\12-Meta.sql"
GO
:r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\13-Operacoes.sql"
GO
:r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\14-Views.sql"
GO

--GO
--BACKUP 
:r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\Backup\1-Devices.sql"
GO
:r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\Backup\Script to Run All Backups.sql"
GO
:r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\Backup\BackUp Full Database Projeto_CBD.sql"
GO
:r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\Backup\BackUp Differential Database Projeto_CBD.sql"
GO
:r "C:\Users\joao2\OneDrive\Ambiente de Trabalho\Projeto_CBD\Backup\BackUp Log Database Projeto_CBD.sql"
GO

SELECT * FROM

msdb.dbo.sysjobs JOIN

msdb.dbo.sysjobschedules ON sysjobs.job_id = sysjobschedules.job_id

ORDER BY enabled DESC;

SELECT * FROM
 sysjobschedules
