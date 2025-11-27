Set WshShell = CreateObject("WScript.Shell") 
WshShell.CurrentDirectory = "C:\Users\gabriel\Documents\GitHub\purgatory-of-alighieri\" 
WshShell.Run chr(34) & "C:\Users\gabriel\Documents\GitHub\purgatory-of-alighieri\SyncJogo.bat" & chr(34), 0 
Set WshShell = Nothing 
