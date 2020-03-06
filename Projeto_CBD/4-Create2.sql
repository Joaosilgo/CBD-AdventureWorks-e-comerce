USE Projeto_CBD

CREATE TABLE Utilizador.Customer (
	CustomerKey integer NOT NULL PRIMARY KEY IDENTITY(11000,1),--11000
	FirstName varchar(50) NOT NULL,
	LastName varchar(50) NOT NULL,
	MiddleName varchar(50),
	NameStyle bit NOT NULL,
	BirthDate date NOT NULL,
	EmailAdress varchar(50) UNIQUE NOT NULL,
	YearIncome numeric(19,4) NOT NULL,
	TotalChildren tinyint NOT NULL,
	NumberChildrenAtHome tinyint NOT NULL,
	HouseOwnerFlag char NOT NULL,
	NumberCarsOwned tinyint NOT NULL,
	DateFirstPurchase date NOT NULL,
	CommuteDistance varchar(15) NOT NULL,
--	[Password] varbinary(128) NOT NULL,
   [Password] varchar(128) NOT NULL,
	Phone varchar(20) NOT NULL,
	TitleName nvarchar(20)  ,
	MaritalStatusName char(1)  NOT NULL,
	GenderName nvarchar(40)  NOT NULL,
	EducationName varchar(40)  NOT NULL,
	OccupationName varchar(100)  NOT NULL,
);

CREATE TABLE Utilizador.NormalCustomer (
	NCustomerID integer NOT NULL PRIMARY KEY IDENTITY(1,1),
	CustomerKey integer NOT NULL,
);

CREATE TABLE Utilizador.VIPCustomer (
	VIPCustomerID integer NOT NULL PRIMARY KEY IDENTITY(1,1),
	CustomerKey integer NOT NULL,
);

CREATE TABLE Utilizador.Customer_Adress (
	CustomerKey integer NOT NULL,
	AdressID integer NOT NULL,
	PRIMARY KEY (CustomerKey,AdressID),
);

CREATE TABLE Utilizador.Adress (
	AdressID integer NOT NULL PRIMARY KEY IDENTITY(1,1),
	AdressLine1 varchar(120) NOT NULL,
	AdressLine2 varchar(120),
	City varchar(30) NOT NULL,
	PostalCode varchar(15) NOT NULL,
	StateProvinceID integer NOT NULL,
);

CREATE TABLE Utilizador.StateProvince (
	StateProvinceID integer NOT NULL PRIMARY KEY IDENTITY(1,1),
	StateProvinceCode varchar(3) NOT NULL UNIQUE,
	StateProvinceName nvarchar(50) COLLATE   DATABASE_DEFAULT NOT NULL UNIQUE ,
	CountryRegionID integer NOT NULL,
);

CREATE TABLE Utilizador.CountryRegion (
	CountryRegionID integer NOT NULL PRIMARY KEY IDENTITY(1,1),
	CountryRegionCode varchar(3) NOT NULL UNIQUE,
	CountryRegionName varchar(50) NOT NULL UNIQUE,
);

CREATE TABLE Currency (
	CurrencyKey integer NOT NULL PRIMARY KEY IDENTITY(1,1),
	CurrencyAlternateKey char(3) NOT NULL UNIQUE,
	CurrencyName varchar(50) NOT  NULL UNIQUE,
);

CREATE TABLE ProductSize (
	SizeID integer NOT NULL PRIMARY KEY IDENTITY(1,1),
	Size varchar(50) ,
	SizeRange varchar(50) NOT NULL,
	SizeUnitMeasureCode varchar(3),
);

CREATE TABLE LargePhoto (
	PhotoID integer NOT NULL PRIMARY KEY IDENTITY(1,1),
	PhotoBytes varbinary(max) NOT NULL,
);

CREATE TABLE SafetyStock( 
	SafetyStockID integer NOT NULL PRIMARY KEY IDENTITY(1,1),
	SafetyStockLevel smallint NOT NULL UNIQUE,
);



CREATE TABLE [Status] ( 
	StatusID integer NOT NULL PRIMARY KEY IDENTITY(1,1),
	StatusType varchar(7) NOT NULL ,
);

CREATE TABLE ProductCategoryName (
	ProductCategoryNameID integer NOT NULL PRIMARY KEY IDENTITY(1,1),
	EnglishCategoryName nvarchar(50) NOT NULL ,
	SpanishProductCategory nvarchar(50) NOT NULL ,
	FrenchProductCategory nvarchar(50) NOT NULL ,
);

CREATE TABLE ProductCategory (
	CategoryID integer NOT NULL PRIMARY KEY IDENTITY(1,1),
	ProductCategoryNameID integer NOT NULL,
	SubCategoryID integer,
);

CREATE TABLE [Description] (
	DescriptionID integer NOT NULL PRIMARY KEY IDENTITY(1,1),
	EnglishDescription nvarchar(400),
	ChineseDescription nvarchar(400),
	FrenchDescription nvarchar(400),
);

CREATE TABLE ProductName (
	ProductNameID integer NOT NULL PRIMARY KEY IDENTITY(1,1),
	EnglishProductName nvarchar(255) NOT NULL,
	FrenchProductName nvarchar(50) NOT NULL,
	SpanishProductName nvarchar(50) NOT NULL,
);

CREATE TABLE Product (
	ProductID integer NOT NULL PRIMARY KEY IDENTITY(210,1), 
	ListPrice money,
	StandardCost money,
	WeightUnitMeasureCode NCHAR(3),
	FinishedGoodsFlag bit NOT NULL,
	[Weight] float,
	DealerPrice money,
	ModelName nvarchar(50) NOT NULL,
	CategoryID integer NOT NULL,
	StatusID integer,
	SafetyStockID integer NOT NULL,
	PhotoID integer NOT NULL,
	SizeID integer,
	DescriptionID integer,
	ProductNameID integer NOT NULL,
	ProductLine nchar(2)  ,
	ColorName nvarchar(15) NOT NULL ,
	DaysToManufacture integer NOT NULL ,--tive de inserir para podermos retirar quantidade
	ClassName nchar(2) ,
	StyleType nchar(2) ,
	Stock integer 
	
	
);

CREATE TABLE Promotions (
	PromotionKey integer NOT NULL PRIMARY KEY IDENTITY(1,1),
	PromotionName varchar(100) NOT NULL,
	StartDate date NOT NULL,
	EndDate date NOT NULL,
);

CREATE TABLE Promotions_Product (
	PromotionsKey integer NOT NULL,
	ProductKey integer NOT NULL,
	[Percentage] integer NOT NULL,
	unidades integer
	--número de unidades de cada produto disponível para promoção 
	PRIMARY KEY(PromotionsKey,ProductKey),
);

CREATE TABLE SalesTerritory (
	SalesTerritoryKey integer NOT NULL PRIMARY KEY IDENTITY(1,1),
	SalesTerritoryRegion varchar(50) NOT NULL,
	SalesTerritoryCountry varchar(50) NOT NULL,
	SalesTerritoryGroup varchar(50),
);

CREATE TABLE Sales_Product (
	SalesOrderNumber integer NOT NULL,
	ProductKey integer NOT NULL,
	SalesAmount money NOT NULL,
	UnitPrice money NOT NULL,
	OrderQuantity integer NOT NULL DEFAULT 1,
	SalesOrderLineNumber tinyint ,
	PRIMARY KEY (SalesOrderNumber,ProductKey),
);


CREATE TABLE Sales (
	SalesOrderNumber integer NOT NULL PRIMARY KEY IDENTITY,
	OrderDate date DEFAULT NULL,
	DueDate date DEFAULT NULL,
	ShipDate date DEFAULT NULL,
	SalesTerritoryKey integer  NOT NULL,
	CurrencyKey integer NOT NULL,
	CustomerKey integer NOT NULL,
);

CREATE TABLE DBInfo(
	column_name VARCHAR(50),
	table_name VARCHAR(50),
	length_col VARCHAR(7),
	constraint_type VARCHAR(25),
	referenced_table VARCHAR(50),
	on_delete_action VARCHAR(25),
	on_update_action VARCHAR(25)
);

CREATE TABLE PromoMessage(
	MessageID INT PRIMARY KEY IDENTITY(1,1),
	MessageText VARCHAR(50) NOT NULL,
	CustomerKey INT NOT NULL
);


CREATE TABLE DBsize(
	table_name VARCHAR(50),
	table_size_kb VARCHAR(25),
	table_record_count VARCHAR(10)
);

CREATE TABLE ArquivoVendas(
	[year] INT NOT NULL,
	CustomerKey INT NOT NULL,
	YearlyIncome NUMERIC(19, 4) NOT NULL,
	spent MONEY NOT NULL
);

------------------------------------CRIAÇAO DAS FOREIGN KEYS----------------------------------------


--normal and vip customer

ALTER TABLE Utilizador.NormalCustomer
ADD FOREIGN KEY (CustomerKey) REFERENCES Utilizador.Customer(CustomerKey) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Utilizador.VIPCustomer
ADD FOREIGN KEY (CustomerKey) REFERENCES Utilizador.Customer(CustomerKey) ON DELETE CASCADE ON UPDATE CASCADE;

--stateprovince
ALTER TABLE Utilizador.StateProvince
ADD FOREIGN KEY (CountryRegionID) REFERENCES Utilizador.CountryRegion(CountryRegionID) ON DELETE CASCADE ON UPDATE CASCADE;

--Adress

ALTER TABLE Utilizador.Adress
ADD FOREIGN KEY (StateProvinceID) REFERENCES Utilizador.StateProvince(StateProvinceID) ON UPDATE CASCADE;


-- Customer_Adress

ALTER TABLE Utilizador.Customer_Adress
ADD FOREIGN KEY (CustomerKey) REFERENCES Utilizador.Customer(CustomerKey) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Utilizador.Customer_Adress
ADD FOREIGN KEY (AdressID) REFERENCES Utilizador.Adress(AdressID) ON DELETE CASCADE ON UPDATE CASCADE;

--productCategory

ALTER TABLE ProductCategory
ADD FOREIGN KEY (SubCategoryID) REFERENCES ProductCategory(CategoryID);

ALTER TABLE ProductCategory
ADD FOREIGN KEY (ProductCategoryNameID) REFERENCES ProductCategoryName(ProductCategoryNameID);

--Product

ALTER TABLE Product
ADD FOREIGN KEY (CategoryID) REFERENCES ProductCategory(CategoryID) ON UPDATE CASCADE;

ALTER TABLE Product
ADD FOREIGN KEY (StatusID) REFERENCES [Status](StatusID) ON DELETE SET NULL ON UPDATE CASCADE;


ALTER TABLE Product
ADD FOREIGN KEY (SafetyStockID) REFERENCES SafetyStock(SafetyStockID) ON UPDATE CASCADE;

--
ALTER TABLE Product
ADD FOREIGN KEY (PhotoID) REFERENCES LargePhoto(PhotoID) ON UPDATE CASCADE;

ALTER TABLE Product
ADD FOREIGN KEY (SizeID) REFERENCES ProductSize(SizeID) ON UPDATE CASCADE;

ALTER TABLE Product
ADD FOREIGN KEY (ProductNameID) REFERENCES ProductName(ProductNameID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Product
ADD FOREIGN KEY (DescriptionID) REFERENCES [Description](DescriptionID) ON UPDATE CASCADE;


--Promotions_Product

ALTER TABLE Promotions_Product
ADD FOREIGN KEY (ProductKey) REFERENCES Product(ProductID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Promotions_Product
ADD FOREIGN KEY (PromotionsKey) REFERENCES Promotions(PromotionKey) ON DELETE CASCADE ON UPDATE CASCADE;

--Sales_Product

ALTER TABLE Sales_Product
ADD FOREIGN KEY (ProductKey) REFERENCES Product(ProductID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Sales_Product
ADD FOREIGN KEY (SalesOrderNumber) REFERENCES Sales(SalesOrderNumber) ON DELETE CASCADE ON UPDATE CASCADE;

--Sales

ALTER TABLE Sales
ADD FOREIGN KEY (CustomerKey) REFERENCES Utilizador.Customer(CustomerKey) ON UPDATE CASCADE;

ALTER TABLE Sales
ADD FOREIGN KEY (CurrencyKey) REFERENCES Currency(CurrencyKey) ON UPDATE CASCADE;

ALTER TABLE Sales
ADD FOREIGN KEY (SalesTerritoryKey) REFERENCES SalesTerritory(SalesTerritoryKey) ON UPDATE CASCADE;

ALTER TABLE PromoMessage
ADD FOREIGN KEY (CustomerKey) REFERENCES Utilizador.Customer(CustomerKey) ON UPDATE CASCADE;

ALTER TABLE ArquivoVendas
ADD FOREIGN KEY (CustomerKey) REFERENCES Utilizador.Customer(CustomerKey) ON UPDATE CASCADE;

