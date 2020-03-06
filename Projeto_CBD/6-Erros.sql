use Projeto_CBD;

if not exists (select * from sysobjects where name='Erros' and xtype='U')
create table dbo.Erros (
ID int not null identity (1,1),
Descricao varchar(100) NOT NULL,
CONSTRAINT Erros_pk PRIMARY KEY (ID)
);

insert into dbo.Erros (Descricao) values 
('Insira um email valido'),
('Email j� Utilizado'),
('Insira uma password v�lida'),
('Insira uma descri��o v�lida'),
('Introduza um Estado V�lido - Rejeitado ou Aceite'),
('Insira uma Categoria V�lida'),
('Insira uma Publicidade v�lida'),
('Insira um Utilizador v�lido'),
('Insira uma imagem v�lida'),
('erroSubcategoryKey NAO � VALIDA'),
('Introduza um estado v�lido - Disponivel ou Recusado'),
('Out of Stock'),--12
('Opera��o negada-Encomenda Enviada'),--13
('Sales ID invalido'),--14
('Opera��o negada estado a null'),--15
('Produto Inexistente'),--16
('Categoria Inexistente'),--17
('Produto Key InVALIDO'),
('Comentario n�o existe'),
('Insira um comentario moderacao valido'),
('Insira um estado conteudos valido');

if not exists (select * from sysobjects where name='Log_Erros' and xtype='U')
create table dbo.Log_Erros (
ID int not null identity (1,1),
Descricao varchar(250) not null,
Data datetime NOT NULL,
CONSTRAINT Log_pk PRIMARY KEY(ID)
);