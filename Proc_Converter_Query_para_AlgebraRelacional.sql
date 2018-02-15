/*
PROCEDIMENTO PARA CONVERTER UMA QUERY EM ALGEBRA RELACIONAL
NÃO CONCLUÍDO

CRIADO POR LEEWAN MENESES
CRIADO EM: 11/12/2017

DISCIPLINA DE MODELAGEM DE DADOS
PROFESSOR MANOEL ALMEIDA
POS-GRADUAÇÃO FAMETRO
*/
CREATE PROCEDURE algebra_relacional
	@SQL_ORIG AS VARCHAR(8000)
AS

--ALTER DATABASE ALGEBRA_RELACIONAL SET COMPATIBILITY_LEVEL = 130


DECLARE @SQL VARCHAR(8000)
DECLARE @pos_from int
DECLARE @pos_where int
DECLARE @pos_inner int
DECLARE @pos_crossjoin int
DECLARE @campos varchar(1000)
DECLARE @tabelas varchar(50)
DECLARE @condicoes varchar(1000)

set @pos_where = 0

SET @SQL = @SQL_ORIG
set @pos_from = CHARINDEX('from', @SQL, 1)
set @pos_inner = 1
set @pos_inner = CHARINDEX('inner', @sql, @pos_inner)
set @pos_where = CHARINDEX('where', @sql, 1)
set @pos_crossjoin = CHARINDEX('cross', @SQL, 1)

SET @campos = SUBSTRING(@sql, 7, @pos_from-7)

SET @SQL = REPLACE(@SQL, 'IS NOT NULL', '!= NULL')
SET @SQL = REPLACE(@SQL, 'IS NULL', '= NULL')

IF @pos_inner <> 0 
	SET @tabelas = SUBSTRING(@sql, @pos_from + 4, @pos_inner)
ELSE
	if @pos_where = 0
		SET @tabelas = SUBSTRING(@sql, @pos_from + 4, LEN(@SQL))
	else
		SET @tabelas = SUBSTRING(@sql, @pos_from + 4, @pos_where-@pos_from -5)

SET @condicoes = SUBSTRING(@SQL, @pos_where+5, LEN(@SQL))

SET @campos = replace(@campos,' ','')
SET @tabelas = replace(@tabelas,' ','')

IF LEN(@condicoes) > 1
BEGIN
	IF len(@campos) = 1
	BEGIN
		PRINT N'σ ' + LOWER(@condicoes) + ' (' + @tabelas + ')'
	END
	ELSE
	BEGIN
		PRINT N'π ' + lower(@campos) + N'(σ ' + LOWER(@condicoes) + '('  + @tabelas + ')'
	END
END
PRINT @SQL