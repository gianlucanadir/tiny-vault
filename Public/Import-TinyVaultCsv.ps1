<#
.SYNOPSIS
Import the vault from a csv file

.DESCRIPTION
Create your vault by import numerous entries from a csv file

.EXAMPLE
An example of data.csv file:

title,name,env,password
Jira,john@mail.com,Prod,D0ntJudg3M3!
Confluence,john@mail.com,Staging,SuperP4ssw0rd123
Jenkins,john@mail.com,Dev,TryH@ckM3

Import-TinyVaultCsv -CsvFile data.csv

+-------------+------------------+---------+------------------+
| Title       | Name             | Env     | Password         |
+-------------+------------------+---------+------------------+
| Jira        | john@mail.com    | Prod    | D0ntJudg3M3!     |
| Confluence  | john@mail.com    | Staging | SuperP4ssw0rd123 |
| Jenkins     | john@mail.com    | Dev     | TryH@ckM3        |
+-------------+------------------+---------+------------------+
#>
function Import-TinyVaultCsv {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [String]$CsvFile
    )

    $csv = Import-Csv $CsvFile

    if (-not (Test-Path $CsvFile)) { Write-Error "File not found."; return }
    if ([System.IO.Path]::GetExtension($CsvFile) -ne ".csv") { Write-Error "File $CsvFile must be a .csv."; return }

    Write-Verbose "Reading $CsvFile file..."
    $content = Get-Content $CsvFile

    if (-not $content) { Write-Error "File $CsvFile is empty."; return }

    for ($i = 0; $i -lt $csv.length; $i++) {
        $csv[$i] | Add-Member -NotePropertyName "id" -NotePropertyValue $i
    }
    
    Write-Verbose "Encrypting vault..."
    $json = ConvertTo-Json $csv
    Protect-TinyVault -Json $json -MasterPassword $script:MasterPassword
    Write-Verbose "Vault saved."
}
