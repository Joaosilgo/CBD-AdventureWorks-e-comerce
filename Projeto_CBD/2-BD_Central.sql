-- FileGroups

USE master
go

IF EXISTS(select * from sys.databases where name='BD_Central')
begin
alter database BD_Central set single_user with rollback immediate
DROP DATABASE BD_Central;
end

go
create database BD_Central
on primary
(	
	NAME = BD_Central_dat,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\BD_Central.mdf',
	size = 5,
	maxsize = 50,
	filegrowth = 5
)
log on
(
	NAME = BD_Central_log,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\BD_Central_log.ldf',
	size = 5,
	maxsize = 50,
	filegrowth = 5
);


go

use BD_Central
go

--CREATE TABLE Sales_Product (
--	SalesOrderNumber integer NOT NULL,
--	ProductKey integer NOT NULL,
--	SalesAmount money NOT NULL,
--	UnitPrice money NOT NULL,
--	OrderQuantity integer NOT NULL DEFAULT 1,
--	SalesOrderLineNumber tinyint ,
--	PRIMARY KEY (SalesOrderNumber,ProductKey),
--);


--CREATE TABLE Sales (
--	SalesOrderNumber integer NOT NULL PRIMARY KEY IDENTITY,
--	OrderDate date DEFAULT NULL,
--	DueDate date DEFAULT NULL,
--	ShipDate date DEFAULT NULL,
--	SalesTerritoryKey integer  NOT NULL,
--	CurrencyKey integer NOT NULL,
--	CustomerKey integer NOT NULL,
--) ;

--ALTER TABLE Sales_Product
--ADD FOREIGN KEY (SalesOrderNumber) REFERENCES Sales(SalesOrderNumber) ON DELETE CASCADE ON UPDATE CASCADE;




























