@echo off
setlocal enabledelayedexpansion

:: PASTA DO PROJETO
set "PROJECT_FOLDER=%~dp0"

:: CRIA A PASTA "LogsCommit" SE NÃO EXISTIR
if not exist "%PROJECT_FOLDER%LogsCommit" (
    mkdir "%PROJECT_FOLDER%LogsCommit"
)

:: ARQUIVO DE LOG COM NOME DO USUÁRIO
set "LOGFILE=%PROJECT_FOLDER%LogsCommit\commit_log %USERNAME%.txt"

cd /d "%PROJECT_FOLDER%"

:LOOP

:: ATUALIZA REPOSITÓRIO (PULL)
git fetch
git pull --rebase --autostash >nul 2>&1

:: VERIFICA SE EXISTE ALGUMA ALTERAÇÃO
git status --porcelain | findstr . >nul
if %errorlevel% equ 0 (
    set "now=%date% %time%"
    echo [%now%] Alterações detectadas. >> "%LOGFILE%"

    git add .
    git commit -m "Auto commit - !now!" >nul 2>&1
    git push >nul 2>&1

    echo [%now%] Commit enviado. >> "%LOGFILE%"
    echo ------------------------------ >> "%LOGFILE%"
)

timeout /t 60 >nul
goto LOOP
