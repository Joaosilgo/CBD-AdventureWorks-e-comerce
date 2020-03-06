use Projeto_CBD;
GO

-- Fun��o para validar email

GO
create or alter function fnValidaEmail (@Email Varchar(100))

Returns Tinyint AS
Begin
  
 Declare @Retorno Int

        Select @Retorno = 0

 Declare @TabelaAcentos Table (Indice Int Identity(1,1), Acento char(01)) 
 Insert Into @TabelaAcentos (Acento ) Values ('�')
 Insert Into @TabelaAcentos (Acento ) Values ('�')
 Insert Into @TabelaAcentos (Acento ) Values ('�')
 Insert Into @TabelaAcentos (Acento ) Values ('�')
 Insert Into @TabelaAcentos (Acento ) Values ('�')
 Insert Into @TabelaAcentos (Acento ) Values ('�')
 Insert Into @TabelaAcentos (Acento ) Values ('�')
 Insert Into @TabelaAcentos (Acento ) Values ('�')
 Insert Into @TabelaAcentos (Acento ) Values ('�')
 Insert Into @TabelaAcentos (Acento ) Values ('�')
 Insert Into @TabelaAcentos (Acento ) Values ('�')
 Insert Into @TabelaAcentos (Acento ) Values ('�')
 Insert Into @TabelaAcentos (Acento ) Values ('�')
 Insert Into @TabelaAcentos (Acento ) Values ('�')
 Insert Into @TabelaAcentos (Acento ) Values ('�')
 Insert Into @TabelaAcentos (Acento ) Values ('�')
 Insert Into @TabelaAcentos (Acento ) Values ('�')
 Insert Into @TabelaAcentos (Acento ) Values ('�')
 
 Declare @Cont Int 
 Declare @IdxStr Int 
 Declare @CampoStr Varchar(1000) 
 

        Select @Retorno = @retorno + PatIndex('%@%',@Email)

 Select @Retorno = @Retorno + CharIndex('.',(Substring(@Email,PatIndex('%@%',@Email),Len(@Email)-CharIndex('.',@Email))))

        Set @IdxStr = 1 
 Select @Cont = Len(@Email)
 While @IdxStr <= @Cont
 Begin 
 If Substring(@Email,@IdxStr,1) In (Select Acento From @TabelaAcentos) 
    Select @Retorno = 0
    Set @IdxStr = @IdxStr + 1 
 End

  Return @Retorno

End










GO




IF OBJECT_ID('calcular_idade', 'FN') IS NULL
BEGIN
  EXEC('CREATE FUNCTION calcular_idade() RETURNS INT AS BEGIN RETURN 1 END');
END;
GO

create or ALTER FUNCTION calcular_idade(@nascimento DATE)
RETURNS INT
AS
BEGIN
  DECLARE @idade      INT;
  DECLARE @dia_inicio INT;
  DECLARE @dia_fim    INT;
  DECLARE @data_base date;

  SET @data_base = ISNULL(@data_base, GETDATE()); -- Caso seja nula considera a data atual
  SET @idade = DATEDIFF(YEAR, @nascimento, @data_base);
  -- Deve ser feito dessa forma por conta do ano bissexto
  -- Por exemplo: dia 16/06 ficar� 616 e 14/12 ficar� 1214
  SET @dia_inicio = (MONTH(@nascimento) * 100) + DAY(@nascimento);
  SET @dia_fim = (MONTH(@data_base) * 100) + DAY(@data_base);

  -- Se ainda n�o passou no ano base
  IF @dia_fim < @dia_inicio
  BEGIN
    SET @idade = @idade - 1;
  END;
  
  RETURN @idade;
 
END;
GO
