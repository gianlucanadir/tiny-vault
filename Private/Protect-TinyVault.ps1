function Protect-TinyVault {
    param(
        [Parameter(Mandatory)]
        [string]$Json,
        [Parameter(Mandatory)]
        [System.Security.SecureString]$MasterPassword
    )

    $plain = [Runtime.InteropServices.Marshal]::PtrToStringBSTR(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($MasterPassword)
    )

    $salt = [byte[]]::new(16)
    [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($salt)

    $pbkdf2 = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($plain, $salt, 100000)
    $key = $pbkdf2.GetBytes(32)
    $iv = $pbkdf2.GetBytes(16)

    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Key = $key
    $aes.IV = $iv

    $plainBytes = [Text.Encoding]::UTF8.GetBytes($Json)
    $encrypted = $aes.CreateEncryptor().TransformFinalBlock($plainBytes, 0, $plainBytes.Length)

    $result = $salt + $encrypted
    [System.IO.File]::WriteAllBytes($script:VaultPath, $result)
}
