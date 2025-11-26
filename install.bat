@echo off
setlocal enabledelayedexpansion

echo ==========================================
echo   INSTALADOR AUTO SAVE (CORRIGIDO)
echo ==========================================
echo.

set "PROJECT_PATH=%~dp0"

echo Criando run_hidden.vbs limpo...

echo Set sh = CreateObject("WScript.Shell") > "%PROJECT_PATH%run_hidden.vbs"
echo sh.Run "%PROJECT_PATH%auto_commit.bat", 0 >> "%PROJECT_PATH%run_hidden.vbs"

echo ✓ run_hidden.vbs criado com sucesso.

echo.
echo Criando tarefa AutoSave no Agendador...

schtasks /create ^
   /tn "AutoSave" ^
   /tr "wscript.exe \"%PROJECT_PATH%run_hidden.vbs\"" ^
   /sc onlogon ^
   /f

if %errorlevel% neq 0 (
   echo ERRO ao criar a tarefa!
   echo Execute como Administrador.
   pause
   exit /b
)

echo ✓ Tarefa criada!

echo Iniciando AutoSave invisivel agora...
start "" wscript.exe "%PROJECT_PATH%run_hidden.vbs"

echo ==========================================
echo AutoSave instalado e funcionando!
echo ==========================================
pause
exit /b
