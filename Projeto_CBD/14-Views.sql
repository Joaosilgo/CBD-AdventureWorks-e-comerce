--2.2.1 
--1. Qual o volume de vendas por Subcategoria em trimestres homologos entre os ultimos 3 anos
--2. Calcular por produto o volume de vendas total e o volume de vendas efetuado em promoção
--3. Qual percentagem de vendas por produto efetuada com promoção
--4. Qual o volume de vendas por produto, considerando o Top 10, em trimestres homologos entre
--os ultimos 3 anos
--5. Prazo médio entre data de encomenda e envio por Região Geográfica, (consideração dos
--ultimos 2 anos)
--6. Stored procedure que realiza o fecho de cada ano inscrevendo numa tabela de arquivo o valor
--total gasto por Cliente em cada ano e onde figura também o seu YearlyIncome
--7. Criar uma view (e.g. vPromoBlackFriday) por cada promoção, com a lista de produtos que foi
--adquirida (vendas) durante a promoção:
--Nome do produto (inglês), Categoria, quantidade vendida, valor total vendido (com a
--promoção incluída), território da venda


--check 1,2,3,4,5,6
use Projeto_CBD
go

	
---- ================================================================================================================================================
---- ================================================================================================================================================
---- ================================================================================================================================================
---- ================================================================================================================================================
go
drop index if exists Sales_Product_Amount ON [dbo].[Sales_Product]
go	
CREATE NONCLUSTERED INDEX [Sales_Product_Amount] ON [dbo].[Sales_Product]
(
	[ProductKey] ASC
)
INCLUDE ( [SalesAmount]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go
drop index if exists Promotion_Product ON [dbo].Promotions_Product
go
CREATE NONCLUSTERED INDEX Promotion_Product ON [dbo].Promotions_Product
(
	[ProductKey] ASC
)
 WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]


go
drop index if exists [Sales_Date] ON [dbo].[Sales]
go
CREATE NONCLUSTERED INDEX [Sales_Date] ON [dbo].[Sales]
(
	OrderDate ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = off, ONLINE = OFF) ON [PRIMARY]

go
drop index if exists [Sales_Territory] ON [dbo].[Sales]
go
CREATE NONCLUSTERED INDEX [Sales_Territory] ON [dbo].[Sales]
(
	[SalesTerritoryKey] ASC
)
WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]


----2.2.1 1. Qual o volume de vendas por Subcategoria em trimestres homologos entre os ultimos 3 anos
go
CREATE OR ALTER VIEW vendasSubCategoriaTrimestres AS
	SELECT pcn.EnglishCategoryName, SUM(sp.SalesAmount) VolumeVendas FROM Projeto_CBD.dbo.Sales s
	JOIN Projeto_CBD.dbo.Sales_Product sp ON
	sp.SalesOrderNumber = s.SalesOrderNumber
	JOIN Projeto_CBD.dbo.Product p ON
	p.ProductID = sp.ProductKey
	JOIN Projeto_CBD.dbo.ProductCategory pc ON
	p.CategoryID = pc.CategoryID 
	JOIN Projeto_CBD.dbo.ProductCategoryName pcn ON
	pcn.ProductCategoryNameID = pc.ProductCategoryNameID
	WHERE MONTH(s.OrderDate) BETWEEN 1 AND 3
	AND DATEDIFF(year, s.OrderDate, '2017/01/01') <= 3
	GROUP BY pcn.EnglishCategoryName 
GO

SELECT * FROM vendasSubCategoriaTrimestres

go





---- ================================================================================================================================================
---- ================================================================================================================================================
---- ================================================================================================================================================
---- ================================================================================================================================================

----2.2.1 2. Calcular por produto o volume de vendas total e o volume de vendas efetuado em promoção



    --SELECT  product_name.EnglishProductName as NomeDoProduto, Sum(sales_product.SalesAmount) TotaldeVendas
    --from ProductName product_name, Sales_Product sales_product, Projeto_CBD.dbo.Sales sales, Projeto_CBD.dbo.Product product
	--where product_name.ProductNameID=product.ProductNameID and 
	--sales_product.ProductKey=product.ProductID and
	--sales_product.SalesOrderNumber = sales.SalesOrderNumber
	--GROUP BY    product_name.EnglishProductName
	--go
	

	--SELECT	product_name.EnglishProductName as NomeDoProdutos , Sum(sales_product.SalesAmount) TotaldeVendasPromocao
	--from Promotions promo, Promotions_Product promo_product, Product product, Sales_Product sales_product, Sales sales, ProductName product_name
	--where 
	--promo.PromotionKey=promo_product.PromotionsKey and
	--promo_product.ProductKey=product.ProductID and 
	--product.ProductID=sales_product.ProductKey and 
	--sales_product.SalesOrderNumber=sales.SalesOrderNumber and
	--product_name.ProductNameID=product.ProductNameID  
	--GROUP BY product_name.EnglishProductName




	go
	Drop view if exists Vendas_Total_PromocaoPorProduto
	go
 CREATE OR ALTER VIEW Vendas_Total_PromocaoPorProduto AS
    SELECT  t1.NomeDoProduto, t1.TotaldeVendas, t2.NomeDoProdutos,t2.TotaldeVendasPromocao
    FROM (SELECT  product_name.EnglishProductName as NomeDoProduto, Sum(sales_product.SalesAmount) TotaldeVendas
    from ProductName product_name, Sales_Product sales_product, Projeto_CBD.dbo.Sales sales, Projeto_CBD.dbo.Product product
	where product_name.ProductNameID=product.ProductNameID and 
	sales_product.ProductKey=product.ProductID and
	sales_product.SalesOrderNumber = sales.SalesOrderNumber
	GROUP BY    product_name.EnglishProductName) as t1,
	(SELECT	product_name.EnglishProductName as NomeDoProdutos , Sum(sales_product.SalesAmount) TotaldeVendasPromocao
	from Promotions promo, Promotions_Product promo_product, Product product, Sales_Product sales_product, Sales sales, ProductName product_name
	where 
	promo.PromotionKey=promo_product.PromotionsKey and
	promo_product.ProductKey=product.ProductID and 
	product.ProductID=sales_product.ProductKey and 
	sales_product.SalesOrderNumber=sales.SalesOrderNumber and
	product_name.ProductNameID=product.ProductNameID  
	GROUP BY product_name.EnglishProductName) as t2
  -- WHERE t1.NomeDoProduto = t2.NomeDoProduto
  GO
SELECT * FROM Vendas_Total_PromocaoPorProduto













---- ================================================================================================================================================
---- ================================================================================================================================================
---- ================================================================================================================================================
---- ================================================================================================================================================

----2.2.1 3. Qual percentagem de vendas por produto efetuada com promoção




go
	Drop view if exists PercentagemVendasComPromocao
	go
 CREATE OR ALTER VIEW PercentagemVendasComPromocao AS
Select product_name.EnglishProductName as  NomeDoProduto, ((select count(*) from Promotions_Product)/**sales_product.OrderQuantity*/ * 100.0 / (select count(*) from Sales_Product) )*100 as Score
from Promotions promo, Promotions_Product promo_product, Product product, Sales_Product sales_product, Sales sales, ProductName product_name
	where 
	promo.PromotionKey=promo_product.PromotionsKey and
	promo_product.ProductKey=product.ProductID and 
	product.ProductID=sales_product.ProductKey and 
	sales_product.SalesOrderNumber=sales.SalesOrderNumber and
	product_name.ProductNameID=product.ProductNameID  
	GROUP BY product_name.EnglishProductName,sales_product.OrderQuantity 
	go
	--visto temos 1 produto com promoção e 60399 



	SELECT * FROM PercentagemVendasComPromocao

	go

-- ================================================================================================================================================
-- ================================================================================================================================================
-- ================================================================================================================================================
-- ================================================================================================================================================
--2.2.1 4. Qual o volume de vendas por produto, considerando o Top 10, em trimestres homologos entre
--os ultimos 3 anos


CREATE OR ALTER VIEW vendasProdutoTrimestres AS
	SELECT TOP 10 pn.EnglishProductName, SUM(sp.SalesAmount) VolumeVendas FROM Projeto_CBD.dbo.Sales s
	JOIN Projeto_CBD.dbo.Sales_Product sp ON
	sp.SalesOrderNumber = s.SalesOrderNumber
	JOIN Projeto_CBD.dbo.Product p ON
	p.ProductID = sp.ProductKey
	JOIN Projeto_CBD.dbo.ProductName pn ON
	pn.ProductNameID = p.ProductNameID
	WHERE MONTH(s.OrderDate) BETWEEN 1 AND 3
	AND DATEDIFF(year, s.OrderDate, '2017/01/01') <= 3
	GROUP BY pn.EnglishProductName
	ORDER BY VolumeVendas DESC
GO
SELECT * FROM vendasProdutoTrimestres

GO

-- ================================================================================================================================================
-- ================================================================================================================================================
-- ================================================================================================================================================
-- ================================================================================================================================================
--5. Prazo médio entre data de encomenda e envio por Região Geográfica, (consideração dos
--ultimos 2 anos)

CREATE OR ALTER VIEW prazoMedioEncomendaEnvio AS
	SELECT st.SalesTerritoryKey, cast (AVG(DATEDIFF(day, s.OrderDate, s.ShipDate)) as varchar(50))+' Dias' PrazoMedioDias FROM Projeto_CBD.dbo.Sales s
	JOIN Projeto_CBD.dbo.SalesTerritory st ON
	s.SalesTerritoryKey = st.SalesTerritoryKey
	WHERE DATEDIFF(YEAR, '2017/01/01', s.OrderDate) <= 2
	GROUP BY st.SalesTerritoryKey
GO

SELECT * FROM prazoMedioEncomendaEnvio

go


--6. Stored procedure que realiza o fecho de cada ano inscrevendo numa tabela de arquivo o valor
--total gasto por Cliente em cada ano e onde figura também o seu YearlyIncome

CREATE OR ALTER PROCEDURE fechoAnualVendas(@year INT) AS
	BEGIN TRAN
	INSERT INTO Projeto_CBD.dbo.ArquivoVendas(
		[year],
		[CustomerKey],
		[YearlyIncome],
		[spent]
	) 
	SELECT YEAR(s.OrderDate), c.CustomerKey, c.YearIncome, SUM(sp.SalesAmount) FROM Projeto_CBD.dbo.Sales s WITH (TABLOCK, HOLDLOCK)
	JOIN Projeto_CBD.Utilizador.Customer c ON
	c.CustomerKey = s.CustomerKey
	JOIN Sales_Product sp ON 
	s.SalesOrderNumber = sp.SalesOrderNumber
	WHERE YEAR(s.OrderDate) = @year
	GROUP BY YEAR(s.OrderDate), c.CustomerKey, c.YearIncome
	COMMIT
GO

EXEC Projeto_CBD.dbo.fechoAnualVendas 2016
go

select * from Projeto_CBD.dbo.ArquivoVendas;