<#
.SYNOPSIS
  A short one-line action-based description, e.g. 'Tests if a function is valid'
.DESCRIPTION
  A longer description of the function, its purpose, common use cases, etc.
.NOTES
  Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
  Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
  Test-MyTestFunction -Verbose
  Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Add-TinyVaultEntry {
  [CmdletBinding()]
  param (
    [String]$Name,
    [String]$Password,
    [String]$Env
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

  $secure = ConvertTo-SecureString $Password -AsPlainText -Force
  $encrypted = ConvertFrom-SecureString $secure
  $vault[$Name] = $encrypted
  $vault | ConvertTo-Json | Out-File $path

  Write-Output $vault
}