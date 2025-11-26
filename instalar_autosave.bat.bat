@echo off
setlocal EnableDelayedExpansion

:: --- AUTO-ELEVACAO PARA ADMIN ---
>nul 2>&1 net session
if %errorLevel% neq 0 (
    echo Solicitando permissao de administrador...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: --- PEGAR CAMINHO DO BAT E DO XML ---
set SCRIPT_DIR=%~dp0
set XML=%SCRIPT_DIR%AutoSave.xml

set TASKNAME=AutoSave
set PROJECT_PATH=C:\Users\gabriel\Documents\purgatory-of-alighieri

echo =============================================
echo Instalador do AutoSave - Commit Automatico
echo =============================================
echo.
echo Arquivo XML detectado em:
echo %XML%
echo.

if not exist "%XML%" (
    echo ERRO: O arquivo AutoSave.xml NAO foi encontrado!
    echo Coloque AutoSave.xml na MESMA pasta do instalador.
    pause
    exit /b
)

echo Verificando se a tarefa %TASKNAME% ja existe...
schtasks /query /tn "%TASKNAME%" >nul 2>&1

IF %ERRORLEVEL%==0 (
    echo A tarefa %TASKNAME% ja existe. Nao sera reinstalada.
) ELSE (
    echo Instalando a tarefa %TASKNAME%...
    schtasks /create /tn "%TASKNAME%" /xml "%XML%" /f

    IF %ERRORLEVEL% NEQ 0 (
        echo ERRO ao instalar a tarefa!
        pause
        exit /b
    ) ELSE (
        echo Tarefa instalada com sucesso!
    )
)

echo.
echo Executando auto_commit.bat agora...
start "" "%PROJECT_PATH%\auto_commit.bat"

echo.
echo Instalacao concluida!
pause
exit
