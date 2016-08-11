$ErrorActionPreference = "Stop"

# Remove Parallels Shared Folders shortcut on Public Desktop
$path = "C:\Users\Public\Desktop\Parallels Shared Folders.lnk"
if (Test-Path $path) { Remove-Item -Path $path -Force }