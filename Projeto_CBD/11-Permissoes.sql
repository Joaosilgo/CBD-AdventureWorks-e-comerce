-------------------       Permissões       ----------------------
--Clientes, Gestor de Vendas e Administrador.
--Create roles
IF DATABASE_PRINCIPAL_ID('Cliente') IS NULL
create role Cliente
go
IF DATABASE_PRINCIPAL_ID('GestorDeVendas') IS NULL
create role GestorDeVendas
go
IF DATABASE_PRINCIPAL_ID('Administrador') IS NULL
create role Administrador
go
--IF DATABASE_PRINCIPAL_ID('Utilizadores') IS NULL
--create role Utilizadores--
--go



--Create Logins
IF NOT EXISTS (SELECT name  FROM master.sys.server_principals WHERE name = 'Administrador1')
CREATE LOGIN Administrador1 WITH Password='Administrador1';
go
IF NOT EXISTS (SELECT name  FROM master.sys.server_principals WHERE name = 'GestorDeVendas1')
CREATE LOGIN GestorDeVendas1 WITH Password='GestorDeVendas1';
go
IF NOT EXISTS (SELECT name  FROM master.sys.server_principals WHERE name = 'Cliente1')
CREATE LOGIN Cliente1 WITH Password='Cliente1';
go

----Create Database Users
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'Administrador1')
BEGIN
CREATE USER Administrador1;
END
go
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'GestorDeVendas1')
BEGIN
CREATE USER GestorDeVendas1;
END
go
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'Cliente1')
BEGIN
CREATE USER Cliente1 without login;--
END
go
--CREATE USER UtilizadoreRegistado;
--go


---- Adicionar users aos roles
exec sp_addrolemember @rolename = 'Administrador', @membername = 'Administrador1'
go
exec sp_addrolemember @rolename = 'GestorDeVendas', @membername = 'GestorDeVendas1'
go
exec sp_addrolemember @rolename = 'Cliente', @membername = 'Cliente1'
go
--exec sp_addrolemember @rolename = 'Clientes', @membername = 'UtilizadoreRegistado'
--go


---- permissions
---- Permissão do Administrador
--Só os utilizadores Administrador, autenticados na respetiva conta do SGBD/BD poderão
--executar as stored procedures de Gestão de Utilizadores.
grant select, insert, update, delete on schema::dbo to Administrador
go
grant select, insert, update, delete on schema::Utilizador to Administrador
go

---- Permissão do Administrador
--Só os utilizadores Gestor de Vendas e Administrador, autenticados na respetiva conta do
--SGBD/BD poderão executar as stored procedures de Gestão de Produtos, Categorias e SubCategorias.
grant select, insert, update, delete on schema::Produto to Administrador
go
grant select, insert, update, delete on schema::Vendas to Administrador
go

---- Permissão do GestorDeVendas
grant select on schema::Vendas to GestorDeVendas
go
grant select on schema::Produto to GestorDeVendas
go
deny select,insert, update, delete on schema::dbo to GestorDeVendas
go
deny select,insert, update, delete on schema::Utilizador to GestorDeVendas
go
---- Permissão do Utilizador
--grant select on object::Conteudos.Destaque to Utilizadores
--go
--grant select on object::Conteudos.MostrarConteudos to Utilizadores
--go

deny select,insert, update, delete on schema::dbo to Cliente
go
--deny select,insert, update, delete on schema::Conteudos to Utilizadores
--go
deny select,insert, update, delete on schema::Utilizador to Cliente
--go
--deny select,insert, update, delete on schema::Publicidade to Utilizadores
--go
---- Permissão Utilizador Registado
--grant select,update on Conteudos.Conteudos to UtilizadoresRegistados
--go
--grant select on object::Utilizador.MostarDadosUtilizador to UtilizadoresRegistados
--go
--deny select,insert, update, delete on schema::dbo to Utilizadores
--go
--deny select,insert, update, delete on schema::Publicidade to Utilizadores
--go