Get-ChildItem "$PSScriptRoot\Public\*.ps1" | ForEach-Object { . $_.FullName }
Get-ChildItem "$PSScriptRoot\Private\*.ps1" | ForEach-Object { . $_.FullName }

$script:VaultPath = "$env:USERPROFILE\.tinyvault\vault.json"
$dir = Split-Path $script:VaultPath

if (-not (Test-Path $dir)) {
    Write-Verbose "Creating directory $dir..."
    New-Item -ItemType Directory -Path $dir | Out-Null
}

Write-Verbose "Initializing TinyVault..."
Initialize-TinyVaultSession
