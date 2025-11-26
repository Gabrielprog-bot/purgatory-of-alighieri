@echo off
setlocal enabledelayedexpansion

:: nome do arquivo de log baseado no usuário
set "LOGFILE=commit_log %USERNAME%.txt"

cd /d "%~dp0"

:LOOP

:: 1) baixar commits dos outros
git fetch
git pull --rebase --autostash
if %errorlevel% neq 0 (
    echo Rebase falhou, tentando novamente... >> "%LOGFILE%"
    git rebase --abort >nul 2>&1
    git pull --rebase --autostash
)

:: 2) verificar alterações locais
git status --porcelain | findstr . >nul

if %errorlevel% equ 0 (
    set "now=%date% %time%"
    echo [%now%] Alteracoes detectadas. >> "%LOGFILE%"

    git add .
    git commit -m "Auto commit - !now!"

    git push
    if %errorlevel% neq 0 (
        echo Push falhou, tentando pull+push novamente... >> "%LOGFILE%"
        git pull --rebase --autostash
        git push
    )

    echo [%now%] Commit enviado. >> "%LOGFILE%"
    echo ---------------------------------------- >> "%LOGFILE%"
)

timeout /t 60 >nul
goto LOOP
