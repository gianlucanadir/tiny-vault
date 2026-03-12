<#
.SYNOPSIS
Start the TinyVault Web Server

.DESCRIPTION
Start the TinyVault Web Server located at $home\.tinyvault\web

.EXAMPLE
Start-TinyVaultWeb
#>
function Start-TinyVaultWeb {
    [CmdletBinding()]
    param()

    $path = "$home\.tinyvault\web\Start-TinyVaultWeb.ps1"

    if (Test-Path $path) {
        Start-Process pwsh -ArgumentList "-File $path"
    }
    else {
        Write-Error "Web server not found at $path. Run Install-TinyVaultWeb to download it."
        return
    }
}
