@echo off
setlocal EnableDelayedExpansion

REM Caminho do projeto
set PROJECT_PATH=C:\Users\gabriel\Documents\purgatory-of-alighieri\AUTOSAVE
set VBS_PATH=%PROJECT_PATH%\auto_commit_hidden.vbs
set STARTUP_PATH=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
set SHORTCUT=%STARTUP_PATH%\AutoCommitHidden.lnk

REM Caminho do ícone (.ico)
set ICON=%PROJECT_PATH%\icon.ico

echo Instalando AutoCommit oculto...
echo.

REM 1) Cria o arquivo VBS oculto
echo Criando VBS oculto...
echo.

echo Set WshShell = CreateObject("WScript.Shell") > "%VBS_PATH%"
echo WshShell.CurrentDirectory = "%PROJECT_PATH%" >> "%VBS_PATH%"
echo WshShell.Run "%PROJECT_PATH%\auto_commit.bat", 0, False >> "%VBS_PATH%"

REM 2) Criar o atalho com ícone
echo Criando atalho na pasta Startup com ícone personalizado...
echo.

REM Script temporário para gerar o atalho com ícone
set TEMP_VBS=%TEMP%\create_shortcut.vbs

echo Set oWS = WScript.CreateObject("WScript.Shell") > "%TEMP_VBS%"
echo sLinkFile = "%SHORTCUT%" >> "%TEMP_VBS%"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%TEMP_VBS%"
echo oLink.TargetPath = "%VBS_PATH%" >> "%TEMP_VBS%"
echo oLink.WorkingDirectory = "%PROJECT_PATH%" >> "%TEMP_VBS%"
echo oLink.IconLocation = "%ICON%" >> "%TEMP_VBS%"
echo oLink.Save >> "%TEMP_VBS%"

cscript //nologo "%TEMP_VBS%"
del "%TEMP_VBS%"

echo Instalacao concluida!
echo O AutoCommit agora rodará oculto com ícone personalizado no Startup.
echo.

pause
exit
