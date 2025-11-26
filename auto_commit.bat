@echo off
setlocal enabledelayedexpansion

:: Garantir que está na pasta correta
cd /d "%~dp0"

:: Pegar data e hora
for /f "tokens=1-3 delims=/ " %%a in ("%date%") do (
    set DIA=%%a
    set MES=%%b
    set ANO=%%c
)

set HORA=%time:~0,8%
set MSG="Auto Commit - %DIA%/%MES%/%ANO% %HORA%"

echo ============================================
echo Commit iniciado em: %DIA%/%MES%/%ANO% %HORA%
echo ============================================

:: Verificar alterações
git status --porcelain
if errorlevel 1 (
    echo ERRO: Git não encontrado ou pasta errada.
    pause
    exit /b
)

:: Se não há mudanças, sair
git status --porcelain | findstr . >nul
if %errorlevel% neq 0 (
    echo Nenhuma alteração encontrada.
    exit /b
)

echo Fazendo git add...
git add .

echo Criando commit...
git commit -m %MSG%

echo Enviando para o repositório (push)...
git push

echo ============================================
echo Processo concluído.
echo ============================================

exit /b
