<#
.SYNOPSIS
Add a new entry in the Vault

.DESCRIPTION
A function for adding new entries in the Vault

.EXAMPLE
Add-TinyVaultEntry -Title Jira -Name john@mail.com -Env Prod
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

        [ValidateNotNullOrEmpty()]
        [String]$Env
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
        $vault = @($json | ConvertFrom-Json)
    }
    else {
        Write-Verbose "No $path file found"
        $vault = @()
    }

    do {
        $password = Read-Host -AsSecureString "Insert Password for $Title"
        if ($password.Length -eq 0) { Write-Host "Password is required." }
    } while ($password.Length -eq 0)

    $plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
    )

    $maxId = if ($vault.Count -gt 0) { [int]($vault | Measure-Object -Property id -Maximum).Maximum } else { -1 }

    Write-Verbose "Adding new entry..."
    $vault += [PSCustomObject]@{
        id       = $maxId + 1
        title    = $Title
        name     = $Name
        env      = $Env
        password = $plainPassword
    }
    
    Write-Verbose "Encrypting vault..."
    $json = ConvertTo-Json $vault
    Protect-TinyVault -Json $json -MasterPassword $script:MasterPassword
    Write-Verbose "Vault saved."
}
