@echo off
title AutoSync Git - V3 (Universal)
color 0A

:: --- CONFIGURAÇÃO ---
:: Mude para a pasta do seu projeto
cd /d "C:\Users\SeuUsuario\Documents\MeuJogo"

:INICIO
cls
echo ==========================================
echo    SISTEMA DE SINCRONIZACAO ATIVO
echo    Equipe: Voce + 5 Devs
echo ==========================================
echo.

:: 1. PULL (Baixar novidades)
echo [1/4] Buscando alteracoes da equipe...
git pull origin main

:: Verifica conflito
IF %ERRORLEVEL% NEQ 0 (
    color 0C
    echo.
    echo [ERRO] Conflito detectado no Pull!
    echo O script parou para voce resolver manualmente.
    pause
    exit
)

:: 2. ADD (Adicionar arquivos)
echo.
echo [2/4] Verificando seus arquivos...
git add .

:: 3. COMMIT (Tenta salvar. Se estiver vazio, o Git avisa e seguimos)
echo.
echo [3/4] Tentando criar Commit...
set timestamp=%DATE:/=-%_%TIME::=-%
set timestamp=%timestamp: =%

:: O comando abaixo tenta commitar. 
:: Se nao tiver nada novo, ele vai dar "erro" (exit code 1) e pulamos pro timer.
git commit -m "Auto-Save: %timestamp% por %USERNAME%"

IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo [INFO] Nada de novo para enviar agora