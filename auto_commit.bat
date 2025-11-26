@echo off
setlocal enabledelayedexpansion

:: Sempre executar na pasta do script
cd /d "%~dp0"

set LOGFILE=commit_log.txt

echo ==============================================
echo AUTO COMMIT AUTOMÁTICO INICIADO
echo Verificando alterações a cada 60 segundos...
echo ==============================================
echo.

:LOOP

:: Verificar alterações
git status --porcelain | findstr . >nul
if %errorlevel% equ 0 (
    :: ALGUMA ALTERAÇÃO FOI DETECTADA
    set DATA=%date%
    set HORA=%time:~0,8%

    echo [%DATA% %HORA%] Alterações detectadas. >> "%LOGFILE%"
    echo Commitando... >> "%LOGFILE%"

    git add . >> "%LOGFILE%" 2>&1
    git commit -m "Auto commit - %DATA% %HORA%" >> "%LOGFILE%" 2>&1

    if %errorlevel% neq 0 (
        echo [%DATA% %HORA%] ERRO ao criar commit. >> "%LOGFILE%"
        powershell -command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Erro ao criar commit. Veja o commit_log.txt','Auto Commit',0,'Error')" 
        goto WAIT
    )

    git push >> "%LOGFILE%" 2>&1

    if %errorlevel% neq 0 (
        echo [%DATA% %HORA%] ERRO ao enviar push. >> "%LOGFILE%"
        powershell -command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Erro ao fazer push.\nVerifique a internet ou o GitHub.','Auto Commit',0,'Error')"
        goto WAIT
    )

    echo [%DATA% %HORA%] Commit e push concluídos. >> "%LOGFILE%"
    echo.

    :: AQUI MOSTRA A JANELA PARA O USUÁRIO
    powershell -command ^
    "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('Commit automático realizado com sucesso!`n`nHora: %DATA% %HORA%','Auto Commit',0,'Info')"

) else (
    :: Sem alterações, log opcional
    echo [%date% %time:~0,8%] Sem alterações. >> "%LOGFILE%"
)

:WAIT
timeout /t 60 >nul
goto LOOP
