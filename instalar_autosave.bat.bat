@echo off
setlocal EnableDelayedExpansion

REM Caminho do arquivo XML do agendador (deve estar na mesma pasta)
set XML=AutoSave.xml

REM Nome da tarefa
set TASKNAME=AutoSave

REM Caminho do projeto (apenas para rodar o commit manual depois)
set PROJECT_PATH=C:\Users\gabriel\Documents\purgatory-of-alighieri

echo =============================================
echo Instalador do AutoSave - Commit Automático
echo =============================================

REM Verifica se a tarefa já existe
echo Verificando se a tarefa %TASKNAME% já está instalada...
schtasks /query /tn "%TASKNAME%" >nul 2>&1

IF %ERRORLEVEL%==0 (
    echo A tarefa %TASKNAME% ja existe. Nao sera reinstalada.
) ELSE (
    echo Instalando tarefa %TASKNAME%...
    schtasks /create /tn "%TASKNAME%" /xml "%XML%" /f
    IF %ERRORLEVEL%==0 (
        echo Tarefa instalada com sucesso!
    ) ELSE (
        echo ERRO ao instalar a tarefa.
        pause
        exit /b
    )
)

echo.
echo Iniciando auto_commit.bat agora...
echo.

REM Executa o auto_commit.bat normal
start "" "%PROJECT_PATH%\auto_commit.bat"

echo Instalacao concluida.
echo.

pause
exit
