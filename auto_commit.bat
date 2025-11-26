@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

:LOOP

:: Verifica alterações
git status --porcelain | findstr . >nul

if %errorlevel% equ 0 (
    set "now=%date% %time%"
    echo [%now%] Alterações detectadas. >> commit_log.txt

    git add .
    git commit -m "Auto commit - !now!"
    git push

    echo [%now%] Commit enviado. >> commit_log.txt
    echo ---------------------------------------- >> commit_log.txt
)

:: Espera 60 segundos
timeout /t 60 >nul
goto LOOP
