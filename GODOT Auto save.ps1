# Este script deve ser salvo DENTRO da pasta do seu projeto Godot.

# Configurações
# O caminho para a pasta a ser monitorada é o diretório atual do script
$PathToWatch = (Get-Item -Path $PSScriptRoot).FullName
# O caminho para o script .bat é o mesmo diretório
$PathToBat = Join-Path $PathToWatch "auto_commit.bat"

# --- Configuração do Monitoramento ---
$Watcher = New-Object System.IO.FileSystemWatcher
$Watcher.Path = $PathToWatch
$Watcher.IncludeSubdirectories = $true
$Watcher.EnableRaisingEvents = $true

# Define um buffer de tempo para evitar múltiplas execuções por um único salvamento
$LastRunTime = Get-Date

# --- Ação a ser executada na mudança ---
$Action = {
    # Garante que o script só rode uma vez a cada 5 segundos
    if ((Get-Date) -gt $script:LastRunTime.AddSeconds(5)) {
        $script:LastRunTime = Get-Date
        
        Write-Host "--- Mudança detectada ---"
        Write-Host "Executando o script .bat: $PathToBat"
        
        # Executa o script .bat
        # O parâmetro -NoNewWindow garante que o .bat rode em segundo plano
        Start-Process -FilePath $PathToBat -NoNewWindow -Wait
        
        Write-Host "Execução do .bat concluída. Monitorando novamente..."
    }
}

# Associa a ação aos eventos de mudança
Register-ObjectEvent -InputObject $Watcher -EventName Changed -Action $Action -SourceIdentifier FileChanged
Register-ObjectEvent -InputObject $Watcher -EventName Created -Action $Action -SourceIdentifier FileCreated

Write-Host "Monitoramento iniciado na pasta: $PathToWatch"
Write-Host "Pressione Ctrl+C para parar o monitoramento."

# Mantém o script rodando em loop
while ($true) {
    Start-Sleep -Seconds 1
}
