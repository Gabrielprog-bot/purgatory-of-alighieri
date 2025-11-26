@echo off
setlocal enableextensions enabledelayedexpansion

echo ==========================================
echo        INSTALADOR DO AUTOSAVE (corrigido)
echo ==========================================
echo.

:: pasta do script (com barra no final)
set "PROJECT_PATH=%~dp0"

echo Projeto: %PROJECT_PATH%
echo.

:: 1) criar run_hidden.vbs corretamente
echo Criando run_hidden.vbs...
(
  echo Set sh = CreateObject("WScript.Shell")
  echo sh.Run "%PROJECT_PATH%auto_commit.bat", 0
) > "%PROJECT_PATH%run_hidden.vbs"

if exist "%PROJECT_PATH%run_hidden.vbs" (
  echo ✓ run_hidden.vbs criado em %PROJECT_PATH%
) else (
  echo ERRO: nao foi possivel criar run_hidden.vbs
  pause
  exit /b 1
)

echo.

:: 2) criar a tarefa no Agendador de Tarefas
echo Criando tarefa AutoSave no Agendador de Tarefas...

:: Monta o comando - sem "/RL" para evitar erro de parametro inválido
set "TASKNAME=AutoSave"
set "TASKRUN=wscript.exe \"%PROJECT_PATH%run_hidden.vbs\""

schtasks /query /tn "%TASKNAME%" >nul 2>&1
if %errorlevel% equ 0 (
    echo A tarefa "%TASKNAME%" já existe. Pulando criacao.
) else (
    schtasks /create /tn "%TASKNAME%" /tr "%TASKRUN%" /sc onlogon /f >nul 2>&1
    if %errorlevel% neq 0 (
        echo ERRO ao criar a tarefa. Tente executar este instalador como Administrador.
        echo Saida do schtasks: %errorlevel%
        pause
        exit /b 1
    ) else (
        echo ✓ Tarefa "%TASKNAME%" criada com sucesso.
    )
)

echo.

:: 3) iniciar a tarefa agora (executar a tarefa imediatamente)
echo Iniciando AutoSave agora...
schtasks /run /tn "%TASKNAME%" >nul 2>&1
if %errorlevel% neq 0 (
    :: se nao conseguiu iniciar via schtasks, tenta iniciar o VBS diretamente
    start "" wscript.exe "%PROJECT_PATH%run_hidden.vbs"
) 

echo.
echo ==========================================
echo   Instalacao concluida. AutoSave instalado.
echo ==========================================
echo.

echo Para verificar:
echo  - "schtasks /query /tn %TASKNAME%"  -> ver se existe a tarefa
echo  - "schtasks /run /tn %TASKNAME%"    -> forcar execucao agora
echo  - conferir commit_log.txt na pasta do projeto
echo.

pause
exit /b 0
