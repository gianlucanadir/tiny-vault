param(
    [string]$secret,
    [int]$seconds = 12
)

Start-Sleep -Seconds $seconds
$current = Get-Clipboard -Raw

if ($current -eq $secret) {
    Set-Clipboard $null
}


