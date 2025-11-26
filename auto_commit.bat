@echo off
SET "REPO_PATH=C:\Users\gabriel\Documents\purgatory-of-alighieri"
SET "COMMIT_MESSAGE=Auto-commit: Mudanças salvas"

cd /d "%REPO_PATH%"

:: Verifica se há mudanças para adicionar
git status --porcelain | findstr /v "^??"
if errorlevel 1 (
    echo Sem mudanças para commitar.
    exit /b
)

:: Adiciona, commita e envia
git add .
git commit -m "%COMMIT_MESSAGE%"
git push origin main  :: Altere 'main' para o nome da sua branch principal

echo Commit e Push automáticos concluídos.
