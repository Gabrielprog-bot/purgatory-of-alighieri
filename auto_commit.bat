@echo off
setlocal enabledelayedexpansion

:: sempre rodar na pasta onde este arquivo está
cd /d "%~dp0"

:LOOP

:: 1) puxar commits dos outros antes de trabalhar
git pull --rebase

:: 2) ver se existem alterações locais
git status --porcelain | findstr . >nul

if %errorlevel% equ 0 (
    set "now=%date% %time%"
    echo [%now%] Alteracoes detectadas. >> commit_log.txt

    :: 3) adicionar mudanças
    git add .

    :: 4) commit automatico
    git commit -m "Auto commit - !now!"

    :: 5) push
    git push

    echo [%now%] Commit enviado. >> commit_log.txt
    echo ---------------------------------------- >> commit_log.txt
)

:: 6) aguardar 60 segundos
timeout /t 60 >nul
goto LOOP
