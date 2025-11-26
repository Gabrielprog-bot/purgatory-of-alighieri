@echo off
setlocal enabledelayedexpansion

:: Caminho da pasta principal
set "PROJECT_FOLDER=%~dp0"

:: Criar pasta "commits group" se não existir
if not exist "%PROJECT_FOLDER%commits group" (
    mkdir "%PROJECT_FOLDER%commits group"
)

:: Nome do arquivo de log baseado no usuário
set "LOGFILE=%PROJECT_FOLDER%commits group\commit_log %USERNAME%.txt"

cd /d "%PROJECT_FOLDER%"

:LOOP

:: 1 - Puxar commits novos
git fetch
git pull --rebase --autostash

:: 2 - Verificar alterações locais
git status --porcelain | findstr . >nul

if %errorlevel% equ 0 (
    set "now=%date% %time%"
    echo [%now%] Alterações detectadas. >> "%LOGFILE%"

    git add .
    git commit -m "Auto commit - !now!"
    git push

    echo [%now%] Commit enviado. >> "%LOGFILE%"
    echo ------------------------------ >> "%LOGFILE%"
)

timeout /t 60 >nul
goto LOOP
