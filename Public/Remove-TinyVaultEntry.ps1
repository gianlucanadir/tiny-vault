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
        [Parameter(Mandatory = $true, Position = 0)]
        [Int]$Id
    )

    $path = $Script:VaultPath

    if (Test-Path $path) {
        Write-Verbose "Found $path file"
        Write-Verbose "Decrypting vault..."
        $json = Unprotect-TinyVault -MasterPassword $script:MasterPassword

        if ($json) {
            $vault = $json | ConvertFrom-Json 

            Write-Verbose "Removing line with id $Id..."
            $vault = $vault | Where-Object id -NE $Id
        }
 
        Write-Verbose "Encrypting vault..."
        $json = ConvertTo-Json $vault
        Protect-TinyVault -Json $json -MasterPassword $script:MasterPassword
        Write-Verbose "Vault saved."
    }
}
