@echo off
set SCRIPT_NAME=auto_commit.bat

REM Caminho da pasta Startup do usuário
set STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup

REM Caminho da pasta onde o script está sendo executado
set CURRENT_FOLDER=%~dp0

echo Copiando script de auto-commit para o Startup...
copy "%CURRENT_FOLDER%%SCRIPT_NAME%" "%STARTUP_FOLDER%" /Y

echo Instalado com sucesso. O Windows irá executar o script no próximo login.
pause
