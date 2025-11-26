@echo off
setlocal enableextensions enabledelayedexpansion

echo ==========================================
echo     INSTALADOR DO AUTOSAVE COMPLETO
echo ==========================================
echo.

:: pasta do script (com barra final)
set "PROJECT_PATH=%~dp0"

echo Pasta do projeto: %PROJECT_PATH%
echo.

:: ============================================================
:: 1) Criar VBS oculto
:: ============================================================

echo Criando run_hidden.vbs...

echo Set sh = CreateObject("WScript.Shell") > "%PROJECT_PATH%run_hidden.vbs"
echo sh.Run "%PROJECT_PATH%auto_commit.bat", 0 >> "%PROJECT_PATH%run_hidden.vbs"

if exist "%PROJECT_PATH%run_hidden.vbs" (
    echo ✓ run_hidden.vbs criado
) else (
    echo ✗ ERRO criando run_hidden.vbs
    pause
    exit /b 1
)

echo.

:: ============================================================
:: 2) Criar tarefa no Agendador
:: ============================================================

set "TASKNAME=AutoSave"
set "TASKCMD=wscript.exe \"%PROJECT_PATH%run_hidden.vbs\""

echo Criando tarefa AutoSave...

schtasks /query /tn "%TASKNAME%" >nul 2>&1
if %errorlevel% equ 0 (
    echo A tarefa já existe. Pulando criação.
) else (
    schtasks /create /tn "%TASKNAME%" /tr "%TASKCMD%" /sc onlogon /f >nul 2>&1

    if %errorlevel% neq 0 (
        echo ✗ ERRO criando a tarefa AutoSave
        echo Execute este instalador como ADMINISTRADOR.
        pause
        exit /b 1
    )
    
    echo ✓ Tarefa AutoSave instalada com sucesso!
)

echo.

:: ============================================================
:: 3) Iniciar AutoSave agora (invisível)
:: ============================================================

echo Iniciando AutoSave agora...

schtasks /run /tn "%TASKNAME%" >nul 2>&1
if %errorlevel% neq 0 (
    echo Aviso: não foi possível iniciar via schtasks.
    echo Iniciando manualmente...
    start "" wscript.exe "%PROJECT_PATH%run_hidden.vbs"
)

echo.
echo ==========================================
echo   Instalacao concluída com sucesso!
echo ==========================================
echo.
echo Agora o AutoSave:
echo  ✔ Inicia junto com o Windows
echo  ✔ Roda completamente invisível
echo  ✔ Executa auto_commit.bat em loop
echo  ✔ Faz commits automáticos a cada 1 minuto
echo  ✔ Salva tudo no commit_log.txt
echo ==========================================
echo.

pause
exit /b 0
