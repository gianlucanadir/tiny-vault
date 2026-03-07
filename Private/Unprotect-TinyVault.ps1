function Unprotect-TinyVault {
    param(
        [Parameter(Mandatory)]
        [System.Security.SecureString]$MasterPassword
    )

    $plain = [Runtime.InteropServices.Marshal]::PtrToStringBSTR(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($MasterPassword)
    )

    $raw = [System.IO.File]::ReadAllBytes($script:VaultPath)
    $salt = $raw[0..15]
    $encrypted = $raw[16..($raw.Length - 1)]

    $pbkdf2 = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($plain, $salt, 100000)
    $key = $pbkdf2.GetBytes(32)
    $iv = $pbkdf2.GetBytes(16)

    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Key = $key
    $aes.IV = $iv

    $decrypted = $aes.CreateDecryptor().TransformFinalBlock($encrypted, 0, $encrypted.Length)
    return [Text.Encoding]::UTF8.GetString($decrypted)
}
