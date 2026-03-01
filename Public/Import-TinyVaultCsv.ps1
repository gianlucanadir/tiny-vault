<#
.SYNOPSIS
Import the vault from a csv file

.DESCRIPTION
Create your vault by import numerous entries from a csv file

.EXAMPLE
Import-TinyVaultCsv -CsvFile data.csv
#>
function Import-TinyVaultCsv {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]$CsvFile
    )

    $out = ".\encrypted.json"
    $csv = Import-Csv $CsvFile

    if (-not (Test-Path $CsvFile)) { Write-Error "File not found."; return }
    if ([System.IO.Path]::GetExtension($CsvFile) -ne ".csv") { Write-Error "File $CsvFile must be a .csv."; return }

    Write-Verbose "Reading $CsvFile file..."
    $content = Get-Content $CsvFile

    if (-not $content) { Write-Error "File $CsvFile is empty."; return }

    for ($i = 0; $i -lt $csv.length; $i++) {
        $csv[$i] | Add-Member -NotePropertyName "id" -NotePropertyValue $i
        $secure = ConvertTo-SecureString $csv[$i].password -AsPlainText -Force
        $encrypted = ConvertFrom-SecureString $secure
        $csv[$i].password = $encrypted
    }

    Write-Verbose "Generating $out file..."
    $vault = ConvertTo-Json $csv
    $vault | Out-File $out
}
