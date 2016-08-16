$ErrorActionPreference = "Stop"

Write-Host "Removing Parallels Shared Folder Desktop Shortcut"
# Remove Parallels Shared Folders shortcut on Public Desktop
$path = "C:\Users\Public\Desktop\Parallels Shared Folders.lnk"
if (Test-Path $path) { Remove-Item -Path $path -Force }