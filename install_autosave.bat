@echo off
echo Instalando AutoSave...

set SCRIPT_PATH=%~dp0
set TASKNAME=AutoSave
set RUNVBS=%SCRIPT_PATH%run_hidden.vbs

schtasks /create /tn "%TASKNAME%" /tr "wscript.exe \"%RUNVBS%\"" /sc minute /mo 1 /f

echo Instalacao concluida.
pause
