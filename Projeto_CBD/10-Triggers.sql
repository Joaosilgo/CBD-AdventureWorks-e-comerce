USE Projeto_CBD

go

drop trigger if exists codificarPasswordEmail

go
create or alter trigger Utilizador.codificarPasswordEmail on Utilizador.Customer
after insert
as
begin
declare @id int
select @id = i.CustomerKey from inserted i
begin
OPEN SYMMETRIC KEY SymKey1 DECRYPTION BY CERTIFICATE EncryptCert
OPEN SYMMETRIC KEY SymKey2 DECRYPTION BY CERTIFICATE EncryptCert1
UPDATE Utilizador.Customer
SET EncryptPW = ENCRYPTBYKEY(KEY_GUID('SymKey1'), EncryptPW) 
,EncryptEmail = ENCRYPTBYKEY(KEY_GUID('SymKey2'), emailAdress) 
where Utilizador.Customer.CustomerKey = @id
close symmetric key SymKey1
close symmetric key SymKey2
end
end


go








--IF (OBJECT_ID(N'[Vendas].[RedefinirData]') IS NOT NULL)
--BEGIN
--      DROP TRIGGER Vendas.[RedefinirData];
--END;
--go
--create  trigger RedefinirData on Vendas.HistoricoContas
--after update
--as
--begin
--update

--Projeto_CBD.Vendas.HistoricoContas

--set ContasDate = getdate();

--end









--IF (OBJECT_ID(N'[Vendas].[valorDesconto]') IS NOT NULL)
--BEGIN
--      DROP TRIGGER Vendas.[valorDesconto];
--END;
--go
--create  trigger Vendas.[valorDesconto] on Vendas.PromocaoProduto
--after update, insert
--as
--begin
--	declare @id cursor
--	declare @idusado int
--	set @id = cursor for (select c.[PromocaoProdutoId] from  Vendas.PromocaoProduto c );
--	open @id;
--	fetch next from @id into @idusado
--	WHILE @@FETCH_STATUS = 0
--	update

--Projeto_CBD.Vendas.PromocaoProduto


--	SELECT TOP(1) MAX(z.PromocaoDesconto) FROM Vendas.PromocaoProduto b , Vendas.Promocao z WHERE z.PromocaoId=b.PromocaoId and  b.ProductId IN
--  (SELECT a.ProductId FROM Vendas.PromocaoProduto a GROUP BY a.ProductId HAVING COUNT(*) > 1)
	
--	begin
--end

go


go

















CREATE or alter TRIGGER dbo.SendNotification
ON Projeto_CBD.dbo.Promotions_Product
AFTER INSERT AS
	DECLARE @message VARCHAR(50)

	SELECT @message = 'Promocao ' + p.PromotionName +' '+CAST(pp.Percentage AS varchar ) +' % para o Produto ' + pn.EnglishProductName
	FROM inserted i 
	JOIN Projeto_CBD.dbo.Promotions p ON i.PromotionsKey = p.PromotionKey 
	JOIN Projeto_CBD.dbo.Product pr ON pr.ProductID = i.ProductKey 
	JOIN Projeto_CBD.dbo.ProductName pn ON pn.ProductNameID = pr.ProductNameID
	JOIN Projeto_CBD.dbo.Promotions_Product pp on pp.ProductKey=pr.ProductID

	INSERT INTO Projeto_CBD.dbo.PromoMessage(
		[MessageText],
		[CustomerKey]
	)
	SELECT @message, vip.CustomerKey FROM Projeto_CBD.Utilizador.VIPCustomer vip
GO





