use master
go
BACKUP DATABASE [Projeto_CBD] TO  [Backup Projeto_CBD] WITH NOFORMAT, NOINIT,  NAME = N'master-Full Database Projeto_CBD Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
BACKUP DATABASE [Projeto_CBD] TO  [Backup Projeto_CBD] WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N'master-Differential Database Projeto_CBD Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
BACKUP LOG [Projeto_CBD] TO  [Backup Projeto_CBD] WITH NOFORMAT, NOINIT,  NAME = N'master-Log Database Projeto_CBD Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO