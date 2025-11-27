@echo off
title Instalador Purgatory - V3 (Force Restart)
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
:: 4. JANELA DE CONFIRMACAO (CORRIGIDA)
:: ==========================================================
echo [PASSO 3] Finalizando...
timeout /t 1 >nul

set "MSG_SCRIPT=Mensagem_Temp.vbs"

(
echo Set objShell = WScript.CreateObject("WScript.Shell")
echo Mensagem = "Instalacao Concluida!" ^& vbCrLf ^& vbCrLf ^& "O sistema Purgatory Sync rodara invisivel." ^& vbCrLf ^& "Deseja reiniciar o PC agora para ativar?"
echo ' 4=Sim/Nao, 32=Icone Pergunta, 4096=Sistema Modal (Fica no topo)
echo Resultado = MsgBox(Mensagem, 4 + 32 + 4096, "Purgatory Installer")
echo WScript.Quit Resultado
) > "%MSG_SCRIPT%"

:: Executa a janela e espera a resposta
cscript //nologo "%MSG_SCRIPT%"

:: Se o usuario clicou em SIM (codigo 6), forca o reinicio
if %errorlevel% EQU 6 (
    del "%MSG_SCRIPT%" >nul 2>&1
    echo [REINICIANDO] Aguarde...
    :: /r = Reiniciar
    :: /f = Forcar fechamento de apps (Impedir bloqueio)
    :: /t 0 = Tempo zero (Agora)
    shutdown /r /f /t 0
) else (
    del "%MSG_SCRIPT%" >nul 2>&1
    echo.
    echo [FIM] Voce escolheu reiniciar depois.
    echo Pode fechar esta janela.
    pause
)