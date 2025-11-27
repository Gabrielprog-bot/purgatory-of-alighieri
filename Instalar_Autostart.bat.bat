:: --- INÍCIO: Confirmação de Reinício (Insira este bloco no final do seu instalar.bat) ---

:: 1. Cria um arquivo VBScript temporário que exibe a caixa de diálogo "Sim/Não"
echo Set WshShell = CreateObject("WScript.Shell") > "%temp%\confirm_restart.vbs"
echo btn = WshShell.Popup("A instalação foi concluída. Deseja reiniciar o computador agora?", 0, "Confirmação de Reinício", 4 + 32) >> "%temp%\confirm_restart.vbs"
echo WScript.Quit btn >> "%temp%\confirm_restart.vbs"

:: 2. Executa o VBScript e armazena a resposta (código de saída)
:: O código de saída (ERRORLEVEL) é 6 para "Sim" e 7 para "Não".
cscript //nologo "%temp%\confirm_restart.vbs"

:: 3. Verifica a resposta do usuário
IF ERRORLEVEL 6 GOTO PerformRestart

:: Se o usuário clicar em "Não" (código de saída 7), o código continua abaixo
ECHO O reinício foi cancelado pelo usuário.

:: 4. Limpa o script VBScript temporário
del "%temp%\confirm_restart.vbs"

GOTO EndInstallation

:PerformRestart
    ECHO Usuário escolheu Sim. Reiniciando o sistema em 5 segundos...
    :: Mude o "/t 5" para "/t 0" se quiser que seja instantâneo
    shutdown /r /t 5
    
:EndInstallation
    :: Limpa o script VBScript temporário (se não foi limpo antes)
    del "%temp%\confirm_restart.vbs" 2>nul
    
:: --- FIM: Confirmação de Reinício ---