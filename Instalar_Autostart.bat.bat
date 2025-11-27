::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJGyX8VAjFBxVThaLOWeGIroL5uT07u6UnmwIQO0cWavs6YvYd7dLpEznevY=
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
::cxY6rQJ7JhzQF1fEqQJQ
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
::Zh4grVQjdCyDJGyX8VAjFBxVThaLOWeGIrof/eX+4f6UnmoUQMoqerPLz6aJIfQc+FypepBg13ZTn8MFCQlRQjulfRs1pW9QiUWQI8iPpw7zXgaM/k5Q
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
title Instalador Purgatory (Clean Mode)
color 0F

:: ==========================================================
:: 1. AUTO-ELEVACAO (GARANTIR ADMIN)
:: ==========================================================
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :ADMIN_OK
) else (
    echo [INFO] Solicitando permissao de Administrador...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:ADMIN_OK
cd /d "%~dp0"

:: ==========================================================
:: 2. VERIFICACOES
:: ==========================================================
set "ARQUIVO_BAT=SyncJogo.bat"
set "ARQUIVO_VBS=Launcher_Invisivel.vbs"
set "NOME_TAREFA=Purgatory_AutoSync"

if not exist "%ARQUIVO_BAT%" (
    color 0C
    echo [ERRO] O arquivo SyncJogo.bat nao esta nesta pasta!
    pause
    exit
)

:: ==========================================================
:: 3. CRIAR O LANÇADOR E ESCONDER TUDO
:: ==========================================================
echo [PASSO 1] Criando arquivos invisiveis...

(
echo Set WshShell = CreateObject("WScript.Shell")
echo WshShell.CurrentDirectory = "%~dp0"
echo WshShell.Run chr(34) ^& "%~dp0%ARQUIVO_BAT%" ^& chr(34), 0
echo Set WshShell = Nothing
) > "%ARQUIVO_VBS%"

:: --- AQUI ESTA A MAGICA ---
:: Oculta o Launcher VBS
attrib +h "%ARQUIVO_VBS%"
:: Oculta o SyncJogo.bat (ele some da vista)
attrib +h "%ARQUIVO_BAT%"

:: ==========================================================
:: 4. AGENDADOR DE TAREFAS
:: ==========================================================
echo [PASSO 2] Configurando inicializacao automatica...

schtasks /create /tn "%NOME_TAREFA%" /tr "\"%~dp0%ARQUIVO_VBS%\"" /sc onlogon /rl highest /f >nul 2>&1

:: ==========================================================
:: 5. JANELA DE AVISO (POWER SHELL)
:: ==========================================================
echo [PASSO 3] Concluido.

powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Instalacao Concluida!' + [Environment]::NewLine + [Environment]::NewLine + 'Os arquivos de sistema foram ocultados para limpar a pasta.' + [Environment]::NewLine + 'O SyncJogo rodara automaticamente ao reiniciar.', 'Sucesso', 'OK', 'Information')}"

exit