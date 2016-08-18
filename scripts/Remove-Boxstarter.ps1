$ErrorActionPreference = "Stop"

Write-Host "Removing Boxstarter"

choco uninstall boxstarter --allversions

$desktopShortcut = "$env:USERPROFILE\Desktop\Boxstarter Shell.lnk"
if (Test-Path $desktopShortcut) { Remove-Item -Path $desktopShortcut -Force }

$startMenuShortcut = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Boxstarter"
if (Test-Path $startMenuShortcut) { Remove-Item -Path $startMenuShortcut -Recurse -Force }

$boxstaterAppData = "$env:APPDATA\Boxstarter"
if (Test-Path $boxstaterAppData ) { Remove-Item -Path $boxstaterAppData -Recurse -Force }