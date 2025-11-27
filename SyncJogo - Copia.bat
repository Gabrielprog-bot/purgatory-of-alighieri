@echo off
:: Arquivo: instalar_autostart.bat
:: Cria um diretório de aplicacao local e instala o Launcher para o usuario.

SET "PROJECT_NAME=purgatory-of-alighieri"
SET "APP_DIR=%USERPROFILE%\AutoSave\%PROJECT_NAME%"
SET "STARTUP_FOLDER=%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
SET "PROJECT_PATH=%CD%"

ECHO --- Instalacao do Auto Save ---

:: 1. Cria a pasta de aplicacao local do usuario e o diretorio de Inicializacao
MKDIR "%APP_DIR%" 2>nul

:: 2. Cria o Launcher VBScript DENTRO da pasta de aplicacao do USUARIO
:: ATENCAO: A variavel %PROJECT_PATH% contem o caminho absoluto onde o BAT foi executado
(
    ECHO Set WshShell = CreateObject("WScript.Shell")
    ECHO caminhoDoProjeto = "%PROJECT_PATH%\"
    ECHO WshShell.CurrentDirectory = caminhoDoProjeto
    ECHO WshShell.Run chr(34) & caminhoDoProjeto & "SyncJogo.bat" & chr(34), 0
    ECHO Set WshShell = Nothing
) > "%APP_DIR%\SyncLauncher.vbs"
ECHO Launcher criado em: "%APP_DIR%\SyncLauncher.vbs"

:: 3. Cria um Atalho para o Launcher na pasta Inicializar (Startup)
ECHO Set oShell = CreateObject("WScript.Shell") > "%TEMP%\shortcut.vbs"
ECHO Set oShortcut = oShell.CreateShortcut("%STARTUP_FOLDER%\%PROJECT_NAME% Sync.lnk") >> "%TEMP%\shortcut.vbs"
ECHO oShortcut.TargetPath = "%APP_DIR%\SyncLauncher.vbs" >> "%TEMP%\shortcut.vbs"
ECHO oShortcut.WorkingDirectory = "%APP_DIR%" >> "%TEMP%\shortcut.vbs"
ECHO oShortcut.Save >> "%TEMP%\shortcut.vbs"

cscript //nologo "%TEMP%\shortcut.vbs"
del "%TEMP%\shortcut.vbs"
ECHO Atalho criado para Inicializacao.

:: --- Bloco de Confirmação de Reinício ---
ECHO Set WshShell = CreateObject("WScript.Shell") > "%TEMP%\confirm_restart.vbs"
ECHO btn = WshShell.Popup("Instalacao completa. Deseja reiniciar o computador agora?", 0, "Confirmação de Reinício", 4 + 32) >> "%TEMP%\confirm_restart.vbs"
ECHO WScript.Quit btn >> "%TEMP%\confirm_restart.vbs"
cscript //nologo "%TEMP%\confirm_restart.vbs"

IF ERRORLEVEL 6 GOTO PerformRestart
GOTO EndInstallation

:PerformRestart
    ECHO Reiniciando o sistema...
    shutdown /r /t 5

:EndInstallation
    del "%TEMP%\confirm_restart.vbs" 2>nul
    ECHO Configuracao finalizada.
    PAUSE