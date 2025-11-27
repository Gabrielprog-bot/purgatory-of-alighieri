@echo off
title AutoSync Purgatory - Automacao
color 0F

:: --- PARTE 1: DETECÇÃO AUTOMÁTICA DE LOCAL ---
:: O comando abaixo pega o caminho de ONDE este arquivo está.
:: Não importa se está no C:, no D:, no Desktop ou em Documents.
:: Funciona para o Gabriel, Guilherme, etc.
cd /d "%~dp0"

:INICIO
cls
echo ==========================================
echo    PROJETO: PURGATORY OF ALIGHIERI
echo    MODO: AUTOMATICO
echo ==========================================
echo.

:: --- PARTE 2: DETECÇÃO DO NOME ---
:: A variavel %USERNAME% pega o nome do computador (Ex: Gabriel)
:: Voce nao precisa escrever nada.
set NOME_ATUAL=%USERNAME%

echo [INFO] Caminho detectado: %cd%
echo [INFO] Usuario detectado: %NOME_ATUAL%

:: Tenta pegar a branch automaticamente
for /f "tokens=*" %%a in ('git branch --show-current') do set BRANCH_ATUAL=%%a
echo [INFO] Branch: %BRANCH_ATUAL%
echo.

:: 1. PULL
echo [1/4] Baixando alteracoes...
git pull origin %BRANCH_ATUAL%
timeout /t 5 >nul

:: --- LOG INTELIGENTE ---
:: Cria a pasta com o nome detectado (Ex: _Logs_Equipe\Gabriel)
if not exist "_Logs_Equipe\%NOME_ATUAL%" mkdir "_Logs_Equipe\%NOME_ATUAL%"

set ARQUIVO_LOG="_Logs_Equipe\%NOME_ATUAL%\Log_Atividades.txt"
set HORA=%DATE% as %TIME%

echo [LOG] Salvando log para %NOME_ATUAL%...
echo %HORA% - Sync na branch %BRANCH_ATUAL% >> %ARQUIVO_LOG%

:: 2. ADD
echo.
echo [2/4] Preparando arquivos...
git add .
timeout /t 2 >nul

:: 3. COMMIT
echo.
echo [3/4] Commitando...
:: Cria um ID unico para o commit
set ID=%DATE:/=-%-%TIME::=-%
set ID=%ID: =%

git commit -m "AutoSync: %ID% por %NOME_ATUAL%"

IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo [INFO] Nada novo para enviar.
    goto TIMER
)

:: 4. PUSH
echo.
echo [4/4] Enviando para GitHub...
git push origin %BRANCH_ATUAL%

IF %ERRORLEVEL% NEQ 0 (
    color 0C
    echo.
    echo [ERRO] Falha no envio! Verifique a internet.
    pause
    goto INICIO
)

:TIMER
echo.
echo [SUCESSO] Tudo limpo.
echo Proxima checagem em 60 segundos...
timeout /t 60 >nul
goto INICIO