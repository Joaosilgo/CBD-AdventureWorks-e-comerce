---- FileGroups
use master;
--drop database Projeto_CBD ;
IF EXISTS(SELECT name FROM sys.databases WHERE name = N'Projeto_CBD')
begin
DROP DATABASE [Projeto_CBD]
end
GO


create database Projeto_CBD
on primary
(	
	NAME = Projeto_CBD_dat,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Projeto.mdf',
	size = 5,
	maxsize = 1000,
	filegrowth = 5
),
FILEGROUP MyDB_FG1
(
	NAME = Projeto_CBD_Data1_dat,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Data1.ndf',
	size = 1,
	maxsize = 2000,
	filegrowth = 5
),
(
	NAME = Projeto_CBD_Data2_dat,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Data2.ndf',
	size = 1,
	maxsize = 50,
	filegrowth = 5
),
(
	NAME = Projeto_CBD_Data3_dat,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Data3.ndf',
	size = 1,
	maxsize = 100,
	filegrowth = 5
)
log on
(
	NAME = Projeto_log,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Projeto_CBD_log.ldf',
	size = 5,
	maxsize = 10000,
	filegrowth = 5
)COLLATE SQL_Latin1_General_CP1_CI_AS;;