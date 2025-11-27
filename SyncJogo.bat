@echo off
title AutoSync Git - V4 (Inteligente)
color 0F

:: --- CONFIGURAÇÃO ---
cd /d "C:\Users\SeuUsuario\Documents\MeuJogo"

:INICIO
cls
echo ==========================================
echo    DIAGNOSTICO E SINCRONIZACAO
echo ==========================================
echo.

:: 1. DETECTAR BRANCH (Main ou Master?)
for /f "tokens=*" %%a in ('git branch --show-current') do set MINHA_BRANCH=%%a
echo [INFO] Trabalhando na branch: %MINHA_BRANCH%

:: 2. PULL (Baixar)
echo.
echo [1/4] Baixando (Pull) da branch %MINHA_BRANCH%...
git pull origin %MINHA_BRANCH%

:: 3. ADD (Adicionar)
echo.
echo [2/4] Adicionando arquivos...
git add .

:: 4. COMMIT
echo.
echo [3/4] Commitando...
set timestamp=%DATE:/=-%_%TIME::=-%
set timestamp=%timestamp: =%
git commit -m "Auto: %timestamp%"

:: 5. PUSH (O Momento da Verdade)
echo.
echo [4/4] Enviando (Push) para %MINHA_BRANCH%...
git push origin %MINHA_BRANCH%

:: --- VERIFICACAO DE ERRO ---
IF %ERRORLEVEL% NEQ 0 (
    color 0C
    echo.
    echo ======================================================
    echo [ERRO FATAL] O PUSH FALHOU!
    echo ======================================================
    echo LEIA A MENSAGEM DE ERRO ACIMA (em texto branco/cinza).
    echo.
    echo CAUSAS COMUNS:
    echo 1. "rejected - non-fast-forward": Alguem enviou algo antes de voce. (Rode o script de novo)
    echo 2. "File too large": Voce tem um arquivo maior que 100MB. (Delete ele ou use LFS)
    echo 3. "Access denied": Voce nao esta logado ou nao tem permissao.
    echo.
    echo O script parou para voce ler o erro.
    pause
    exit
)

echo.
echo [SUCESSO] Tudo enviado corretamente!
timeout /t 60
goto INICIO