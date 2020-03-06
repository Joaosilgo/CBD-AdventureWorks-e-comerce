use Projeto_CBD;

if not exists (select * from sysobjects where name='Erros' and xtype='U')
create table dbo.Erros (
ID int not null identity (1,1),
Descricao varchar(100) NOT NULL,
CONSTRAINT Erros_pk PRIMARY KEY (ID)
);

insert into dbo.Erros (Descricao) values 
('Insira um email valido'),
('Email já Utilizado'),
('Insira uma password válida'),
('Insira uma descrição válida'),
('Introduza um Estado Válido - Rejeitado ou Aceite'),
('Insira uma Categoria Válida'),
('Insira uma Publicidade válida'),
('Insira um Utilizador válido'),
('Insira uma imagem válida'),
('erroSubcategoryKey NAO É VALIDA'),
('Introduza um estado válido - Disponivel ou Recusado'),
('Out of Stock'),--12
('Operação negada-Encomenda Enviada'),--13
('Sales ID invalido'),--14
('Operação negada estado a null'),--15
('Produto Inexistente'),--16
('Categoria Inexistente'),--17
('Produto Key InVALIDO'),
('Comentario não existe'),
('Insira um comentario moderacao valido'),
('Insira um estado conteudos valido');

if not exists (select * from sysobjects where name='Log_Erros' and xtype='U')
create table dbo.Log_Erros (
ID int not null identity (1,1),
Descricao varchar(250) not null,
Data datetime NOT NULL,
CONSTRAINT Log_pk PRIMARY KEY(ID)
);