-----------------------------------------DATA MIGRATION ---------------------------------------

--countryregion
INSERT INTO Projeto_CBD.Utilizador.CountryRegion
(
	[CountryRegionCode],
	[CountryRegionName]
)
SELECT t.CountryRegionCode,t.CountryRegionName
FROM AdventureWorks_MixData.dbo.Customer t
GROUP BY t.CountryRegionCode,t.CountryRegionName

--stateprovince
INSERT INTO Projeto_CBD.Utilizador.StateProvince
(
	[StateProvinceCode],
	[StateProvinceName],
	[CountryRegionID]
)
SELECT t.StateProvinceCode, t.StateProvinceName, cr.CountryRegionID
FROM AdventureWorks_MixData.dbo.Customer t
JOIN Projeto_CBD.Utilizador.CountryRegion cr on
cr.CountryRegionCode  = t.CountryRegionCode 
GROUP BY t.StateProvinceCode,t.StateProvinceName, cr.CountryRegionID;
 

--Currency
INSERT INTO Projeto_CBD.dbo.Currency
(
	[CurrencyName],
	[CurrencyAlternateKey]
)
SELECT c.CurrencyName,c.CurrencyAlternateKey
FROM AdventureWorks_MixData.dbo.Currency c
GROUP BY c.CurrencyName,c.CurrencyAlternateKey

--SalesTerritory
INSERT INTO Projeto_CBD.dbo.SalesTerritory
(
	[SalesTerritoryCountry],
	[SalesTerritoryGroup],
	[SalesTerritoryRegion]
)
SELECT st.SalesTerritoryCountry,st.SalesTerritoryGroup,st.SalesTerritoryRegion
FROM AdventureWorks_MixData.dbo.SalesTerritory st
GROUP BY st.SalesTerritoryCountry,st.SalesTerritoryGroup,st.SalesTerritoryRegion

--ProductSize
INSERT INTO Projeto_CBD.dbo.ProductSize
(
	[Size],
	[SizeRange],
	[SizeUnitMeasureCode]
)
SELECT p.Size,p.SizeRange,p.SizeUnitMeasureCode
FROM AdventureWorks_MixData.dbo.Product p
GROUP BY p.Size,p.SizeRange,p.SizeUnitMeasureCode

--LargePhoto
INSERT INTO Projeto_CBD.dbo.LargePhoto
(
	[PhotoBytes]
)
SELECT DISTINCT p.LargePhoto
FROM AdventureWorks_MixData.dbo.Product p
where LargePhoto is not null

--SafetyStock
INSERT INTO Projeto_CBD.dbo.SafetyStock
(
	[SafetyStockLevel]
)
SELECT DISTINCT p.SafetyStockLevel
FROM AdventureWorks_MixData.dbo.Product p
where SafetyStockLevel is not null


--status
INSERT INTO Projeto_CBD.dbo.[Status]
(
	[StatusType]
)
SELECT DISTINCT p.[Status]
FROM AdventureWorks_MixData.dbo.Product p
where [Status] is not null

--adress
INSERT INTO Projeto_CBD.Utilizador.Adress
(
	[AdressLine1],
	[AdressLine2],
	[City],
	[PostalCode],
	[StateProvinceID]
)
SELECT t.AddressLine1,t.AddressLine2,t.City,t.PostalCode, s.StateProvinceID
FROM AdventureWorks_MixData.dbo.Customer t
JOIN Projeto_CBD.Utilizador.StateProvince s on
s.StateProvinceName like t.StateProvinceName
GROUP BY t.AddressLine1,t.AddressLine2,t.City,t.PostalCode, s.StateProvinceID

--customer
use master
INSERT INTO Projeto_CBD.Utilizador.Customer
(

	
	FirstName ,
	LastName ,
	MiddleName, 
	NameStyle ,
	BirthDate ,
	EmailAdress, 
	YearIncome ,
	TotalChildren, 
	NumberChildrenAtHome, 
	HouseOwnerFlag ,
	NumberCarsOwned ,
	DateFirstPurchase,
	CommuteDistance ,
	[Password] ,
	Phone ,
	TitleName, 
	MaritalStatusName, 
	GenderName ,
	EducationName, 
	OccupationName

)

SELECT 

c.FirstName ,
	c.LastName ,
	c.MiddleName, 
	c.NameStyle ,
	c.BirthDate ,
	c.EmailAddress, 
	c.YearlyIncome ,
	c.TotalChildren, 
	c.NumberChildrenAtHome, 
	c.HouseOwnerFlag ,
	c.NumberCarsOwned ,
	c.DateFirstPurchase,
	c.CommuteDistance ,
	'novapass',
	--HASHBYTES('sha1','novapass') ,
	c.Phone ,
	c.Title, 
	c.MaritalStatus, 
	c.Gender ,
	c.Education, 
	c.Occupation
FROM AdventureWorks_MixData.dbo.Customer c
 WHERE NOT EXISTS (Select *
	From  Projeto_CBD.Utilizador.Customer WHERE Projeto_CBD.Utilizador.Customer.CustomerKey = c.CustomerKey);
	
--customer_adress
INSERT INTO Projeto_CBD.Utilizador.Customer_Adress
(
	[CustomerKey],
	[AdressID]
	
)
SELECT c.CustomerKey, a.AdressID FROM Projeto_CBD.Utilizador.Adress a
JOIN Projeto_CBD.Utilizador.StateProvince st ON
a.StateProvinceID = st.StateProvinceID
JOIN Projeto_CBD.Utilizador.CountryRegion cr ON
st.CountryRegionID = st.CountryRegionID
JOIN AdventureWorks_MixData.dbo.Customer c ON
c.AddressLine1 = a.AdressLine1 AND a.City = c.City AND c.PostalCode = a.PostalCode AND (a.AdressLine2 = c.AddressLine2 OR (a.AdressLine2 IS NULL AND c.AddressLine2 IS NULL))
AND c.CountryRegionCode = cr.CountryRegionCode AND c.StateProvinceCode = st.StateProvinceCode

--ProductCategoryName
INSERT INTO Projeto_CBD.dbo.ProductCategoryName
(
	[EnglishCategoryName],
	[SpanishProductCategory],
	[FrenchProductCategory]
)
SELECT p.EnglishProductCategoryName, p.FrenchProductCategoryName,p.SpanishProductCategoryName
FROM AdventureWorks_MixData.dbo.Product p
GROUP BY p.EnglishProductCategoryName, p.FrenchProductCategoryName,p.SpanishProductCategoryName

--Para as subcategorias
INSERT INTO Projeto_CBD.dbo.ProductCategoryName
(
	[EnglishCategoryName],
	[SpanishProductCategory],
	[FrenchProductCategory]
)
SELECT p.EnglishProductSubcategoryName, p.FrenchProductSubcategoryName,p.SpanishProductSubcategoryName
FROM AdventureWorks_MixData.dbo.ProductSubcategory p
GROUP BY p.EnglishProductSubcategoryName, p.FrenchProductSubcategoryName,p.SpanishProductSubcategoryName

--productCategory
INSERT INTO Projeto_CBD.dbo.ProductCategory
(
	[ProductCategoryNameID]
)
SELECT Distinct pcn.ProductCategoryNameID FROM Projeto_CBD.dbo.ProductCategoryName pcn
JOIN AdventureWorks_MixData.dbo.Product p ON
pcn.EnglishCategoryName = p.EnglishProductCategoryName

--subcategorias
INSERT INTO Projeto_CBD.dbo.ProductCategory
(
	[ProductCategoryNameID],
	[SubCategoryID]
)
SELECT pcn.ProductCategoryNameID, pc.CategoryID  FROM AdventureWorks_MixData.dbo.Product p 
JOIN AdventureWorks_MixData.dbo.ProductSubcategory ps ON
ps.ProductSubcategoryKey = p.ProductSubcategoryKey
JOIN Projeto_CBD.dbo.ProductCategoryName pcn ON
pcn.EnglishCategoryName = ps.EnglishProductSubcategoryName
JOIN Projeto_CBD.dbo.ProductCategoryName pcn2 ON
pcn2.EnglishCategoryName = p.EnglishProductCategoryName
JOIN Projeto_CBD.dbo.ProductCategory pc ON
pc.ProductCategoryNameID = pcn2.ProductCategoryNameID
GROUP BY pcn.ProductCategoryNameID, pc.CategoryID
GO
--sales
SET IDENTITY_INSERT Projeto_CBD.dbo.Sales ON
GO
INSERT INTO Projeto_CBD.dbo.Sales
(
	[CurrencyKey],
	[CustomerKey],
	[DueDate],
	[OrderDate],
	[SalesTerritoryKey],
	[ShipDate],
	[SalesOrderNumber]
)
SELECT s.CurrencyKey, s.CustomerKey, s.DueDate, s.OrderDate,
st.SalesTerritoryKey, s.ShipDate, CAST(SUBSTRING(s.SalesOrderNumber, 3, LEN(s.SalesOrderNumber)) AS INT)
FROM AdventureWorks_MixData.dbo.Sales s
JOIN Projeto_CBD.dbo.SalesTerritory st on
st.SalesTerritoryCountry = s.SalesTerritoryCountry and st.SalesTerritoryRegion = s.SalesTerritoryRegion
JOIN AdventureWorks_MixData.dbo.SalesTerritory stMixData on
st.SalesTerritoryKey = stMixData.SalesTerritoryKey
GROUP BY s.CurrencyKey, s.CustomerKey, s.DueDate, s.OrderDate,
st.SalesTerritoryKey, s.ShipDate, s.SalesOrderNumber
GO
SET IDENTITY_INSERT Projeto_CBD.dbo.Sales off
GO
--description
INSERT INTO Projeto_CBD.dbo.[Description]
(
	[ChineseDescription],
	[EnglishDescription],
	[FrenchDescription]
)
SELECT p.ChineseDescription , p.EnglishDescription , p.FrenchDescription
FROM AdventureWorks_MixData.dbo.Product p
where p.EnglishDescription is not null
group by p.ChineseDescription , p.EnglishDescription , p.FrenchDescription

--ProductName
INSERT INTO Projeto_CBD.dbo.ProductName
(
	[EnglishProductName],
	[FrenchProductName],
	[SpanishProductName]
)
SELECT p.EnglishProductName, p.FrenchProductName , p.SpanishProductName
FROM AdventureWorks_MixData.dbo.Product p
group by p.EnglishProductName, p.FrenchProductName , p.SpanishProductName

--Product
INSERT INTO Projeto_CBD.dbo.Product
(
	
	ListPrice ,
	StandardCost ,
	WeightUnitMeasureCode ,
	FinishedGoodsFlag ,
	[Weight] ,
	DealerPrice ,
	ModelName ,
	CategoryID ,
	StatusID ,
	SafetyStockID ,
	PhotoID ,
	SizeID ,
	DescriptionID ,
	ProductNameID ,
	ProductLine,
	ColorName ,
	DaysToManufacture ,
	ClassName ,
	StyleType ,
	Stock


)

select p.ListPrice ,
	p.StandardCost ,
	p.WeightUnitMeasureCode ,
	p.FinishedGoodsFlag ,
	p.[Weight] ,
	p.DealerPrice ,
	p.ModelName ,
	pc2.CategoryID ,
	stat.StatusID ,
	st.SafetyStockID ,
	photo.PhotoID ,
	ps.SizeID ,
	[Description].DescriptionID ,
	pn.ProductNameID ,
	p.ProductLine,
	p.Color ,
	p.DaysToManufacture ,
	p.Class ,
	p.Style ,
	1000

FROM AdventureWorks_MixData.dbo.Product p
JOIN Projeto_CBD.dbo.ProductCategoryName pcn ON 
pcn.EnglishCategoryName = p.EnglishProductCategoryName
JOIN Projeto_CBD.dbo.ProductCategory pc ON
pc.ProductCategoryNameID = pcn.ProductCategoryNameID
JOIN AdventureWorks_MixData.dbo.ProductSubcategory psc ON
p.ProductSubcategoryKey = psc.ProductSubcategoryKey 
JOIN Projeto_CBD.dbo.ProductCategoryName pcn2 ON
pcn2.EnglishCategoryName = psc.EnglishProductSubcategoryName
JOIN Projeto_CBD.dbo.ProductCategory pc2 ON
pc2.ProductCategoryNameID = pcn2.ProductCategoryNameID

LEFT JOIN Projeto_CBD.dbo.[Status] stat on
stat.StatusType = p.[Status]




JOIN Projeto_CBD.dbo.SafetyStock st on
st.SafetyStockLevel = p.SafetyStockLevel
JOIN Projeto_CBD.dbo.LargePhoto photo on
photo.PhotoBytes = p.LargePhoto

LEFT JOIN Projeto_CBD.dbo.ProductSize ps on
ps.Size = p.Size and ps.SizeRange = p.SizeRange and ps.SizeUnitMeasureCode = p.SizeUnitMeasureCode

LEFT JOIN Projeto_CBD.dbo.[Description] on
[Description].EnglishDescription = p.EnglishDescription

JOIN Projeto_CBD.dbo.ProductName pn on
pn.EnglishProductName LIKE p.EnglishProductName


--group by class.ClassID, color.ColorID, [days].DaysID, p.DealerPrice, [Description].DescriptionID, p.FinishedGoodsFlag, p.ListPrice,
--p.ModelName, photo.PhotoID, pl.ProductLineID, pn.ProductNameID, st.SafetyStockID, ps.SizeID, p.StandardCost, stat.StatusID, style.StyleID, p.[Weight], p.WeightUnitMeasureCode

SELECT * FROM Projeto_CBD.dbo.Product

--sales_product
INSERT INTO Projeto_CBD.dbo.Sales_Product
(
	[ProductKey],
	[SalesOrderNumber],
	[UnitPrice],
	[OrderQuantity],
	[SalesOrderLineNumber],
	[SalesAmount]
)
SELECT p.ProductKey, s.SalesOrderNumber, sm.UnitPrice, sm.OrderQuantity, sm.SalesOrderLineNumber, sm.SalesAmount  FROM Projeto_CBD.dbo.Sales s
JOIN AdventureWorks_MixData.dbo.Sales sm ON
CAST(SUBSTRING(sm.SalesOrderNumber, 3, LEN(sm.SalesOrderNumber)) AS INT) = s.SalesOrderNumber
JOIN AdventureWorks_MixData.dbo.Product p ON
p.ProductKey = sm.ProductKey;
go


