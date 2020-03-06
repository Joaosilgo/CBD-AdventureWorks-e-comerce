use Projeto_CBD;
GO

-- Função para validar email

GO
create or alter function fnValidaEmail (@Email Varchar(100))

Returns Tinyint AS
Begin
  
 Declare @Retorno Int

        Select @Retorno = 0

 Declare @TabelaAcentos Table (Indice Int Identity(1,1), Acento char(01)) 
 Insert Into @TabelaAcentos (Acento ) Values ('á')
 Insert Into @TabelaAcentos (Acento ) Values ('é')
 Insert Into @TabelaAcentos (Acento ) Values ('í')
 Insert Into @TabelaAcentos (Acento ) Values ('ó')
 Insert Into @TabelaAcentos (Acento ) Values ('ú')
 Insert Into @TabelaAcentos (Acento ) Values ('à')
 Insert Into @TabelaAcentos (Acento ) Values ('è')
 Insert Into @TabelaAcentos (Acento ) Values ('ì')
 Insert Into @TabelaAcentos (Acento ) Values ('ò')
 Insert Into @TabelaAcentos (Acento ) Values ('ù')
 Insert Into @TabelaAcentos (Acento ) Values ('ã')
 Insert Into @TabelaAcentos (Acento ) Values ('õ')
 Insert Into @TabelaAcentos (Acento ) Values ('â')
 Insert Into @TabelaAcentos (Acento ) Values ('ê')
 Insert Into @TabelaAcentos (Acento ) Values ('î')
 Insert Into @TabelaAcentos (Acento ) Values ('ô')
 Insert Into @TabelaAcentos (Acento ) Values ('û')
 Insert Into @TabelaAcentos (Acento ) Values ('ç')
 
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
  -- Por exemplo: dia 16/06 ficará 616 e 14/12 ficará 1214
  SET @dia_inicio = (MONTH(@nascimento) * 100) + DAY(@nascimento);
  SET @dia_fim = (MONTH(@data_base) * 100) + DAY(@data_base);

  -- Se ainda não passou no ano base
  IF @dia_fim < @dia_inicio
  BEGIN
    SET @idade = @idade - 1;
  END;
  
  RETURN @idade;
 
END;
GO
