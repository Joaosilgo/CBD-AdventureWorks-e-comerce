




USE Projeto_CBD
GO




DROP PROCEDURE IF EXISTS typesOfCustomers
GO
CREATE OR ALTER PROCEDURE typesOFCustomers AS
	
	INSERT INTO Projeto_CBD.Utilizador.VIPCustomer (
		[CustomerKey]
	)
	SELECT c.CustomerKey FROM Projeto_CBD.Utilizador.Customer c
	WHERE c.CustomerKey % 2 = 0

	INSERT INTO Projeto_CBD.Utilizador.NormalCustomer(
		[CustomerKey]
	)
	SELECT c.CustomerKey FROM Projeto_CBD.Utilizador.Customer c
	WHERE c.CustomerKey % 2 <> 0 

GO

EXEC typesOFCustomers;
GO
DROP PROCEDURE IF EXISTS createPromotion

GO
CREATE or alter PROCEDURE createPromotion(@nome VARCHAR(20), @days INT) AS
	INSERT INTO Projeto_CBD.dbo.Promotions (
		[PromotionName],
		[StartDate],
		[EndDate]
	) VALUES (
		@nome,
		CURRENT_TIMESTAMP,
		DATEADD(day, @days, CURRENT_TIMESTAMP)
	)
GO

exec createPromotion 'BlackFriday', 4;
go

select * from Projeto_CBD.dbo.Promotions;

go

DROP PROCEDURE IF EXISTS Vendas.AttachPromoProduct

GO
CREATE or alter PROCEDURE Vendas.AttachPromoProduct(@idPromo INT, @idProd INT, @percentage INT) AS
	INSERT INTO Projeto_CBD.dbo.Promotions_Product(
		[ProductKey],
		[PromotionsKey],
		[Percentage]
	) VALUES (
		@idProd,
		@idPromo,
		@percentage
	)
GO

exec Vendas.AttachPromoProduct 1,212, 10;

GO

select * from Projeto_CBD.dbo.Promotions_Product;

go









--9. Gestão de Produtos, Categorias e Subcategorias:
--a. Editar, Adicionar e Remover Produtos, Categorias e Sub-Categorias
--b. Associar Produto a Sub-Categoria/Categoria
--c. Alterar as datas (DueDate e ShipDate) de Encomendas
--d. Alterar o Estado dos Produtos


--9.c. SP que altera as datas das encomendas funciona tambe como fecho 
DROP PROCEDURE IF EXISTS Vendas.AlterarShipDueDate
GO
CREATE PROCEDURE Vendas.AlterarShipDueDate(@idSales INT) AS
	UPDATE Projeto_CBD.dbo.Sales SET ShipDate = CURRENT_TIMESTAMP,
	DueDate = DATEADD(day, 4, ShipDate) WHERE SalesOrderNumber = @idSales
GO

--SalesOrderNumber	OrderDate	DueDate	ShipDate	SalesTerritoryKey	CurrencyKey	CustomerKey
--43697	2014-07-01	2014-07-13	2014-07-08	2	19	21768
exec Vendas.AlterarShipDueDate 43697
go

select * from Projeto_CBD.dbo.Sales;
go

-- ================================================================================================================================================
-- ================================================================================================================================================
-- ================================================================================================================================================
-- ================================================================================================================================================
-- 9.d SP que altera o estado do produto

CREATE OR ALTER PROCEDURE Produto.AlterStatus(@idProduct INT) AS
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	BEGIN TRAN
	IF (SELECT p.StatusID FROM Projeto_CBD.dbo.Product p WHERE p.ProductID = @idProduct) IS NOT NULL	BEGIN
		UPDATE Projeto_CBD.dbo.Product SET StatusID = NULL WHERE ProductID = @idProduct
	END 
	ELSE BEGIN
		UPDATE Projeto_CBD.dbo.Product SET StatusID = 1 WHERE ProductID = @idProduct
	END
	COMMIT
GO
--ProductID	ListPrice	StandardCost	WeightUnitMeasureCode	FinishedGoodsFlag	Weight	DealerPrice	ModelName	CategoryID	StatusID	SafetyStockID	PhotoID	SizeID	DescriptionID	ProductNameID	ProductLine	ColorName	DaysToManufacture	ClassName	StyleType
--210	NULL	NULL	LB 	1	2,24	NULL	HL Road Frame	32	1	3	9	12	108	44	R 	Black	1	H 	U 
exec Produto.AlterStatus 212;
go
select * from Projeto_CBD.dbo.Product;

go
CREATE or alter PROCEDURE Produto.AssociarProduto
@ProductKey INT,
@ProductCategoryKey INT 
AS
declare @mensagem varchar(100)
 BEGIN
IF NOT EXISTS (SELECT 1 FROM Projeto_CBD.dbo.Product WHERE Projeto_CBD.dbo.Product.ProductID = @ProductKey)
 BEGIN
 
 set @mensagem =( select e.descricao from Projeto_CBD.dbo.Erros e where e.id=16)
 insert into Projeto_CBD.dbo.Log_Erros (Descricao,Data) values (@mensagem,GETUTCDATE());
 PRINT (@mensagem);

 END
ELSE IF not exists (SELECT 1 FROM Projeto_CBD.dbo.ProductCategory WHERE Projeto_CBD.dbo.ProductCategory.CategoryID=@ProductCategoryKey)
BEGIN

 set @mensagem =( select e.descricao from Projeto_CBD.dbo.Erros e where e.id=17)
 insert into Projeto_CBD.dbo.Log_Erros (Descricao,Data) values (@mensagem,GETUTCDATE());
 PRINT (@mensagem);

 END
ELSE
UPDATE Projeto_CBD.dbo.Product
   SET CategoryID=@ProductCategoryKey
 WHERE ProductID = @ProductKey;
 END
 go

 EXEC Produto.AssociarProduto 212,5
 GO


 select * from Projeto_CBD.dbo.ProductCategory;
 go




-- ================================================================================================================================================
-- ================================================================================================================================================
-- ================================================================================================================================================
-- ================================================================================================================================================
--Defina ainda as stored procedures de 
--“Criação de Encomenda/Carrinho”, 
--“Adição de Produto a Encomenda”, 
--“Alteração de Quantidade de Produto na Encomenda” 
--“Remoção de Produto de Encomenda” (poderá ter de considerar o estado e valor da encomenda) 


-- SP que abre uma encomenda
GO
CREATE or alter PROCEDURE Vendas.CreateSale(@idCustomer INT, @CurrencyKey INT, @SalesTerritoryKey INT) AS
	INSERT INTO Projeto_CBD.dbo.Sales(CustomerKey, CurrencyKey, SalesTerritoryKey, OrderDate) VALUES (@idCustomer, @CurrencyKey, @SalesTerritoryKey,GETDATE() )

GO

exec Vendas.CreateSale 11000, 1 , 1 
go
select * from Projeto_CBD.dbo.Sales;
GO
CREATE or alter PROCEDURE Vendas.AddProductToSale(@idProduct INT, @idSale INT) AS
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	BEGIN TRAN
	INSERT INTO Projeto_CBD.dbo.Sales_Product(SalesOrderNumber, ProductKey, UnitPrice, SalesOrderLineNumber, SalesAmount)
	VALUES (@idSale, @idProduct , (SELECT p.StandardCost FROM Projeto_CBD.dbo.Product p WHERE p.ProductID = @idProduct),
	(SELECT sp.SalesOrderLineNumber FROM Projeto_CBD.dbo.Sales_Product sp WHERE sp.SalesOrderNumber = @idSale AND sp.ProductKey = @idProduct), 
	(SELECT p.StandardCost FROM Projeto_CBD.dbo.Product p WHERE p.ProductID = @idProduct)*1);
	COMMIT
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO

EXEC Vendas.AddProductToSale 212 , 75124
go
select * from Projeto_CBD.dbo.Sales_Product;
GO


-- SP para alterar a quantidade de um produto
GO
CREATE or alter PROCEDURE AlterarOrderQuantity(@idProduct INT, @idSale INT, @Quantity INT) AS
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	BEGIN TRAN
	DECLARE @stock INT = (SELECT s.SafetyStockLevel FROM Projeto_CBD.dbo.Product p, Projeto_CBD.dbo.SafetyStock s WHERE p.ProductID = @idProduct and s.SafetyStockID=p.SafetyStockID)
	DECLARE @mensagem varchar (MAX)
	IF @Quantity > @stock 
	BEGIN 
	set @mensagem =( select e.descricao from Projeto_CBD.dbo.Erros e where e.id=12)
	PRINT @mensagem
	END
	ELSE IF (SELECT s.ShipDate FROM Projeto_CBD.dbo.Sales s WHERE s.SalesOrderNumber = @idSale) >= GETDATE() 
	BEGIN 
		
		set @mensagem =( select e.descricao from Projeto_CBD.dbo.Erros e where e.id=13)
		PRINT @mensagem
	END 
	ELSE 
	BEGIN
	UPDATE Projeto_CBD.dbo.Sales_Product SET OrderQuantity=@Quantity WHERE ProductKey = @idProduct AND SalesOrderNumber = @idSale

	UPDATE Projeto_CBD.dbo.Sales_Product SET SalesAmount=@Quantity*UnitPrice WHERE ProductKey = @idProduct AND SalesOrderNumber = @idSale
	
		PRINT 'Quantidade Alterada!'
	END
	COMMIT
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO

EXEC AlterarOrderQuantity 212, 75124 , 2 

GO

select *from Projeto_CBD.dbo.Sales_Product;
go
-- SP para remoção de produto da encomenda
GO
CREATE or alter PROCEDURE RemoverProduct(@idProduct INT, @idSale INT) AS
BEGIN
DECLARE @mensagem varchar (MAX)

--IF(SELECT p.StatusID FROM Projeto_CBD.dbo.Product p WHERE p.ProductID = @idProduct) IS NULL
--BEGIN 
--         set @mensagem =( select e.descricao from Projeto_CBD.dbo.Erros e where e.id=15)
--		 insert into dbo.Log_Erros (Descricao,Data) values (@mensagem,GETUTCDATE());
--		 PRINT @mensagem
		 
--END

	--ELSE 
	IF  (SELECT ShipDate FROM Projeto_CBD.dbo.Sales WHERE SalesOrderNumber = @idSale) > GETDATE() 
	BEGIN
		set @mensagem =( select e.descricao from Projeto_CBD.dbo.Erros e where e.id=13)
		insert into dbo.Log_Erros (Descricao,Data) values (@mensagem,GETUTCDATE());
		PRINT @mensagem
	END 
	ELSE IF (SELECT SalesOrderNumber  FROM Projeto_CBD.dbo.Sales_Product WHERE SalesOrderNumber = @idSale) IS NULL
	BEGIN 
	set @mensagem =( select e.descricao from Projeto_CBD.dbo.Erros e where e.id=14)
	insert into dbo.Log_Erros (Descricao,Data) values (@mensagem,GETUTCDATE());
		PRINT @mensagem
	END

	ELSE 
	BEGIN
	DELETE FROM Projeto_CBD.dbo.Sales_Product WHERE ProductKey = @idProduct AND SalesOrderNumber = @idSale
		PRINT 'Produto Removido!'
	END

	END
GO

--EXEC RemoverProduct 212, 75124
GO


select * from Projeto_CBD.dbo.Sales_Product ;



-- SP para FECHO de  da encomenda
GO
CREATE or alter PROCEDURE FecharEncomenda( @idSale INT) AS
BEGIN
DECLARE @product int= (SELECT  s.ProductKey FROM  Projeto_CBD.dbo.Sales_Product s WHERE s.SalesOrderNumber = @idSale)
DECLARE @Quantity int= (SELECT  s.OrderQuantity FROM  Projeto_CBD.dbo.Sales_Product s WHERE s.SalesOrderNumber = @idSale)

UPDATE Projeto_CBD.dbo.Sales SET DueDate = CURRENT_TIMESTAMP WHERE Sales.SalesOrderNumber = @idSale;
exec  Vendas.AlterarShipDueDate @idSale;


UPDATE Projeto_CBD.dbo.Product SET Projeto_CBD.dbo.Product.Stock-=@Quantity 
WHERE ProductID = @product
END



go
EXEC FecharEncomenda 75124

go











-- ================================================================================================================================================
-- ================================================================================================================================================
-- ================================================================================================================================================
-- ================================================================================================================================================

--Apoio à monitorização  
-- Deverão ainda ser criados para efeitos de apoio à monitorização os seguintes objectos na BD: 
 
-- Uma stored procedure que recorra ao catalogo para gerar entradas numa tabela(s) dedicada(s) 
--onde deve constar a seguinte informação relativa à bases de dados: 
--todos os campos de todas as tabelas, com o seus tipos de dados,
--tamanho respetivo e restrições associadas 
--(no caso de chaves estrangeiras, deve ser inidicada qual a tabela referenciada e o tipo de acção definido para a manutenção da integridade referencial nas operações de “update” e “delete”.

--Deverá manter histórico de alterações do esquema da BD nas sucessivas execuções da usp. 
 
--Uma view que disponibilize os dados relativos à execução mais recente, presentes na tabela do ponto anterior  
 
-- Uma stored procedure que registe, também em tabela dedicada, por cada  tabela da base de dados o seu número de registos e estimativa mais fiável do espaço ocupado. 
--Deverá manter histórico dos resultados das sucessivas execuções da usp. 



DROP PROCEDURE IF EXISTS Monitorizar
GO
CREATE OR ALTER PROCEDURE Monitorizar AS
BEGIN
INSERT INTO Projeto_CBD.dbo.DBInfo(
	column_name,
	table_name,
	length_col,
	constraint_type,
	referenced_table,
	on_delete_action,
	on_update_action
)
SELECT c.COLUMN_NAME, c.TABLE_NAME, COL_LENGTH(c.TABLE_NAME, c.COLUMN_NAME), tc.CONSTRAINT_TYPE, OBJECT_NAME(fk.referenced_object_id), fk.delete_referential_action_desc, fk.update_referential_action_desc FROM INFORMATION_SCHEMA.COLUMNS c 
LEFT JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu ON
c.COLUMN_NAME = ccu.COLUMN_NAME
JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc ON
c.TABLE_NAME = tc.TABLE_NAME
AND ccu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
LEFT JOIN sys.foreign_keys fk ON 
fk.[name] = tc.CONSTRAINT_NAME
WHERE c.TABLE_CATALOG = DB_NAME()

DECLARE @view AS VARCHAR(MAX) = 'CREATE OR ALTER VIEW latestCallMonitor AS SELECT c.COLUMN_NAME, c.TABLE_NAME, COL_LENGTH(c.TABLE_NAME, c.COLUMN_NAME) Length, tc.CONSTRAINT_TYPE, OBJECT_NAME(fk.referenced_object_id) ReferencedT, fk.delete_referential_action_desc, fk.update_referential_action_desc FROM INFORMATION_SCHEMA.COLUMNS c 
LEFT JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu ON
c.COLUMN_NAME = ccu.COLUMN_NAME
JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc ON
c.TABLE_NAME = tc.TABLE_NAME
AND ccu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
LEFT JOIN sys.foreign_keys fk ON 
fk.[name] = tc.CONSTRAINT_NAME
WHERE c.TABLE_CATALOG = DB_NAME()'

EXEC(@view)
END
GO

EXEC Monitorizar;
go
SELECT * FROM Projeto_CBD.dbo.latestCallMonitor;




--SELECT        ProductName.EnglishProductName, Sum(Sales_Product.SalesAmount) as total, Sum(Sales_Product.SalesAmount) as promocao
--FROM            Promotions_Product INNER JOIN
--                         Promotions ON Promotions_Product.PromotionsKey = Promotions.PromotionKey INNER JOIN
--                         Product ON Promotions_Product.ProductKey = Product.ProductID INNER JOIN
--                         ProductName ON Product.ProductNameID = ProductName.ProductNameID INNER JOIN
--                         Sales_Product ON Product.ProductID = Sales_Product.ProductKey INNER JOIN
--                         Sales ON Sales_Product.SalesOrderNumber = Sales.SalesOrderNumber


-- ================================================================================================================================================
-- ================================================================================================================================================
-- ================================================================================================================================================
-- ================================================================================================================================================





GO
DROP PROCEDURE IF EXISTS dbo.ins_dbsize;
GO
CREATE PROCEDURE ins_dbsize
AS
	INSERT INTO Projeto_CBD.dbo.DBsize SELECT OBJECT_NAME(object_id), (avg_record_size_in_bytes * record_count)/1000, record_count
FROM sys.dm_db_index_physical_stats (db_id(),NULL, NULL, NULL, 'sampled') WHERE index_id = 1

GO

EXEC dbo.ins_dbsize
go
SELECT * FROM Projeto_CBD.dbo.DBsize
go