::[Bat To Exe Converter]
::
::fBE1pAF6MU+EWHreyHcjLQlHcAODPnmzA7kgzOf4+ueCrFkOaPIqaojazrucOa0c7AjleZ8q3nNfisIwHg5WQRqiagsxpyBUtHfl
::fBE1pAF6MU+EWHreyHcjLQlHcAODPnmzA7kgzOf4+ueCrFkOaPIqaojazrucOa0c7AjleZ8q3nNfisIwDQ5McS2oYQI5oHoMtGWRVw==
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJGyX8VAjFBxVThaLOWeGIroL5uT07u6UnkoUQOoqesLW26aFbukQ5SU=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJhSA==
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFBxVThaLOWeGIroL5uT07u6UnmwIQO0MeZne/b2abuUL7yU=
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983
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

:: ==================================================================
:: JANELA REAL DO WINDOWS (MessageBox) PERGUNTANDO REINICIAR
:: ==================================================================

echo Exibindo janela de reinicializacao...

powershell -command ^
"Add-Type -AssemblyName PresentationFramework; ^
$result = [System.Windows.MessageBox]::Show( ^
 'A instalacao do AutoSave foi concluida com sucesso.`n`n' + ^
 'Para que o AutoSave funcione corretamente desde o inicio,`n' + ^
 'é recomendado reiniciar o computador agora.`n`n' + ^
 'Deseja reiniciar agora?', ^
 'Reiniciar o computador?', ^
 'YesNo', ^
 'Question' ^
); ^
if ($result -eq 'Yes') { Start-Process 'shutdown' -ArgumentList '/r','/t','0' }"


pause
