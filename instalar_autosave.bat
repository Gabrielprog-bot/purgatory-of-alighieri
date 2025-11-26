@echo off
:: AUTO-ELEVATE ADMIN
>nul 2>&1 net session
if %errorlevel% neq 0 (
    echo Solicitando permissao de Administrador...
    powershell -command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

setlocal enableextensions enabledelayedexpansion
echo ==========================================
echo     INSTALADOR DO AUTOSAVE UNIVERSAL
echo ==========================================
echo.

set "PROJECT_PATH=%~dp0"
echo Projeto: %PROJECT_PATH%
echo.

echo Set sh = CreateObject("WScript.Shell") > "%PROJECT_PATH%run_hidden.vbs"
echo sh.Run "cmd /c %PROJECT_PATH%auto_commit.bat", 0, False >> "%PROJECT_PATH%run_hidden.vbs"

set "TASKNAME=AutoSave"
set "TASKCMD=wscript.exe "%PROJECT_PATH%run_hidden.vbs""

schtasks /query /tn "%TASKNAME%" >nul 2>&1
if %errorlevel% neq 0 (
    schtasks /create /tn "%TASKNAME%" /tr "%TASKCMD%" /sc onlogon /f >nul 2>&1
)

schtasks /run /tn "%TASKNAME%" >nul 2>&1

echo Instalacao concluida!
pause
