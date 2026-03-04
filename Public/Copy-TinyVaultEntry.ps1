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
    $path = "$env:USERPROFILE\vault.json"

    if (Test-Path $path) {
        Write-Verbose "Found $path file"
        $json = Get-Content $path
        if ($json) {
            $obj = $json | ConvertFrom-Json 
        }
        else {
            Write-Error "$path is empty. Nothing to copy here."; return
        }    
    }
    else {
        Write-Error "No vault file found in: $path"; return
    }
  
    Write-Verbose "Decrypting password.."
    $password = $obj | Where-Object id -EQ $Id | Select-Object -ExpandProperty password
    $secure = ConvertTo-SecureString $password
    $ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)

    Write-Verbose "Copying password to the clipboard..."
    Set-Clipboard $plainPassword
}
