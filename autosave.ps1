# Pasta onde o script PS1 está
$projectPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Caminho do auto_commit.bat
$commitScript = Join-Path $projectPath "auto_commit.bat"

# Criar watcher
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $projectPath
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

Write-Host "Monitorando alterações em: $projectPath"

# AÇÃO: quando detectar mudança → rodar auto_commit.bat
$action = {
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$using:commitScript`"" -WindowStyle Hidden
}

# Eventos monitorados
Register-ObjectEvent $watcher Changed -Action $action
Register-ObjectEvent $watcher Created -Action $action
Register-ObjectEvent $watcher Deleted -Action $action
Register-ObjectEvent $watcher Renamed -Action $action

# Manter rodando
while ($true) {
    Start-Sleep -Seconds 1
}
