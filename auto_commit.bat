@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"
:LOOP
git status --porcelain | findstr . >nul
if %errorlevel% equ 0 (
    set "now=%date% %time%"
    echo [%now%] Alteracoes detectadas. >> commit_log.txt
    git add .
    git commit -m "Auto commit - !now!"
    git push
    echo [%now%] Commit enviado. >> commit_log.txt
	git pull
echo o seu repositorio esta sicronizado!
    echo ---------------------------------------- >> commit_log.txt
)
timeout /t 60 >nul
goto LOOP
