@echo off
setlocal enableextensions enabledelayedexpansion

echo ==========================================
echo     INSTALADOR DO AUTOSAVE UNIVERSAL
echo ==========================================
echo.

:: Descobrir a pasta do projeto automaticamente
set "PROJECT_PATH=%~dp0"

echo Pasta do projeto detectada:
echo %PROJECT_PATH%
echo.

:: ============================================================
:: 1) Criar VBS oculto
:: ============================================================

echo Criando run_hidden.vbs...

echo Set sh = CreateObject("WScript.Shell") > "%PROJECT_PATH%run_hidden.vbs"
echo sh.Run "cmd /c """"%PROJECT_PATH%auto_commit.bat""""", 0, False >> "%PROJECT_PATH%run_hidden.vbs"

if exist "%PROJECT_PATH%run_hidden.vbs" (
    echo ✓ run_hidden.vbs criado com sucesso!
) else (
    echo ✗ ERRO criando o arquivo run_hidden.vbs!
    pause
    exit /b 1
)

echo.

:: ============================================================
:: 2) Criar tarefa no Agendador de Tarefas
:: ============================================================

set "TASKNAME=AutoSave"
set "TASKCMD=wscript.exe \"%PROJECT_PATH%run_hidden.vbs\""

echo Criando tarefa AutoSave no Windows...

schtasks /query /tn "%TASKNAME%" >nul 2>&1
if %errorlevel% equ 0 (
    echo A tarefa AutoSave ja existe. Nao sera recriada.
) else (
    schtasks /create /tn "%TASKNAME%" /tr "%TASKCMD%" /sc onlogon /f >nul 2>&1

    if %errorlevel% neq 0 (
        echo ✗ ERRO criando a tarefa AutoSave!
        echo Execute este instalador como ADMINISTRADOR.
        pause
        exit /b 1
    )

    echo ✓ Tarefa AutoSave criada com sucesso!
)

echo.

:: ============================================================
:: 3) Iniciar imediatamente
:: ============================================================

echo Iniciando AutoSave agora (invisivel)...

schtasks /run /tn "%TASKNAME%" >nul 2>&1
if %errorlevel% neq 0 (
    echo Aviso: inicio via schtasks falhou. Iniciando manualmente...
    start "" wscript.exe "%PROJECT_PATH%run_hidden.vbs"
)

echo.
echo ==========================================
echo     AUTO SAVE INSTALADO COM SUCESSO
echo ==========================================
echo.
echo O AutoSave agora:
echo  - Inicia automaticamente com o Windows
echo  - Roda totalmente invisivel
echo  - Executa auto_commit.bat a cada 1 minuto
echo  - Mantem commit_log.txt atualizado
echo.
echo Instalacao finalizada!
echo ==========================================
echo.

pause
exit /b 0
