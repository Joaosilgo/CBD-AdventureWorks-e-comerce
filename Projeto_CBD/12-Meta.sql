

USE [Projeto_CBD]
go

-- ================================================================================================================================================
-- ================================================================================================================================================
DROP PROCEDURE IF EXISTS sp_gerar_sp_Insert;
go
CREATE or alter  PROCEDURE sp_gerar_sp_Insert(@tabela varchar(255))
AS
BEGIN
	declare @table cursor
	declare @column_name nvarchar(255)
	declare @column_type nvarchar(255)
	declare @column_size int
	declare @params nvarchar(MAX)
	declare @dropSqlString nvarchar(MAX)
	declare @sqlstring nvarchar(MAX)
	declare @valuesString nvarchar(MAX)
	declare @tableSchema nvarchar(255)
	declare @first int


	set @table = cursor for(select COLUMN_NAME, DATA_TYPE,CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS
							where TABLE_NAME = @tabela)
	
	--Table Schema
	set @tableSchema = (SELECT TABLE_SCHEMA from INFORMATION_SCHEMA.TABLES  where TABLE_NAME = @tabela)
	set @first = 1

	open @table
	fetch next from @table into  @COLUMN_NAME, @COLUMN_TYPE, @COLUMN_SIZE
	while @@FETCH_STATUS = 0 
		BEGIN
			IF((select columnproperty(object_id(concat(@tableschema,'.',@tabela)), @column_name,'IsIdentity'))=0)
			BEGIN
			if @first = 1
				set @first = 0
			else
			set @params += ', '
			set @valuesString += ', '

				IF(@column_size is null)
				  set @params  =  CONCAT(@params,'@' , @COLUMN_NAME,' ' , @column_type)				 
				ELSE
				  set @params  =  CONCAT(@params,'@' , @COLUMN_NAME,' ' , @column_type,'(',@column_size,')')	
	
				set @valuesString = CONCAT(@valuesString,'@',@COLUMN_NAME)
			END

			fetch next from @table into  @COLUMN_NAME, @COLUMN_TYPE, @COLUMN_SIZE 	
		END
		
	  -- Drop Procedure
	  IF EXISTS(SELECT * FROM sys.objects 
	  WHERE object_id = OBJECT_ID(concat('sp_', @tabela,'_Insert')) AND type IN(N'P', N'PC'))
	  BEGIN
		set @dropSqlString = CONCAT('DROP PROCEDURE IF EXISTS  sp_',@tabela,'_Insert; ' + '')
		exec sp_executesql @statement = @dropSqlString
	  END

	  
	  set @sqlstring = CONCAT(
	  'CREATE PROCEDURE sp_',@tabela,'_Insert(',@params,')
	  AS
		BEGIN
		  INSERT INTO ',@tableSchema,'.',@tabela,'
		  VALUES(',@valuesString,')
	    END	  
	  ')

	print @sqlstring

	exec sp_executesql @statement = @sqlstring

	 Close @table
	 Deallocate @table
END
go


exec sp_gerar_sp_Insert 'Customer';







-- ================================================================================================================================================
-- ================================================================================================================================================










-- ================================================================================================================================================
-- ================================================================================================================================================
-- ================================================================================================================================================
-- ================================================================================================================================================


drop procedure if exists sp_generator_delete
go
create or alter procedure sp_generator_delete @tabela varchar(50)
as
Begin


EXEC('DROP PROCEDURE IF EXISTS sp_delete_'+@tabela)

declare @id varchar(max)
declare @nomeColuna varchar(100);
declare  @tableSchema varchar(100);
declare  @dropSqlString varchar(500);

select @id =  c.COLUMN_NAME, @nomeColuna = c.DATA_TYPE  from INFORMATION_SCHEMA.columns c 
join INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE 
cu on cu.COLUMN_NAME = c.COLUMN_NAME
join INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
on tc.CONSTRAINT_NAME = cu.CONSTRAINT_NAME
and tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
where c.TABLE_NAME = @tabela 
set @tableSchema = (SELECT TABLE_SCHEMA from INFORMATION_SCHEMA.TABLES  where TABLE_NAME = @tabela);

 IF EXISTS(SELECT * FROM sys.objects 
	  WHERE object_id = OBJECT_ID(concat('sp_delete_', @tabela)) AND type IN(N'P', N'PC'))
	  BEGIN
		set @dropSqlString = CONCAT('DROP PROCEDURE IF EXISTS  sp_delete_',@tabela,'; ' + '')
		exec sp_executesql @statement = @dropSqlString
	  END

declare @procedure varchar(Max) = 'CREATE PROCEDURE sp_delete_' + @tabela + ' @' + @id + ' ' + @nomeColuna +  '
as
delete from ' + @tableSchema+'.'+@tabela + ' ' + 'where'  + ' ' + @id + ' ' + '='+ '@' + @id +'
'
	print @procedure
EXEC(@procedure);
End
go

EXEC sp_generator_delete 'Customer';
go











CREATE or alter PROCEDURE sp_gerar_sp_delete( @Tablename Sysname)
AS 
BEGIN
DECLARE @SchemaName Sysname
--SET @Schemaname = 'Utilizador'
set @SchemaName = (SELECT TABLE_SCHEMA from INFORMATION_SCHEMA.TABLES  where TABLE_NAME = @Tablename);
DECLARE @IdentityInsert BIT
DECLARE @ProcName Sysname
SET @IdentityInsert = 0
SET @ProcName=''
SET NOCOUNT ON 

declare @dropSqlString nvarchar(500);
IF EXISTS(SELECT * FROM sys.objects 
--sp_Customer_delete
	  WHERE object_id = OBJECT_ID(concat('sp_', @Tablename,'_delete')) AND type IN(N'P', N'PC'))
	  BEGIN
		set @dropSqlString = CONCAT('DROP PROCEDURE IF EXISTS  sp_',@Tablename,'_delete; ' + '')
		exec sp_executesql @statement = @dropSqlString
	  END



DECLARE @PKTable TABLE 
( 
TableQualifier SYSNAME 
,TableOwner       SYSNAME 
,TableName       SYSNAME 
,ColumnName       SYSNAME 
,KeySeq           int 
,PKName           SYSNAME 
) 
 
INSERT INTO @PKTable 
EXEC sp_pkeys @Tablename,@Schemaname 
 
--SELECT * FROM @PKTable 
 
DECLARE @columnNames              VARCHAR(MAX) 
DECLARE @columnNamesWithDatatypes VARCHAR(MAX) 
DECLARE @InsertcolumnNames          VARCHAR(MAX) 
DECLARE @UpdatecolumnNames          VARCHAR(MAX) 
DECLARE @IdentityExists              BIT 
 
SELECT @columnNames = '' 
SELECT @columnNamesWithDatatypes = '' 
SELECT @InsertcolumnNames = '' 
SELECT @UpdatecolumnNames = '' 
SELECT @IdentityExists = 0 
 
DECLARE @MaxLen INT 
 
SELECT @MaxLen =  MAX(LEN(SC.NAME)) 
  FROM sys.schemas SCH 
  JOIN sys.tables  ST 
    ON SCH.schema_id =ST.schema_id 
  JOIN sys.columns SC 
    ON ST.object_id = SC.object_id 
 WHERE SCH.name = @Schemaname 
   AND ST.name  = @Tablename  
   AND SC.is_identity = CASE 
                        WHEN @IdentityInsert = 1 THEN SC.is_identity 
                        ELSE 0 
                        END 
   AND SC.is_computed = 0 
 
 
SELECT @columnNames = @columnNames + SC.name + ',' 
      ,@columnNamesWithDatatypes = @columnNamesWithDatatypes +'@' + SC.name  
                                                             + REPLICATE(' ',@MaxLen + 5 - LEN(SC.NAME)) + STY.name  
                                                             + CASE  
                                                               WHEN STY.NAME IN ('Char','Varchar') AND SC.max_length <> -1 THEN '(' + CONVERT(VARCHAR(4),SC.max_length) + ')' 
                                                               WHEN STY.NAME IN ('Nchar','Nvarchar') AND SC.max_length <> -1 THEN '(' + CONVERT(VARCHAR(4),SC.max_length / 2 ) + ')' 
                                                               WHEN STY.NAME IN ('Char','Varchar','Nchar','Nvarchar') AND SC.max_length = -1 THEN '(Max)' 
                                                               ELSE '' 
                                                               END  
                                                               + CASE 
                                                                 WHEN NOT EXISTS(SELECT 1 FROM @PKTable WHERE ColumnName=SC.name) THEN  ' = NULL,' + CHAR(13) 
                                                                 ELSE ',' + CHAR(13) 
                                                                 END 
       ,@InsertcolumnNames = @InsertcolumnNames + '@' + SC.name + ',' 
       ,@UpdatecolumnNames = @UpdatecolumnNames  
                             + CASE 
                               WHEN NOT EXISTS(SELECT 1 FROM @PKTable WHERE ColumnName=SC.name) THEN  
                                    CASE  
                                    WHEN @UpdatecolumnNames ='' THEN '' 
                                    ELSE '       ' 
                                    END +  SC.name +  + REPLICATE(' ',@MaxLen + 5 - LEN(SC.NAME)) + '= ' + '@' + SC.name + ',' + CHAR(13) 
                               ELSE '' 
                               END  
      ,@IdentityExists  = CASE  
                          WHEN SC.is_identity = 1 OR @IdentityExists = 1 THEN 1  
                          ELSE 0 
                          END 
  FROM sys.schemas SCH 
  JOIN sys.tables  ST 
    ON SCH.schema_id =ST.schema_id 
  JOIN sys.columns SC 
    ON ST.object_id = SC.object_id 
  JOIN sys.types STY 
    ON SC.user_type_id     = STY.user_type_id 
   AND SC.system_type_id = STY.system_type_id 
 WHERE SCH.name = @Schemaname 
   AND ST.name  = @Tablename 
   AND SC.is_identity = CASE 
                        WHEN @IdentityInsert = 1 THEN SC.is_identity 
                        ELSE 0 
                        END 
   AND SC.is_computed = 0 
 
DECLARE @DeleteSQL VARCHAR(MAX) 
DECLARE @PKWhereClause VARCHAR(MAX)
DECLARE @PKExistsClause VARCHAR(MAX)
 
SET @PKWhereClause = '' 
 
SELECT @PKWhereClause = @PKWhereClause + ColumnName + ' = ' + '@' + ColumnName + CHAR(13) + '   AND '  
  FROM @PKTable 
ORDER BY KeySeq 

SELECT @columnNames          = SUBSTRING(@columnNames,1,LEN(@columnNames)-1) 
SELECT @InsertcolumnNames = SUBSTRING(@InsertcolumnNames,1,LEN(@InsertcolumnNames)-1) 
SELECT @UpdatecolumnNames = SUBSTRING(@UpdatecolumnNames,1,LEN(@UpdatecolumnNames)-2)
SELECT @PKWhereClause      = SUBSTRING(@PKWhereClause,1,LEN(@PKWhereClause)-5) 
SELECT @columnNamesWithDatatypes = SUBSTRING(@columnNamesWithDatatypes,1,LEN(@columnNamesWithDatatypes)-2) 
SELECT @columnNamesWithDatatypes = @columnNamesWithDatatypes

DECLARE @pk_columnName VARCHAR(MAX)

SELECT  @pk_columnName =   COLUMN_NAME 
						FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
						WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA+'.'+CONSTRAINT_NAME), 'IsPrimaryKey') = 1
						AND TABLE_NAME = @Tablename

 
SELECT @DeleteSQL = 'DELETE FROM ' + @Schemaname +'.' + @Tablename  
                                  + CHAR(13) + ' WHERE ' + @PKWhereClause 

SELECT @ProcName = 'sp_' + @Tablename +'_delete'


DECLARE @sqlStringExec NVARCHAR(MAX)
--remover @columnNamesWithDatatype e a virgula antes
 SET @sqlStringExec = CONCAT(
								'CREATE PROCEDURE ',@ProcName + CHAR (13) + '@'+ @pk_columnName +' INT,'+ CHAR (13) +@columnNamesWithDatatypes +    CHAR (13) + 'AS' +  CHAR (13),
								' BEGIN'+ CHAR(13), @DeleteSQL + CHAR(13)+'END')

PRINT @sqlStringExec
exec sp_executesql @statement = @sqlStringExec
SET NOCOUNT OFF 
END
GO

sp_gerar_sp_delete 'Customer'









-- ================================================================================================================================================
-- ================================================================================================================================================
-- ================================================================================================================================================
-- ================================================================================================================================================
























DROP PROCEDURE IF EXISTS updateTemplate;

GO
CREATE PROCEDURE updateTemplate (@table NVARCHAR(75), @variables NVARCHAR(MAX))
AS

DECLARE @procedure NVARCHAR(MAX)

DECLARE @numOfPKs INT
DECLARE @SchemaName Sysname

set @SchemaName = (SELECT TABLE_SCHEMA from INFORMATION_SCHEMA.TABLES  where TABLE_NAME = @table);

EXEC('DROP PROCEDURE IF EXISTS sp_Upd_'+@table)

declare @dropSqlString nvarchar(500);
IF EXISTS(SELECT * FROM sys.objects 
--sp_Customer_delete
	  WHERE object_id = OBJECT_ID(concat('sp_Upd_', @table)) AND type IN(N'P', N'PC'))
	  BEGIN
		set @dropSqlString = CONCAT('DROP PROCEDURE IF EXISTS sp_Upd_',@table,'; ' + '')
		exec sp_executesql @statement = @dropSqlString
	  END

SET @procedure = 'CREATE or alter PROCEDURE dbo.sp_Upd_'+@table

-- chave primaria da tabela
SELECT @procedure = @procedure + ' @' + c.name + ' ' + UPPER(TYPE_NAME(c.system_type_id)) + ','
FROM sys.columns c
WHERE c.object_id = OBJECT_ID('Projeto_CBD.'+@SchemaName+
'.'+@table)
AND c.name IN (SELECT c.name FROM sys.key_constraints kc 
JOIN sys.index_columns ic ON
ic.object_id = kc.parent_object_id
AND ic.column_id = kc.unique_index_id
JOIN sys.columns c ON
c.object_id = ic.object_id
AND c.column_id = ic.column_id
WHERE c.object_id = OBJECT_ID('Projeto_CBD.'+@SchemaName+
'.'+@table)
AND kc.type = 'PK')

--atributos q n são nem varchar, nem decimal, nem numeric
SELECT @procedure = @procedure +' ' + '@' + c.name + ' ' + UPPER(TYPE_NAME(c.system_type_id)) + ',' 
FROM sys.columns c 
WHERE c.object_id = OBJECT_ID('Projeto_CBD.'+@SchemaName+
'.'+@table) 
AND c.name IN (SELECT VALUE FROM STRING_SPLIT(@variables, ';')) 
AND TYPE_NAME(c.system_type_id) NOT LIKE '%var%' 
AND TYPE_NAME(c.system_type_id) NOT LIKE 'dec%' 
AND TYPE_NAME(c.system_type_id) NOT LIKE 'num%'

-- atributos varchar, tao feitos a partes por tens de meter por exemplo 'VARCHAR(40)'
SELECT @procedure = @procedure +' ' + '@' + c.name + ' ' + UPPER(TYPE_NAME(c.system_type_id)) + '(' + CONCAT(c.max_length/2, ')') + ',' 
FROM sys.columns c 
WHERE  c.object_id = OBJECT_ID('Projeto_CBD.'+@SchemaName+
'.'+@table) 
AND c.name IN (SELECT VALUE FROM STRING_SPLIT(@variables, ';')) 
AND TYPE_NAME(c.system_type_id) LIKE '%var%' 

-- decimal e numeric, semelhante ao varchar, por exemplo 'DECIMAL/NUMERIC (9,3)'
SELECT @procedure = @procedure +' ' + '@' + c.name + ' ' + UPPER(TYPE_NAME(c.system_type_id)) + '(' + CONCAT(c.[precision], ',', c.scale, ')') + ',' 
FROM sys.columns c
WHERE c.object_id = OBJECT_ID('Projeto_CBD.'+@SchemaName+'.'+@table) 
AND c.name IN (SELECT VALUE FROM STRING_SPLIT(@variables, ';')) 
AND (TYPE_NAME(c.system_type_id) LIKE 'dec%' OR TYPE_NAME(c.system_type_id) LIKE 'num%')

-- substring para retirar a virgula q fica a mais no fim do cabeçalho da SP
SET @procedure = SUBSTRING(@procedure, 1, LEN(@procedure) - 1)

-- sintaxe do update
SET @procedure = @procedure + ' AS UPDATE ' +@SchemaName+'.'+@table + ' SET '

SELECT @procedure = @procedure + c.name + ' = @' + c.name + ','
FROM sys.columns c 
WHERE c.name IN (SELECT VALUE FROM STRING_SPLIT(@variables, ';')) 
AND c.object_id = OBJECT_ID('Projeto_CBD.'+@SchemaName+
'.'+@table)

-- substring para tirar a virgula q fica a mais antes do where
SET @procedure = SUBSTRING(@procedure, 1, LEN(@procedure) - 1) + ' WHERE '

SELECT @numOfPKs = COUNT(*) FROM sys.key_constraints kc
JOIN sys.index_columns ic ON
ic.object_id = kc.parent_object_id
AND ic.column_id = kc.unique_index_id 
JOIN sys.columns c ON
c.object_id = ic.object_id
AND c.column_id = ic.column_id
WHERE c.object_id = OBJECT_ID('Projeto_CBD.'+@SchemaName+
'.'+@table)
AND kc.type = 'PK'

IF @numOfPKs <= 1 BEGIN
-- chave primaria, vai ser o criterio do where
	SELECT @procedure = @procedure + c.name + ' = @' + c.name 
	FROM sys.columns c
	WHERE c.object_id = OBJECT_ID('Projeto_CBD.'+@SchemaName+
'.'+@table)
	AND c.name IN (SELECT c.name FROM sys.key_constraints kc
	JOIN sys.index_columns ic ON
	ic.object_id = kc.parent_object_id
	AND ic.column_id = kc.unique_index_id
	JOIN sys.columns c ON
	c.object_id = ic.object_id
	AND c.column_id = ic.column_id
	WHERE c.object_id = OBJECT_ID('Projeto_CBD.'+@SchemaName+
'.'+@table)
	AND kc.type = 'PK')
END 
ELSE BEGIN
	SELECT @procedure = @procedure + c.name + ' = @' + c.name + ' AND '
	FROM sys.columns c
	WHERE c.object_id = OBJECT_ID(@table)
	AND c.name IN (SELECT c.name FROM sys.key_constraints kc
	JOIN sys.columns ic ON
	ic.object_id = kc.parent_object_id
	AND ic.column_id = kc.unique_index_id
	JOIN sys.columns c ON
	c.column_id = ic.column_id
	AND c.object_id = ic.object_id
	WHERE c.object_id = OBJECT_ID('Projeto_CBD.'+@SchemaName+
'.'+@table)
	AND kc.type = 'PK')

	SET @procedure = SUBSTRING(@procedure, 1, LEN(@procedure) - 4)
END

PRINT @procedure
EXEC(@procedure)
GO

updateTemplate 'Customer', 'FirstName'

































DROP PROCEDURE IF EXISTS sp_gerar_sp_update;

GO
CREATE or alter  PROCEDURE sp_gerar_sp_update( @Tablename Sysname)
AS 
BEGIN
--DECLARE @SchemaName Sysname
DECLARE @SchemaName Sysname

set @SchemaName = (SELECT TABLE_SCHEMA from INFORMATION_SCHEMA.TABLES  where TABLE_NAME = @Tablename);
DECLARE @IdentityInsert BIT
DECLARE @ProcName Sysname
SET @IdentityInsert = 0
SET @ProcName=''
SET NOCOUNT ON 

DECLARE @PKTable TABLE 
( 
TableQualifier SYSNAME 
,TableOwner       SYSNAME 
,TableName       SYSNAME 
,ColumnName       SYSNAME 
,KeySeq           int 
,PKName           SYSNAME 
) 
 
INSERT INTO @PKTable 
EXEC sp_pkeys @Tablename,@Schemaname 
 
--SELECT * FROM @PKTable 
 
DECLARE @columnNames              VARCHAR(MAX) 
DECLARE @columnNamesWithDatatypes VARCHAR(MAX) 
DECLARE @InsertcolumnNames          VARCHAR(MAX) 
DECLARE @UpdatecolumnNames          VARCHAR(MAX) 
DECLARE @IdentityExists              BIT 
 
SELECT @columnNames = '' 
SELECT @columnNamesWithDatatypes = '' 
SELECT @InsertcolumnNames = '' 
SELECT @UpdatecolumnNames = '' 
SELECT @IdentityExists = 0 
 
DECLARE @MaxLen INT 
 
SELECT @MaxLen =  MAX(LEN(SC.NAME)) 
  FROM sys.schemas SCH 
  JOIN sys.tables  ST 
    ON SCH.schema_id =ST.schema_id 
  JOIN sys.columns SC 
    ON ST.object_id = SC.object_id 
 WHERE SCH.name = @Schemaname 
   AND ST.name  = @Tablename  
   AND SC.is_identity = CASE 
                        WHEN @IdentityInsert = 1 THEN SC.is_identity 
                        ELSE 0 
                        END 
   AND SC.is_computed = 0 
 
 
SELECT @columnNames = @columnNames + SC.name + ',' 
      ,@columnNamesWithDatatypes = @columnNamesWithDatatypes +'@' + SC.name  
                                                             + REPLICATE(' ',@MaxLen + 5 - LEN(SC.NAME)) + STY.name  
                                                             + CASE  
                                                               WHEN STY.NAME IN ('Char','Varchar') AND SC.max_length <> -1 THEN '(' + CONVERT(VARCHAR(4),SC.max_length) + ')' 
                                                               WHEN STY.NAME IN ('Nchar','Nvarchar') AND SC.max_length <> -1 THEN '(' + CONVERT(VARCHAR(4),SC.max_length / 2 ) + ')' 
                                                               WHEN STY.NAME IN ('Char','Varchar','Nchar','Nvarchar') AND SC.max_length = -1 THEN '(Max)' 
                                                               ELSE '' 
                                                               END  
                                                               + CASE 
                                                                 WHEN NOT EXISTS(SELECT 1 FROM @PKTable WHERE ColumnName=SC.name) THEN  ' = NULL,' + CHAR(13) 
                                                                 ELSE ',' + CHAR(13) 
                                                                 END 
       ,@InsertcolumnNames = @InsertcolumnNames + '@' + SC.name + ',' 
       ,@UpdatecolumnNames = @UpdatecolumnNames  
                             + CASE 
                               WHEN NOT EXISTS(SELECT 1 FROM @PKTable WHERE ColumnName=SC.name) THEN  
                                    CASE  
                                    WHEN @UpdatecolumnNames ='' THEN '' 
                                    ELSE '       ' 
                                    END +  SC.name +  + REPLICATE(' ',@MaxLen + 5 - LEN(SC.NAME)) + '= ' + '@' + SC.name + ',' + CHAR(13) 
                               ELSE '' 
                               END  
      ,@IdentityExists  = CASE  
                          WHEN SC.is_identity = 1 OR @IdentityExists = 1 THEN 1  
                          ELSE 0 
                          END 
  FROM sys.schemas SCH 
  JOIN sys.tables  ST 
    ON SCH.schema_id =ST.schema_id 
  JOIN sys.columns SC 
    ON ST.object_id = SC.object_id 
  JOIN sys.types STY 
    ON SC.user_type_id     = STY.user_type_id 
   AND SC.system_type_id = STY.system_type_id 
 WHERE SCH.name = @Schemaname 
   AND ST.name  = @Tablename 
   AND SC.is_identity = CASE 
                        WHEN @IdentityInsert = 1 THEN SC.is_identity 
                        ELSE 0 
                        END 
   AND SC.is_computed = 0 
 
DECLARE @UpdateSQL VARCHAR(MAX) 
DECLARE @PKWhereClause VARCHAR(MAX)
DECLARE @PKExistsClause VARCHAR(MAX)
 
SET @PKWhereClause = '' 
 
SELECT @PKWhereClause = @PKWhereClause + ColumnName + ' = ' + '@' + ColumnName + CHAR(13) + '   AND '  
  FROM @PKTable 
ORDER BY KeySeq 

SELECT @columnNames          = SUBSTRING(@columnNames,1,LEN(@columnNames)-1) 
SELECT @InsertcolumnNames = SUBSTRING(@InsertcolumnNames,1,LEN(@InsertcolumnNames)-1) 
SELECT @UpdatecolumnNames = SUBSTRING(@UpdatecolumnNames,1,LEN(@UpdatecolumnNames)-2)
SELECT @PKWhereClause      = SUBSTRING(@PKWhereClause,1,LEN(@PKWhereClause)-5) 
SELECT @columnNamesWithDatatypes = SUBSTRING(@columnNamesWithDatatypes,1,LEN(@columnNamesWithDatatypes)-2) 
SELECT @columnNamesWithDatatypes = @columnNamesWithDatatypes
SELECT  @PKExistsClause = 'IF EXISTS (SELECT 1 FROM ' + @Schemaname +'.' + @Tablename
            + ' WHERE ' + @PKWhereClause + ')'
 
--SELECT @DeleteSQL = 'DELETE FROM ' + @Schemaname +'.' + @Tablename  
--                                  + CHAR(13) + ' WHERE ' + @PKWhereClause 
 
SELECT @UpdateSQL = 'UPDATE '  + @Schemaname +'.' + @Tablename  
                               + CHAR (13) + '   SET ' + @UpdatecolumnNames  
                              + CHAR (13) + ' WHERE ' + @PKWhereClause 
  
SELECT @ProcName = 'sp_' + @Tablename +'_Update'

DECLARE @pk_columnName VARCHAR(MAX)

SELECT @pk_columnName = COLUMN_NAME 
						FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
						WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA+'.'+CONSTRAINT_NAME), 'IsPrimaryKey') = 1
						AND TABLE_NAME = @Tablename

DECLARE @sqlStringExec NVARCHAR(MAX)

 SET @sqlStringExec = CONCAT(
								'CREATE or alter PROCEDURE ',@ProcName + CHAR (13) +'@'+ @pk_columnName +' INT,'+ CHAR(13)+  @columnNamesWithDatatypes +  CHAR (13) + 'AS' +  CHAR (13),
								' BEGIN'+ CHAR(13),@PKExistsClause + CHAR(13), 'BEGIN '+ CHAR(13), @UpdateSQL + CHAR(13), 'END'+ CHAR(13)+'END')

PRINT @sqlStringExec
exec sp_executesql @statement = @sqlStringExec
  
SET NOCOUNT OFF 
END
GO


exec sp_gerar_sp_update 'Customer'
go
