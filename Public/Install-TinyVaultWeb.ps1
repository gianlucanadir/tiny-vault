function Install-TinyVaultWeb {
    [CmdletBinding()]
    param()

    $vaultDir = Split-Path $Script:VaultPath
    $webDir = Join-Path $vaultDir "web"
    $uriPs1 = "https://gist.githubusercontent.com/gianlucanadir/0210d8ad17d190a6a1e273c6d12c9c29/raw/Start-TinyVaultWeb.ps1"
    $uriHtml = "https://gist.githubusercontent.com/gianlucanadir/0210d8ad17d190a6a1e273c6d12c9c29/raw/tinyvault.html"
    $uriBat = "https://gist.githubusercontent.com/gianlucanadir/0210d8ad17d190a6a1e273c6d12c9c29/raw/tinyvault.bat"

    if (-not (Test-Path $webDir)) {
        Write-Verbose "Creating directory $webDir..."
        New-Item -ItemType Directory -Path $webDir | Out-Null
    }

    try {
        Write-Verbose "Downloading Start-TinyVaultWeb.ps1..."
        Invoke-WebRequest -Uri $uriPs1 -OutFile $webDir

        Write-Verbose "Downloading tinyvault.html..."
        Invoke-WebRequest -Uri $uriHtml -OutFile $webDir

        Write-Verbose "Downloading tinyvault.bat..."
        Invoke-WebRequest -Uri $uriBat -OutFile $webDir
    }
    catch {
        throw "Error: Cannot download files from $uriPs1"
    }
}
