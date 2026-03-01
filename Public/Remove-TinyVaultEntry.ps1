<#
.SYNOPSIS
Remove an entry from the vault

.DESCRIPTION
Remove an entry from the vault by Id

.EXAMPLE
Remove-TinyVaultEntry -Id 1
#>
function Remove-TinyVaultEntry {
    [CmdletBinding()]
    param (
        [Int]$Id
    )

    $path = ".\encrypted.json"

    if (Test-Path $path) {
        Write-Verbose "Found $path file"
        $json = Get-Content $path

        if ($json) {
            $vault = $json | ConvertFrom-Json 

            Write-Verbose "Removing line with id $Id..."
            $vault = $vault | Where-Object id -NE $Id
        }
 
        Write-Verbose "Generating new $path file..."
        $vault | ConvertTo-Json | Out-File $path
    }
}
