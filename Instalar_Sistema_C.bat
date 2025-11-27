@echo off
title Instalador Purgatory (Modo Manual Seguro)
color 0F

:: ==========================================================
:: 1. VERIFICACAO DE ADMIN (SEM FECHAR A JANELA)
:: ==========================================================
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    color 0E
    echo.
    echo ========================================================
    echo [ATENCAO] VOCE NAO EXECUTOU COMO ADMINISTRADOR!
    echo ========================================================
    echo.
    echo O Windows precisa de permissao para criar o agendamento.
    echo.
    echo COMO RESOLVER:
    echo 1. Feche esta janela.
    echo 2. Clique com o BOTAO DIREITO neste arquivo.
    echo 3. Escolha "Executar como Administrador".
    echo.
    echo Pressione qualquer tecla para sair...
    pause >nul
    exit
)

:: Se chegou aqui, voce e Admin. Vamos continuar.
cd /d "%~dp0"
echo [OK] Permissao de Administrador confirmada.
echo.

:: ==========================================================
:: 2. DEFINICOES DE CAMINHO
:: ==========================================================
set "PASTA_PROJETO=%~dp0"
:: Remove a barra final se tiver
if "%PASTA_PROJETO:~-1%"=="\" set "PASTA_PROJETO=%PASTA_PROJETO:~0,-1%"

set "ARQUIVO_BAT=SyncJogo.bat"
set "NOME_TAREFA=Purgatory_AutoSync"

:: Caminho seguro para o sistema (AppData Local)
set "PASTA_SISTEMA=%LOCALAPPDATA%\PurgatorySys"
set "ARQUIVO_VBS=%PASTA_SISTEMA%\Launcher.vbs"

:: Verifica se o SyncJogo esta na pasta
if not exist "%PASTA_PROJETO%\%ARQUIVO_BAT%" (
    color 0C
    echo [ERRO] Nao encontrei o arquivo SyncJogo.bat!
    echo Ele precisa estar aqui: %PASTA_PROJETO%
    pause
    exit
)

:: ==========================================================
:: 3. CRIACAO DOS ARQUIVOS
:: ==========================================================
echo [PASSO 1] Criando sistema em: %PASTA_SISTEMA%

if not exist "%PASTA_SISTEMA%" mkdir "%PASTA_SISTEMA%"
attrib +h "%PASTA_SISTEMA%" >nul 2>&1

echo [PASSO 2] Gerando o gatilho VBS...

:: Deleta anterior se existir
if exist "%ARQUIVO_VBS%" del /f /q "%ARQUIVO_VBS%"

:: Escreve o arquivo linha por linha (Metodo Seguro)
echo Set WshShell = CreateObject("WScript.Shell") >> "%ARQUIVO_VBS%"
echo WshShell.CurrentDirectory = "%PASTA_PROJETO%" >> "%ARQUIVO_VBS%"
echo WshShell.Run chr(34) ^& "%PASTA_PROJETO%\%ARQUIVO_BAT%" ^& chr(34), 0 >> "%ARQUIVO_VBS%"
echo Set WshShell = Nothing >> "%ARQUIVO_VBS%"

if not exist "%ARQUIVO_VBS%" (
    color 0C
    echo [ERRO FATAL] O arquivo VBS nao foi criado.
    echo Verifique se o antivirus nao esta bloqueando.
    pause
    exit
)

:: ==========================================================
:: 4. AGENDAMENTO E LIMPEZA
:: ==========================================================
echo [PASSO 3] Agendando tarefa no Windows...

schtasks /create /tn "%NOME_TAREFA%" /tr "\"%ARQUIVO_VBS%\"" /sc onlogon /rl highest /f >nul

if %ERRORLEVEL% EQU 0 (
    echo [OK] Tarefa agendada com sucesso.
) else (
    color 0C
    echo [ERRO] Falha ao agendar a tarefa.
    pause
    exit
)

:: Esconde o SyncJogo da pasta do projeto
attrib +h "%PASTA_PROJETO%\%ARQUIVO_BAT%" >nul 2>&1

:: ==========================================================
:: 5. TESTE IMEDIATO E FIM
:: ==========================================================
echo.
echo [PASSO 4] Testando execucao agora...
echo (O SyncJogo vai rodar invisivel agora para testar)

:: Executa o VBS agora para garantir que funciona
start "" "%ARQUIVO_VBS%"

echo.
echo ========================================================
echo    INSTALACAO CONCLUIDA COM SUCESSO!
echo ========================================================
echo.
echo 1. O SyncJogo esta rodando invisivel.
echo 2. Ele iniciara sozinho toda vez que ligar o PC.
echo 3. A pasta do projeto esta limpa.
echo.
echo Pressione qualquer tecla para fechar...
pause >nul
exit