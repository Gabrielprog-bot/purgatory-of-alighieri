@echo off
:: Arquivo: auto_commit.bat
:: Este script faz o commit e push de todas as alterações.

set "COMMIT_MESSAGE=Commit Automatico Agendado em %date% %time%"

:: Navega para o diretório raiz do projeto (se necessário)
:: cd /d C:\caminho\do\seu\projeto\

:: Adiciona todas as mudanças
git add .

:: Verifica se há algo para commitar (ERRORLEVEL 0 = nada para commitar)
git diff --cached --exit-code
if %errorlevel% equ 0 (
    ECHO Nada para commitar.
    goto :EOF
)

:: Faz o commit e o push
git commit -m "%COMMIT_MESSAGE%"
git push

ECHO Commit e Push automáticos concluídos!