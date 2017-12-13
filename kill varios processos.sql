/*
Script T-SQL para finalizar varias sessões no banco de dados de uma aplicação especifica

CREATE BY Leewan Meneses
DATE CREATE 21/08/2017
*/

SET NOCOUNT ON;
DECLARE @processos TABLE(pid INT);
DECLARE @processoId INT;

INSERT INTO @processos SELECT spid FROM SYS.SYSPROCESSES WHERE program_name = 'Alteryx' AND blocked <> 0;

DECLARE cursor_processos CURSOR FOR SELECT pid FROM @processos;
OPEN cursor_processos 
FETCH NEXT FROM cursor_processos INTO @processoId

IF @@FETCH_STATUS <> 0 
        PRINT 'Nenhum Alterix travando o banco...'     
WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC ('KILL ' + @processoId);
	PRINT 'Processo ' + CAST(@processoId AS VARCHAR) + ' finalizado...'
	FETCH NEXT FROM cursor_processos INTO @processoId
END

CLOSE cursor_processos
DEALLOCATE cursor_processos
