@echo off
SET "REPO_PATH=C:\Users\gabriel\Documents\purgatory-of-alighieri"
SET "COMMIT_MESSAGE=New"
SET "BRANCH_NAME=main"

echo --- Iniciando Auto-Push ---
echo Caminho: %REPO_PATH%
echo Mensagem: %COMMIT_MESSAGE%

cd /d "%REPO_PATH%"

:: 1. Verifica se há mudanças para adicionar (ignora arquivos não rastreados '??')
git status --porcelain | findstr /v "^??"
if errorlevel 1 (
    echo [%time%] Sem mudanças rastreadas para commitar.
    goto :eof
)

:: 2. Adiciona todos os arquivos modificados
echo [%time%] Adicionando todas as mudanças...
git add .

:: 3. Faz o commit
echo [%time%] Fazendo commit com a mensagem "%COMMIT_MESSAGE%"...
git commit -m "%COMMIT_MESSAGE%"

:: 4. Faz o push para o GitHub
echo [%time%] Fazendo push para a branch %BRANCH_NAME%...
git push origin %BRANCH_NAME%

if errorlevel 1 (
    echo ERRO: O push falhou! Verifique sua conexão ou se há conflitos.
) else (
    echo SUCESSO: Commit e Push automáticos concluídos.
)

echo -----------------------------
