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

    if (-not (Test-Path $path)) {
        Write-Error "No vault file found in: $path"; return
    }

    $json = Get-Content $path -Raw
    return ($json | ConvertFrom-Json)
}
