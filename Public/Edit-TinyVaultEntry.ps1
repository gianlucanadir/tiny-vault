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
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateRange(0, [int]::MaxValue)]
        [Int]$Id,

        [String]$NewTitle,
        [String]$NewName,

        [ValidateSet("Prod", "NoProd")]
        [String]$NewEnv
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
            $vault = $json | ConvertFrom-Json 
            $entry = $vault | Where-Object Id -EQ $Id

            $newPassword = Read-Host -AsSecureString "New Password (press ENTER to keep current)"
            $plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR(
                [Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPassword)
            )

            if ($newPassword.Length) {
                Write-Verbose "Adding new password.."
                $entry.password = $plainPassword            
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

            Write-Verbose "Encrypting vault..."
            $json = ConvertTo-Json $vault
            Protect-TinyVault -Json $json -MasterPassword $script:MasterPassword
            Write-Verbose "Vault saved."
        }
        else {
            Write-Error "$vaultFile is empty. Nothing to edit here."; return
        }
    }
    else {
        Write-Error "No vault file found in: $path"; return
    }
}
