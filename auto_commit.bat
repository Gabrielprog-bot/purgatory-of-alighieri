@echo off
setlocal enabledelayedexpansion

:: Sempre começar na pasta onde o .BAT está
cd /d "%~dp0"

echo ==============================================
echo AUTO COMMIT AUTOMÁTICO INICIADO
echo Verificando alterações a cada 60 segundos...
echo ==============================================
echo.

:LOOP

:: Verifica se existe alteração
git status --porcelain | findstr . >nul
if %errorlevel% equ 0 (
    echo [%date% %time%] Alterações detectadas! Commitando...

    git add .
    git commit -m "Auto commit - %date% %time%"
    git push

    echo [%date% %time%] Commit e push concluídos.
) else (
    echo [%date% %time%] Nenhuma alteração...
)

:: Espera 60 segundos
timeout /t 60 >nul

goto LOOP
