<#
.SYNOPSIS
Add a new entry in the Vault

.DESCRIPTION
A function for adding new entries in the Vault

.EXAMPLE
Add-TintyVault -Title AD -Name john@mail.com -Env Prod 
#>
function Add-TinyVaultEntry {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Title,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Prod", "NoProd")]
        [String]$Env
    )

    do {
        $password = Read-Host -AsSecureString "Insert Password"
        if ($password.Length -eq 0) { Write-Host "Password is required." }
    } while ($password.Length -eq 0)

    Write-Verbose "Encrypting password..."
    $encrypted = ConvertFrom-SecureString $password

    $path = ".\encrypted.json"

    if (Test-Path $path) {
        Write-Verbose "Found $path file"
        $vault = @(Get-Content $path | ConvertFrom-Json)
    }
    else {
        Write-Verbose "No $path file found"
        $vault = @{}
    }

    $maxId = if ($vault.Count -gt 0) { ($vault | Measure-Object -Property id -Maximum).Maximum } else { -1 }

    Write-Verbose "Adding new entry..."
    $vault += [PSCustomObject]@{
        id       = $maxId + 1
        title    = $Title
        name     = $Name
        env      = $Env
        password = $encrypted        
    }

    Write-Verbose "Generating json file..."
    $vault | ConvertTo-Json | Out-File $path
}
