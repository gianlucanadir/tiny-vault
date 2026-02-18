Function Copy-TinyVaultEntry {
  [CmdletBinding()]
  Param(
    [String]$Key
  )
  $path = ".\encrypted.json"
  $vault = @{}

  if (Test-Path $path) {
    $json = Get-Content $path
    if ($json) {
      $obj = $json | ConvertFrom-Json 
      foreach ($prop in $obj.Psobject.properties) {
        $vault[$prop.name] = $prop.value
      }
    }
  }
  $secure = ConvertTo-SecureString $vault[$key]
  $ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
  $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
  Set-Clipboard $plainPassword
}