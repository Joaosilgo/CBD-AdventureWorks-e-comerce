use Projeto_CBD;
go

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Utilizador')
BEGIN
EXEC('CREATE SCHEMA Utilizador')
--create schema Utilizador;
END
go

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Produto')
BEGIN
EXEC('CREATE SCHEMA Produto')
--create schema Produto
END
go



IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Vendas')
BEGIN
EXEC('CREATE SCHEMA Vendas')
--create schema Vendas
END
go

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Conteudos')
BEGIN
EXEC('CREATE SCHEMA Conteudos')
--create schema Vendas
END
go

