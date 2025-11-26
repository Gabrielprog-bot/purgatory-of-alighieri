@echo off
setlocal EnableDelayedExpansion

:: ==========================================================
::  1) Garantir que o script SEMPRE execute na pasta correta
:: ==========================================================
cd /d "%~dp0"

:: ==========================================================
::  2) Criar arquivo de log
:: ==========================================================
set LOGFILE=commit_log.txt

:: Pega a data e hora atual
for /f "tokens=1-4 delims=/ " %%a in ("%date%") do (
    set DIA=%%a
    set MES=%%b
    set ANO=%%c
)
set HORA=%time:~0,8%
set DATAHORA=%DIA%/%MES%/%ANO% %HORA%

echo. >> "%LOGFILE%"
echo ============================================== >> "%LOGFILE%"
echo Commit iniciado em %DATAHORA% >> "%LOGFILE%"
echo ============================================== >> "%LOGFILE%"

:: ==========================================================
::  3) Verificar se existe algo para commitar
:: ==========================================================
git status --porcelain > temp_status.txt

if not exist temp_status.txt (
    echo [ERRO] Git não respondeu. >> "%LOGFILE%"
    exit /b
)

for /f %%x in (temp_status.txt) do (
    set EXISTE=1
)

del temp_status.txt

if not defined EXISTE (
    echo Nenhuma alteração encontrada. Nada a commitar. >> "%LOGFILE%"
    exit /b
)

echo Alterações detectadas. Preparando commit... >> "%LOGFILE%"

:: ==========================================================
::  4) Executar o commit
:: ==========================================================
git add . >> "%LOGFILE%" 2>&1

git commit -m "Auto commit - %DATAHORA%" >> "%LOGFILE%" 2>&1

if errorlevel 1 (
    echo ERRO ao fazer commit! >> "%LOGFILE%"
    exit /b
)

echo Commit realizado com sucesso. >> "%LOGFILE%"

:: ==========================================================
::  5) Fazer o push
:: ==========================================================
git push >> "%LOGFILE%" 2>&1

if errorlevel 1 (
    echo ERRO ao enviar para o repositório! >> "%LOGFILE%"
    echo Possível falta de internet ou conflito. >> "%LOGFILE%"
    exit /b
)

echo Push enviado com sucesso para o repositório. >> "%LOGFILE%"

echo Processo concluído. >> "%LOGFILE%"
exit /b
