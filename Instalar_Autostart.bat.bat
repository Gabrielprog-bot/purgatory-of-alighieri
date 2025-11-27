@echo off
title Instalador Purgatory - Final (Aviso Simples)
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
:: 2. VERIFICACOES E CRIACAO DO LAUNCHER
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

echo [PASSO 1] Criando o lancador invisivel...
(
echo Set WshShell = CreateObject("WScript.Shell")
echo WshShell.CurrentDirectory = "%~dp0"
echo WshShell.Run chr(34) ^& "%~dp0%ARQUIVO_BAT%" ^& chr(34), 0
echo Set WshShell = Nothing
) > "%ARQUIVO_VBS%"

:: Esconde o arquivo VBS
attrib +h "%ARQUIVO_VBS%"

:: ==========================================================
:: 3. AGENDADOR DE TAREFAS
:: ==========================================================
echo [PASSO 2] Configurando inicializacao automatica...

schtasks /create /tn "%NOME_TAREFA%" /tr "\"%~dp0%ARQUIVO_VBS%\"" /sc onlogon /rl highest /f >nul 2>&1

:: ==========================================================
:: 4. JANELA DE AVISO (APENAS INFORMA)
:: ==========================================================
echo [PASSO 3] Concluido.

timeout /t 1 >nul

set "MSG_SCRIPT=Aviso_Final.vbs"

(
echo Set objShell = WScript.CreateObject("WScript.Shell")
echo Mensagem = "Instalacao Concluida com Sucesso!" ^& vbCrLf ^& vbCrLf ^& "O Purgatory Sync ja esta configurado." ^& vbCrLf ^& "Ele comecara a trabalhar automaticamente na proxima vez que voce ligar o computador." ^& vbCrLf ^& vbCrLf ^& "Reinicie a maquina quando puder."
echo ' 0=Botao OK, 64=Icone Informacao, 4096=Fica no Topo
echo MsgBox Mensagem, 0 + 64 + 4096, "Instalacao Finalizada"
) > "%MSG_SCRIPT%"

:: Mostra a mensagem na tela
cscript //nologo "%MSG_SCRIPT%"

:: Limpa o lixo e sai
del "%MSG_SCRIPT%" >nul 2>&1
exit