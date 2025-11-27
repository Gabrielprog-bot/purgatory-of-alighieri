@echo off
title Instalador Blindado - Purgatory
color 0F

:: ==========================================================
:: 1. AUTO-ELEVACAO (Metodo Mais Seguro)
:: ==========================================================
:: Verifica se ja e Admin
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :ADMIN_OK
) else (
    echo [INFO] Precisamos de permissao de Administrador...
    echo [INFO] Uma janela vai pedir permissao. Clique em SIM.
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:ADMIN_OK
:: ==========================================================
:: 2. FORCAR A PASTA CORRETA (Correcao do Bug)
:: ==========================================================
:: Garante que estamos na pasta do arquivo, nao no System32
cd /d "%~dp0"

echo [DIAGNOSTICO] Estou rodando em:
echo %cd%
echo.

set "ARQUIVO_BAT=SyncJogo.bat"
set "ARQUIVO_VBS=Launcher_Invisivel.vbs"
set "NOME_TAREFA=Purgatory_AutoSync"

:: Verifica se o SyncJogo existe
if not exist "%ARQUIVO_BAT%" (
    color 0C
    echo [ERRO FATAL] Nao encontrei o SyncJogo.bat!
    echo Ele precisa estar nesta pasta: %cd%
    pause
    exit
)

:: ==========================================================
:: 3. CRIAR O LANÇADOR VBS (Sem parenteses para evitar erro)
:: ==========================================================
echo [PASSO 1] Criando o arquivo Launcher_Invisivel.vbs...

echo Set WshShell = CreateObject("WScript.Shell") > "%ARQUIVO_VBS%"
echo WshShell.CurrentDirectory = "%~dp0" >> "%ARQUIVO_VBS%"
echo WshShell.Run chr(34) ^& "%~dp0%ARQUIVO_BAT%" ^& chr(34), 0 >> "%ARQUIVO_VBS%"
echo Set WshShell = Nothing >> "%ARQUIVO_VBS%"

:: Verificacao se criou
if exist "%ARQUIVO_VBS%" (
    echo [OK] Arquivo VBS criado com sucesso.
    :: Removi o comando de esconder (attrib +h) para voce ver que funcionou
) else (
    color 0C
    echo [ERRO] Falha ao criar o arquivo VBS. Verifique permissoes da pasta.
    pause
    exit
)

:: ==========================================================
:: 4. CONFIGURAR O AGENDADOR
:: ==========================================================
echo [PASSO 2] Configurando Agendador de Tarefas...

schtasks /create /tn "%NOME_TAREFA%" /tr "\"%~dp0%ARQUIVO_VBS%\"" /sc onlogon /rl highest /f

if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo [ERRO] Falha no comando schtasks.
    pause
    exit
)

echo [OK] Tarefa agendada.

:: ==========================================================
:: 5. MENSAGEM FINAL (Visual)
:: ==========================================================
echo [PASSO 3] Abrindo janela de confirmacao...

set "MSG_SCRIPT=%temp%\msgbox_fim.vbs"

echo Set objShell = WScript.CreateObject("WScript.Shell") > "%MSG_SCRIPT%"
echo Mensagem = "Instalacao Concluida!" ^& vbCrLf ^& vbCrLf ^& "O arquivo Launcher_Invisivel.vbs foi criado na pasta." ^& vbCrLf ^& "Nao apague ele." ^& vbCrLf ^& vbCrLf ^& "Deseja reiniciar agora?" >> "%MSG_SCRIPT%"
echo Resultado = MsgBox(Mensagem, 4 + 64, "Purgatory Sync") >> "%MSG_SCRIPT%"
echo WScript.Quit Resultado >> "%MSG_SCRIPT%"

cscript /nologo "%MSG_SCRIPT%"
set "RESPOSTA=%errorlevel%"
del "%MSG_SCRIPT%"

:: Se clicou em SIM (6), reinicia
if %RESPOSTA% EQU 6 (
    shutdown /r /t 0
) else (
    echo.
    echo [FIM] Voce escolheu nao reiniciar agora.
    echo Pode fechar esta janela.
    pause
)