use Projeto_CBD;

go
--go
--ALTER DATABASE Projeto_CBD SET ENCRYPTION OFF;
--go
--USE Projeto_CBD
--GO
--DROP DATABASE ENCRYPTION KEY;                                           
--USE master
--GO
--DROP CERTIFICATE EncryptCert
--DROP MASTER KEY 
--go


IF (SELECT COUNT(*) FROM sys.symmetric_keys WHERE name LIKE '%DatabaseMasterKey%') = 0
BEGIN
CREATE  MASTER KEY ENCRYPTION BY PASSWORD='password';
END
go

-- Encriptação da palavra passe


IF (select Count(*) from sys.certificates where name = 'EncryptCert') = 0
BEGIN
CREATE  CERTIFICATE EncryptCert WITH SUBJECT='Encryption';
END
go



IF (select count(*) from sys.symmetric_keys where name = 'SymKey1') = 0
BEGIN
CREATE SYMMETRIC KEY SymKey1 WITH ALGORITHM =AES_256   ENCRYPTION BY CERTIFICATE EncryptCert;
END
go


OPEN SYMMETRIC KEY SymKey1 DECRYPTION BY CERTIFICATE EncryptCert;
go
if exists (select * from information_schema.columns where   table_name = 'Customer' and column_name = 'EncryptPW') 
begin
        alter table Utilizador.Customer drop column EncryptPW;
    end

	go
alter table Utilizador.Customer
add EncryptPW varbinary(256)
go
UPDATE Utilizador.Customer
SET EncryptPW = ENCRYPTBYKEY(KEY_GUID('SymKey1'), Password) ;
go

close symmetric key SymKey1;
go
select * from Utilizador.Customer;
go
OPEN SYMMETRIC KEY SymKey1 DECRYPTION BY CERTIFICATE EncryptCert;
go


--select convert(nvarchar(50), DECRYPTBYKEY(Password)) as Decryption
--from dbo.Customer;


select convert(varchar(max),DecryptByKey(EncryptPW)) as Decryption from Utilizador.Customer;
--select convert(varbinary(max),DecryptByKey(EncryptPW)) as Decryption from dbo.Customer;

-- Encriptação do Email
CREATE CERTIFICATE EncryptCert1 WITH SUBJECT='Encryption1'
go

CREATE SYMMETRIC KEY SymKey2 WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE EncryptCert1
go

OPEN SYMMETRIC KEY SymKey2 DECRYPTION BY CERTIFICATE EncryptCert1;

go
if exists (select * from information_schema.columns where   table_name = 'Customer' and column_name = 'EncryptEmail') 
begin
        alter table Utilizador.Customer drop column EncryptEmail;
    end

	go


alter table Utilizador.Customer
add EncryptEmail varbinary(256);
go
UPDATE Utilizador.Customer
SET EncryptEmail = ENCRYPTBYKEY(KEY_GUID('SymKey2'), EmailAdress) ;
go

close symmetric key SymKey2

select * from Utilizador.Customer;
go
OPEN SYMMETRIC KEY SymKey2 DECRYPTION BY CERTIFICATE EncryptCert1;
go
select convert(varchar(150), DECRYPTBYKEY(EncryptEmail)) as Decryption
from Utilizador.Customer;