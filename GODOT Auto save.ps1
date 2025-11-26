# Pega automaticamente a pasta onde esse script está
$projectPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Caminho do AutoCommit.bat dentro da mesma pasta
$commitScript = Join-Path $projectPath "auto_commit"

# Criar o watcher
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $projectPath
$watcher.Filter = "*.*"                
$watcher.IncludeSubdirectories = $true 
$watcher.EnableRaisingEvents = $true

Write-Host "Monitorando alterações em: $projectPath"
Write-Host "AutoCommit será executado ao detectar mudanças..."
Write-Host "Pressione Ctrl + C para parar.`n"

# AÇÃO AO MUDAR
$action = {
    Write-Host "`nAlterações detectadas! Executando AutoCommit.bat..."
    Start-Process -FilePath $using:commitScript -WindowStyle Hidden
}

# Eventos
Register-ObjectEvent $watcher Changed -Action $action
Register-ObjectEvent $watcher Created -Action $action
Register-ObjectEvent $watcher Deleted -Action $action
Register-ObjectEvent $watcher Renamed -Action $action

# Mantém o script rodando
while ($true) {
    Start-Sleep -Seconds 1
}
