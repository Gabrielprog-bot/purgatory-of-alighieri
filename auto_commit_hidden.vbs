Set WshShell = CreateObject("WScript.Shell") 
WshShell.CurrentDirectory = "C:\Users\gabriel\Documents\purgatory-of-alighieri" 
WshShell.Run "C:\Users\gabriel\Documents\purgatory-of-alighieri\auto_commit.bat", 0, False 
