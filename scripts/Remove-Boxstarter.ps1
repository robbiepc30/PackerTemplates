$ErrorActionPreference = "Stop"

Write-Host "Removing Boxstarter"

choco uninstall boxstarter --allversions

$path = "$env:USERPROFILE\Desktop\Boxstarter Shell.lnk"
if (Test-Path $path) { Remove-Item -Path $path -Force }