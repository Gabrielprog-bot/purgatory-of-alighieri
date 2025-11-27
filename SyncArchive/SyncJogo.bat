@echo off
title AutoSync Git - Loop Infinito
color 0A

:: --- CONFIGURAÇÃO ---
:: Mude para a pasta do seu projeto
cd /d "C:\Users\SeuUsuario\Documents\MeuJogo"

:: --- PONTO DE RETORNO (O LOOP COMEÇA AQUI) ---
:INICIO
cls
echo ==========================================
echo    SINCRONIZACAO AUTOMATICA ATIVA
echo    Pressione CTRL+C ou feche a janela para parar
echo ==========================================
echo.

:: 1. PULL (Baixar mudanças dos amigos)
echo [1/4] Baixando atualizacoes (Pull)...
git pull origin main

:: Se der erro no Pull (Conflito), o script PARA para você não perder nada
IF %ERRORLEVEL% NEQ 0 (
    color 0C
    echo.
    echo [ERRO CRITICO] Ocorreu um conflito! 
    echo Alguem mexeu no mesmo arquivo que voce.
    echo O script parou para seguranca. Resolva manualmente.
    pause
    exit
)

:: 2. ADD (Preparar arquivos)
echo.
echo [2/4] Verificando mudancas locais...
git add .

:: Verifica se tem algo para commitar. Se não tiver, pula para o timer.
git status | find "nothing to commit" > nul
if %errorlevel%==0 (
    echo.
    echo [INFO] Nada novo para enviar agora.
    goto TIMER
)

:: 3. COMMIT (Salvar localmente)
echo.
echo [3/4] Commitando mudancas...
set timestamp=%DATE:/=-%_%TIME::=-%
set timestamp=%timestamp: =%
git commit -m "Auto-Save: %timestamp% por %USERNAME%"

:: 4. PUSH (Enviar para a nuvem)
echo.
echo [4/4] Enviando para o GitHub (Push)...
git push origin main

:: --- TIMER DE ESPERA ---
:TIMER
echo.
echo ==========================================
echo    CICLO CONCLUIDO.
echo    Aguardando proxima verificacao...
echo ==========================================
:: O tempo abaixo está em SEGUNDOS (60 = 1 minuto).
:: Sugiro não colocar muito baixo para não travar o PC salvando toda hora.
timeout /t 60

:: --- O COMANDO MÁGICO QUE FAZ O LOOP ---
goto INICIO