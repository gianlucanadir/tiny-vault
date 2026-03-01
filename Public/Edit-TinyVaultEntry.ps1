<#
.SYNOPSIS
Edit a entry in the Vault

.DESCRIPTION
A function that allows to edit an existing entry by Id

.EXAMPLE
Edit-TinyVaultEntry -Id 1 -NewTitle Github -NewName user@mail.com -NewEnv NoProd
#>
function Edit-TinyVaultEntry {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, [int]::MaxValue)]
        [Int]$Id,

        [String]$NewTitle,
        [String]$NewName,

        [ValidateSet("Prod", "NoProd")]
        [String]$NewEnv
    )

    $path = "$env:USERPROFILE\vault.json"
    $vaultFile = Split-Path $path -Leaf

    if (Test-Path $path) {
        Write-Verbose "Found $path file"
        $json = Get-Content $path
        if ($json) {
            $vault = $json | ConvertFrom-Json 
            $entry = $vault | Where-Object Id -EQ $Id

            $newPassword = Read-Host -AsSecureString "New Password (press ENTER to keep current)"

            if ($newPassword.Length) {
                Write-Verbose "Adding new password.."
                $entry.password = ConvertFrom-SecureString $newPassword
            }

            if ($NewTitle.Length) {
                Write-Verbose "Adding new title.."
                $entry.title = $NewTitle
            }

            if ($NewName.Length) {
                Write-Verbose "Adding new name.."
                $entry.name = $NewName
            }

            if ($NewEnv.Length) {
                Write-Verbose "Adding new env.."
                $entry.env = $NewEnv
            }        
            Write-Verbose "Generating json file..."
            $vault | ConvertTo-Json | Out-File $path
        }
        else {
            Write-Error "$vaultFile is empty. Nothing to edit here."; return
        }
    }
    else {
        Write-Error "No $vaultFile found in the current directory"; return
    }
}
