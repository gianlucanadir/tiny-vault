<#
.SYNOPSIS
Copy the decrypted password from an entry

.DESCRIPTION
Copy the decrypted password of an entry selected by Id. The password will be availbale for 12 seconds.

.EXAMPLE
Copy-TinyVault Entry -Id 1
#>
function Copy-TinyVaultEntry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateRange(0, [int]::MaxValue)]
        [Int]$Id
    )
    $path = $Script:VaultPath

    if (Test-Path $path) {
        Write-Verbose "Found $path file"
        Write-Verbose "Decrypting vault..."

        try {
            $json = Unprotect-TinyVault -MasterPassword $script:MasterPassword
        }
        catch {
            Write-Error $_.Exception.Message
            return
        }

        if ($json) {
            $obj = $json | ConvertFrom-Json 
        }
        else {
            throw "$path is empty. Nothing to copy here."
        }    
    }
    else {
        throw "No vault file found in: $path"
    }
  
    $password = $obj | Where-Object id -EQ $Id | Select-Object -ExpandProperty password

    Write-Verbose "Copying password to the clipboard..."
    Set-Clipboard $password 
}
