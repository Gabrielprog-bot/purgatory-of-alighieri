@echo off
title Instalador Purgatory (PowerShell Edition)
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
:: 3. CRIAR O LANÇADOR (Arquivo necessario para esconder a janela preta)
:: ==========================================================
echo [PASSO 1] Criando lancador invisivel...

(
echo Set WshShell = CreateObject("WScript.Shell")
echo WshShell.CurrentDirectory = "%~dp0"
echo WshShell.Run chr(34) ^& "%~dp0%ARQUIVO_BAT%" ^& chr(34), 0
echo Set WshShell = Nothing
) > "%ARQUIVO_VBS%"

:: Esconde o arquivo
attrib +h "%ARQUIVO_VBS%"

:: ==========================================================
:: 4. AGENDADOR DE TAREFAS
:: ==========================================================
echo [PASSO 2] Configurando inicializacao automatica...

schtasks /create /tn "%NOME_TAREFA%" /tr "\"%~dp0%ARQUIVO_VBS%\"" /sc onlogon /rl highest /f >nul 2>&1

:: ==========================================================
:: 5. JANELA DE AVISO (VIA POWERSHELL - INFALIVEL)
:: ==========================================================
echo [PASSO 3] Concluido.

:: O comando abaixo cria a janela direto na memoria, sem criar arquivos.
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Instalacao Concluida com Sucesso! ' + [Environment]::NewLine + [Environment]::NewLine + 'O Purgatory Sync ja esta configurado para rodar em segredo.' + [Environment]::NewLine + 'Ele comecara na proxima vez que ligar o PC.' + [Environment]::NewLine + [Environment]::NewLine + 'Voce pode reiniciar a maquina quando quiser.', 'Sucesso', 'OK', 'Information')}"

exit