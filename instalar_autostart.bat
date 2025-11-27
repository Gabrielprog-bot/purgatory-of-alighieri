@echo off
:: Arquivo: instalar_autostart.bat
:: Cria a pasta C:\Save_Git, instala o Launcher VBScript e configura a tarefa agendada.

SET "CONFIG_DIR=C:\Save_Git"
SET "PROJECT_NAME=purgatory-of-alighieri"
SET "PROJECT_PATH=%CD%"
SET "LAUNCHER_NAME=SyncLauncher.vbs"
SET "TASK_NAME=Git Sync - %PROJECT_NAME%"

ECHO --- Instalacao do Auto Save em C:\Save_Git ---

:: 1. Cria a pasta de configuracao centralizada
MKDIR "%CONFIG_DIR%" 2>nul
ECHO Pasta de configuracao criada em: %CONFIG_DIR%

:: 2. Cria o Launcher VBScript DENTRO da pasta C:\Save_Git
:: O '0' no final da linha WshShell.Run garante o modo invisivel.
(
    ECHO Set WshShell = CreateObject("WScript.Shell")
    :: Grava o caminho absoluto do projeto dentro do Launcher
    ECHO caminhoDoProjeto = "%PROJECT_PATH%\"
    ECHO WshShell.CurrentDirectory = caminhoDoProjeto
    ECHO WshShell.Run chr(34) & caminhoDoProjeto & "SyncJogo.bat" & chr(34), 0
    ECHO Set WshShell = Nothing
) > "%CONFIG_DIR%\%LAUNCHER_NAME%"
ECHO Launcher invisivel criado em: %CONFIG_DIR%\%LAUNCHER_NAME%

:: 3. CRIA A TAREFA AGENDADA (Task Scheduler)
:: Aponta diretamente para o VBScript na pasta C:\Save_Git
SCHTASKS /Create /TN "%TASK_NAME%" /TR "wscript.exe \"%CONFIG_DIR%\%LAUNCHER_NAME%\"" /SC MINUTE /MO 30 /F

IF ERRORLEVEL 0 (
    ECHO Tarefa Agendada "%TASK_NAME%" criada com sucesso!
) ELSE (
    ECHO ERRO: Falha ao criar a Tarefa Agendada. Execute o BAT como Administrador.
)

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