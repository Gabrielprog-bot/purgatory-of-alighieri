@echo off
title Instalador Premium - Purgatory
color 0F

:: ==========================================================
:: 1. AUTO-ELEVACAO (Pedir Admin sozinho)
:: ==========================================================
:: Verifica se tem permissao de admin
fltmc >nul 2>&1
if %errorlevel% NEQ 0 (
    echo [INFO] Solicitando permissao de Administrador...
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)

:: ==========================================================
:: 2. INSTALACAO DA TAREFA
:: ==========================================================
cd /d "%~dp0"
set "ARQUIVO_ALVO=%~dp0SyncJogo.bat"
set "NOME_TAREFA=Purgatory_AutoSync"

if not exist "%ARQUIVO_ALVO%" (
    msg * "ERRO: O arquivo SyncJogo.bat nao foi encontrado nesta pasta!"
    exit
)

:: Cria a tarefa no Windows
schtasks /create /tn "%NOME_TAREFA%" /tr "\"%ARQUIVO_ALVO%\"" /sc onlogon /rl highest /f >nul 2>&1

:: ==========================================================
:: 3. JANELA DE CONFIRMACAO (VBScript)
:: ==========================================================
:: Cria um pequeno script visual temporario
set "VBS_SCRIPT=%temp%\msgbox_purgatory.vbs"

echo Set objShell = WScript.CreateObject("WScript.Shell") > "%VBS_SCRIPT%"
echo Mensagem = "A instalacao foi concluida com sucesso!" ^& vbCrLf ^& vbCrLf ^& "Para que a sincronizacao automatica comece a funcionar, e recomendado reiniciar o computador." ^& vbCrLf ^& vbCrLf ^& "Deseja reiniciar o Windows agora?" >> "%VBS_SCRIPT%"
echo Titulo = "Instalacao Concluida - Purgatory" >> "%VBS_SCRIPT%"
echo ' 4 = Botoes Sim/Nao, 32 = Icone de Interrogacao >> "%VBS_SCRIPT%"
echo Resultado = MsgBox(Mensagem, 4 + 32, Titulo) >> "%VBS_SCRIPT%"
echo WScript.Quit Resultado >> "%VBS_SCRIPT%"

:: Executa a janela e pega a resposta (6 = Sim, 7 = Nao)
cscript /nologo "%VBS_SCRIPT%"
set "RESPOSTA=%errorlevel%"

:: Apaga o script temporario
del "%VBS_SCRIPT%"

:: ==========================================================
:: 4. REINICIAR OU SAIR
:: ==========================================================
if %RESPOSTA% EQU 6 (
    :: O usuario clicou em SIM
    shutdown /r /t 0
) else (
    :: O usuario clicou em NAO
    exit
)