<#
.SYNOPSIS
Get the TinyVault object

.DESCRIPTION
Get the TinyVault object fromt the vault.json file

.EXAMPLE
Get-TinyVault
#>
function Get-TinyVault {
    if (-not (Test-Path $Script:VaultPath)) {
        Write-Error "No vault file found in: $Script:VaultPath"; return
    }

    Write-Verbose "Decrypting vault..."
    $json = Unprotect-TinyVault -MasterPassword $script:MasterPassword
    $vault = $json | ConvertFrom-Json | Select-Object Id, Title, Name, Env
    $vault
}
