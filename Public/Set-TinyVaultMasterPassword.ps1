<#
.SYNOPSIS
Set the TinyVault master password

.DESCRIPTION
Change the TinyVault master password

.EXAMPLE
Set-TinyVaultMasterPassword
#>
function Set-TinyVaultMasterPassword {
    $oldPassword = Read-Host -AsSecureString "Current Master Password"
    
    try {
        $json = Unprotect-TinyVault -MasterPassword $oldPassword
    }
    catch {
        Write-Error "Wrong master password."
        return
    }

    do {
        $newPassword = Read-Host -AsSecureString "New Master Password"
        if ($newPassword.Length -eq 0) { Write-Host "Password is required." }
    } while ($newPassword.Length -eq 0)

    Protect-TinyVault -Json $json -MasterPassword $newPassword
    $script:MasterPassword = $newPassword
    Write-Host "Master password updated successfully."
}
