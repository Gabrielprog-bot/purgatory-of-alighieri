@echo off
setlocal enabledelayedexpansion

:: FORÇA O SCRIPT A RODAR NA PASTA ONDE ELE ESTÁ
cd /d "%~dp0..\.."

:: GARANTE QUE A PASTA LogsCommit EXISTE
if not exist "LogsCommit" mkdir "LogsCommit"

:: NOME DO LOG POR USUÁRIO
set "LOGFILE=LogsCommit\commit_log %USERNAME%.txt"

:LOOP

:: ATUALIZA O REPOSITORIO
git fetch
git pull --rebase --autostash >nul 2>&1

:: VERIFICA ALTERAÇÕES
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
