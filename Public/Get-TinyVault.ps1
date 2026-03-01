<#
.SYNOPSIS
Get the TinyVault object

.DESCRIPTION
Get the TinyVault object fromt the vault.json file

.EXAMPLE
Get-TinyVault
#>
function Get-TinyVault {
    $path = "$env:USERPROFILE\vault.json"
    $vaultFile = Split-Path $path -Leaf

    if (-not (Test-Path $path)) {
        Write-Error "No $vaultFile found in the current directory"; return
    }

    $json = Get-Content $path -Raw
    return ($json | ConvertFrom-Json)
}
