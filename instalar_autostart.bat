@echo off
:: Arquivo: instalar_autostart.bat
:: Instala o Launcher no diretorio do usuario e cria a tarefa agendada.

SET "PROJECT_NAME=purgatory-of-alighieri"
SET "APP_DIR=%USERPROFILE%\AutoSave\%PROJECT_NAME%"
SET "PROJECT_PATH=%CD%"
SET "LAUNCHER_NAME=SyncLauncher.vbs"
SET "TASK_NAME=Git Sync - %PROJECT_NAME%"

ECHO --- Instalacao do Auto Save ---

:: 1. Cria a pasta de aplicacao local do usuario e o diretorio de Inicializacao
MKDIR "%APP_DIR%" 2>nul
ECHO Pasta de aplicacao criada em: %APP_DIR%

:: 2. Cria o Launcher VBScript DENTRO da pasta de aplicacao do USUARIO
:: O '0' no final da linha 'WshShell.Run' e o 'Run Rider' que voce pediu (oculta a janela).
(
    ECHO Set WshShell = CreateObject("WScript.Shell")
    ECHO caminhoDoProjeto = "%PROJECT_PATH%\"
    ECHO WshShell.CurrentDirectory = caminhoDoProjeto
    ECHO WshShell.Run chr(34) & caminhoDoProjeto & "SyncJogo.bat" & chr(34), 0
    ECHO Set WshShell = Nothing
) > "%APP_DIR%\%LAUNCHER_NAME%"
ECHO Launcher invisivel criado e configurado.

:: 3. CRIA A TAREFA AGENDADA (Task Scheduler)
:: Task agendada para rodar a cada 30 minutos, iniciando o Launcher VBScript.
SCHTASKS /Create /TN "%TASK_NAME%" /TR "wscript.exe \"%APP_DIR%\%LAUNCHER_NAME%\"" /SC MINUTE /MO 30 /F

IF ERRORLEVEL 0 (
    ECHO Tarefa Agendada "%TASK_NAME%" criada com sucesso!
) ELSE (
    ECHO ERRO: Falha ao criar a Tarefa Agendada. Execute como Administrador.
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