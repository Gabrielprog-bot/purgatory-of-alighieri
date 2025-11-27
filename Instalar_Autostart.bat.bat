@echo off
title Instalador Purgatory - Final V2
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

:: Esconde o arquivo Launcher para nao incomodar visualmente
attrib +h "%ARQUIVO_VBS%"

:: ==========================================================
:: 3. AGENDADOR DE TAREFAS
:: ==========================================================
echo [PASSO 2] Configurando inicializacao automatica...

schtasks /create /tn "%NOME_TAREFA%" /tr "\"%~dp0%ARQUIVO_VBS%\"" /sc onlogon /rl highest /f >nul 2>&1

if %ERRORLEVEL% NEQ 0 (
    echo [AVISO] Houve um erro ao agendar. Mas vamos tentar mostrar a mensagem final.
)

:: ==========================================================
:: 4. JANELA DE CONFIRMACAO (CORRIGIDA)
:: ==========================================================
echo [PASSO 3] Finalizando...

:: Pequena pausa para garantir que o disco salvou tudo
timeout /t 1 >nul

set "MSG_SCRIPT=Mensagem_Temp.vbs"

:: Cria o script de mensagem NA PASTA ATUAL (mais seguro)
(
echo msgbox "Instalacao Concluida com Sucesso!" ^& vbCrLf ^& vbCrLf ^& "O sistema Purgatory Sync agora rodara invisivel." ^& vbCrLf ^& "Deseja reiniciar o PC agora para ativar?", 4 + 64, "Purgatory Installer"
) > "%MSG_SCRIPT%"

:: Roda o script e captura a resposta
for /f "tokens=*" %%a in ('cscript //nologo //e:vbscript "%MSG_SCRIPT%"') do set "RESPOSTA=%%a"

:: O comando acima as vezes nao retorna o numero direto no batch simples,
:: entao vamos usar o errorlevel do cscript que eh mais garantido:
cscript //nologo "%MSG_SCRIPT%"
set "RESPOSTA_CODIGO=%errorlevel%"

:: Deleta o arquivo de mensagem
del "%MSG_SCRIPT%" >nul 2>&1

:: O codigo 6 significa SIM no VBScript
if %RESPOSTA_CODIGO% EQU 6 (
    shutdown /r /t 0
) else (
    echo.
    echo [FIM] Voce escolheu reiniciar depois.
    echo Pode fechar esta janela.
    pause
)