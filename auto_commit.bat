@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

:LOOP

:: ============================
:: 1) Baixar commits dos outros
:: ============================
git fetch

git pull --rebase --autostash
if %errorlevel% neq 0 (
    echo Rebase falhou, tentando novamente... >> commit_log.txt
    git rebase --abort >nul 2>&1
    git pull --rebase --autostash
)

:: ============================
:: 2) Verificar se ha alteracoes
:: ============================
git status --porcelain | findstr . >nul

if %errorlevel% equ 0 (
    set "now=%date% %time%"
    echo [%now%] Alteracoes detectadas. >> commit_log.txt

    git add .
    git commit -m "Auto commit - !now!"

    :: ============================
    :: 3) Empurrar para o GitHub
    :: ============================
    git push
    if %errorlevel% neq 0 (
        echo Push falhou, tentando pull + push novamente... >> commit_log.txt

        git pull --rebase --autostash
        git push
    )

    echo [%now%] Commit enviado com sucesso. >> commit_log.txt
    echo ---------------------------------------- >> commit_log.txt
)

timeout /t 60 >nul
goto LOOP
