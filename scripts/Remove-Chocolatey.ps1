$ErrorActionPreference = "Stop"

Write-Host "Removing Chocolatey"

Remove-Item -Recurse -Force "$env:ChocolateyInstall"

# DO NOT UNCOMMNET CODE BELOW UNLESS YOU HAVE A FIX!!!
# something is wrong with the code below which is suppose to remove the chocolatey locations from the PATH environtment variable that causes issues with WinRM connection with packer

#[System.Text.RegularExpressions.Regex]::Replace( ` 
#[Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Environment').GetValue('PATH', '',  `
#[Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames).ToString(),  `
#[System.Text.RegularExpressions.Regex]::Escape("$env:ChocolateyInstall\bin") + '(?>;)?', '', `
#[System.Text.RegularExpressions.RegexOptions]::IgnoreCase) | `
#%{[System.Environment]::SetEnvironmentVariable('PATH', $_, 'User')}
#[System.Text.RegularExpressions.Regex]::Replace( `
#[Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment\').GetValue('PATH', '', `
#[Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames).ToString(),  `
#[System.Text.RegularExpressions.Regex]::Escape("$env:ChocolateyInstall\bin") + '(?>;)?', '', `
#[System.Text.RegularExpressions.RegexOptions]::IgnoreCase) | `
#%{[System.Environment]::SetEnvironmentVariable('PATH', $_, 'Machine')}

if ($env:ChocolateyBinRoot -ne '' -and $env:ChocolateyBinRoot -ne $null) { Remove-Item -Recurse -Force "$env:ChocolateyBinRoot" }
if ($env:ChocolateyToolsRoot -ne '' -and $env:ChocolateyToolsRoot -ne $null) { Remove-Item -Recurse -Force "$env:ChocolateyToolsRoot" }

# Remove Environment Variables
[System.Environment]::SetEnvironmentVariable("ChocolateyBinRoot", $null, 'User')
[System.Environment]::SetEnvironmentVariable("ChocolateyToolsLocation", $null, 'User')

[System.Environment]::SetEnvironmentVariable("ChocolateyInstall", $null, 'User')
[System.Environment]::SetEnvironmentVariable("ChocolateyLastPathUpdate", $null, 'User')