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