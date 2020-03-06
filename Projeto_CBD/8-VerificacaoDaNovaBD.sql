--2.1.4 Verificação da nova BD



-- 1- total monetário de vendas por ano AdventureWorks
SELECT YEAR(sales.OrderDate) AS 'Ano', SUM(sales.SalesAmount) AS 'Total de Vendas' 
FROM AdventureWorks_MixData.dbo.Sales sales
GROUP BY YEAR(sales.OrderDate);
go

--1.1 total monetário de vendas por ano nossa BD
SELECT YEAR(sales.OrderDate) AS 'Ano', SUM(sales_product.SalesAmount) AS 'Total de Vendas' 
FROM Projeto_CBD.dbo.Sales sales 
JOIN Projeto_CBD.dbo.Sales_Product sales_product ON
sales.SalesOrderNumber = sales_product.SalesOrderNumber 
JOIN Projeto_CBD.dbo.Product p ON
p.ProductID = sales_product.ProductKey
GROUP BY YEAR(sales.OrderDate);
go

-- 2. total monetário de vendas por ano e SalesTerritoryCountry AdventureWorks
SELECT YEAR(sales.OrderDate) AS 'Ano', sales.SalesTerritoryCountry ,SUM(sales.SalesAmount) AS 'Total de Vendas' 
FROM AdventureWorks_MixData.dbo.Sales sales
GROUP BY YEAR(sales.OrderDate), sales.SalesTerritoryCountry
ORDER BY 2, 1;
go

-- 2.1total monetário de vendas por ano e SalesTerritoryCountry para a nossa BD
SELECT YEAR(sales.OrderDate)AS 'Ano', st.SalesTerritoryCountry, SUM(sales_product.SalesAmount) AS 'Total de Vendas'  
FROM Projeto_CBD.dbo.Sales sales 
JOIN Projeto_CBD.dbo.Sales_Product sales_product ON
sales.SalesOrderNumber = sales_product.SalesOrderNumber 
JOIN Projeto_CBD.dbo.Product p ON
p.ProductID = sales_product.ProductKey
JOIN Projeto_CBD.dbo.SalesTerritory st ON
st.SalesTerritoryKey = sales.SalesTerritoryKey
GROUP BY YEAR(sales.OrderDate), st.SalesTerritoryCountry
ORDER BY 2, 1;
go

-- 3. total monetário de vendas por ano e ProductSubCategory AdventureWorks
SELECT YEAR(sales.OrderDate) AS 'Ano', product_subcategoria.EnglishProductSubcategoryName ,SUM(sales.SalesAmount) AS 'Total de Vendas' 
FROM AdventureWorks_MixData.dbo.Sales sales
JOIN AdventureWorks_MixData.dbo.Product product ON
product.ProductKey = sales.ProductKey 
JOIN AdventureWorks_MixData.dbo.ProductSubcategory product_subcategoria ON
product_subcategoria.ProductSubcategoryKey = product.ProductSubcategoryKey
GROUP BY YEAR(sales.OrderDate), product_subcategoria.EnglishProductSubcategoryName
ORDER BY 2, 1;
go

-- 3.1 total monetário de vendas por ano e ProductSubCategory para a nossa BD
SELECT YEAR(sales.OrderDate), product_categoryName.EnglishCategoryName AS 'Produto subcategoria', SUM(sales_product.SalesAmount) AS 'Total de Vendas'
FROM Projeto_CBD.dbo.Sales sales 
JOIN Projeto_CBD.dbo.Sales_Product sales_product ON
sales.SalesOrderNumber = sales_product.SalesOrderNumber 
JOIN Projeto_CBD.dbo.Product product ON
product.ProductID = sales_product.ProductKey
JOIN Projeto_CBD.dbo.ProductCategory product_Category ON 
product_Category.CategoryID = product.CategoryID
JOIN Projeto_CBD.dbo.ProductCategoryName product_categoryName ON
product_categoryName.ProductCategoryNameID = product_Category.ProductCategoryNameID
GROUP BY YEAR(sales.OrderDate), product_categoryName.EnglishCategoryName
ORDER BY 2, 1;
go

-- 4. total monetário de vendas por ano e ProductCategory
SELECT YEAR(sales.OrderDate) AS 'Ano', product.EnglishProductCategoryName AS ' ProductCategory', SUM(sales.SalesAmount) AS 'Total de Vendas' 
FROM AdventureWorks_MixData.dbo.Sales sales
JOIN AdventureWorks_MixData.dbo.Product product ON
product.ProductKey = sales.ProductKey
GROUP BY YEAR(sales.OrderDate), product.EnglishProductCategoryName
ORDER BY 2, 1;
go

--4.1 total monetário de vendas por ano e ProductSubCategory para a nossa BD
SELECT YEAR(sales.OrderDate) AS 'Order Date', product_category_name.EnglishCategoryName AS 'product_category_name', SUM(sales_product.SalesAmount)    AS 'Total de Vendas' 
FROM Projeto_CBD.dbo.Sales sales 
JOIN Projeto_CBD.dbo.Sales_Product sales_product ON
sales.SalesOrderNumber = sales_product.SalesOrderNumber 
JOIN Projeto_CBD.dbo.Product product ON
product.ProductID = sales_product.ProductKey
JOIN Projeto_CBD.dbo.ProductCategory productCategory ON 
productCategory.CategoryID = product.CategoryID
JOIN Projeto_CBD.dbo.ProductCategory productCategory2 ON
productCategory2.CategoryID = productCategory.SubCategoryID
JOIN Projeto_CBD.dbo.ProductCategoryName product_category_name ON
product_category_name.ProductCategoryNameID = productCategory2.ProductCategoryNameID
GROUP BY YEAR(sales.OrderDate), product_category_name.EnglishCategoryName
ORDER BY 2, 1;
go

--5. Numero de clientes por ano e salesTerritoryCountry AdventureWorks
SELECT sales_territory.SalesTerritoryCountry, COUNT(c.CustomerKey) AS 'Número de Clientes' FROM AdventureWorks_MixData.dbo.Customer c 
JOIN AdventureWorks_MixData.dbo.SalesTerritory sales_territory ON
sales_territory.SalesTerritoryKey = c.SalesTerritoryKey
GROUP BY sales_territory.SalesTerritoryCountry
ORDER BY 1;
go

--5.1 Numero de clientes por ano e salesTerritoryCountry para a nossa BD
SELECT cr.CountryRegionName, COUNT(c.CustomerKey)  FROM Projeto_CBD.Utilizador.Customer c
JOIN Projeto_CBD.Utilizador.Customer_Adress ca ON
ca.CustomerKey = c.CustomerKey
JOIN Projeto_CBD.Utilizador.Adress a ON
a.AdressID = ca.AdressID 
JOIN Projeto_CBD.Utilizador.StateProvince sp ON
sp.StateProvinceID = a.StateProvinceID 
JOIN Projeto_CBD.Utilizador.CountryRegion cr ON
cr.CountryRegionID = sp.CountryRegionID
GROUP BY cr.CountryRegionName
ORDER BY 1;
go