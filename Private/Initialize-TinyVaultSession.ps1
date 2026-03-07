function Initialize-TinyVaultSession {
    $script:MasterPassword = Read-Host -AsSecureString "TinyVault Master Password"
    if ($script:MasterPassword.Length -eq 0) {
        Write-Host "Master password is required."
        Initialize-TinyVaultSession
    }
}
