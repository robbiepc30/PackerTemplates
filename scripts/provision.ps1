$ErrorActionPreference = "Stop"

#region Install Parallels Guest Tools
    # Need to use "parallels_tools_mode": "attach" in the JSON file to attach instead of upload to load tools this way
    # This removes the necessity to have a third party app downloaded and installed to extract iso files
        
    $cdrom = @(Get-WmiObject win32_logicaldisk -filter 'DriveType=5' | ForEach-Object { $_.DeviceID })

    foreach ($c in $cdrom) {
        $path = "$c\PTAgent.exe"
        if(Test-path $path){
            Start-Process -Filepath $path -ArgumentList "/install_silent" -Wait
            "Parallels tools finshed installing..."
        }
    }
#endregion

#region Remove Boxstarter
    Write-Host "Remove Boxstarter"
    choco uninstall boxstarter --allversions

    $path = "$env:USERPROFILE\Desktop\Boxstarter Shell.lnk"
    if (Test-Path $path) { Remove-Item -Path $path -Force }
#endregion

#region Remove Chocolatey
    Write-Host "Remove Chocolatey"

    Remove-Item -Recurse -Force "$env:ChocolateyInstall"
    [System.Text.RegularExpressions.Regex]::Replace([Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Environment').GetValue('PATH', '', [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames).ToString(), [System.Text.RegularExpressions.Regex]::Escape("$env:ChocolateyInstall\bin") + '(?>;)?', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase) | %{[System.Environment]::SetEnvironmentVariable('PATH', $_, 'User')}


    [System.Text.RegularExpressions.Regex]::Replace([Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment\').GetValue('PATH', '', [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames).ToString(), [System.Text.RegularExpressions.Regex]::Escape("$env:ChocolateyInstall\bin") + '(?>;)?', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase) | %{[System.Environment]::SetEnvironmentVariable('PATH', $_, 'Machine')}

    if ($env:ChocolateyBinRoot -ne '' -and $env:ChocolateyBinRoot -ne $null) { Remove-Item -Recurse -Force "$env:ChocolateyBinRoot" }
    if ($env:ChocolateyToolsRoot -ne '' -and $env:ChocolateyToolsRoot -ne $null) { Remove-Item -Recurse -Force "$env:ChocolateyToolsRoot" }

    # Remove Environment Variables
    [System.Environment]::SetEnvironmentVariable("ChocolateyBinRoot", $null, 'User')
    [System.Environment]::SetEnvironmentVariable("ChocolateyToolsLocation", $null, 'User')

    [System.Environment]::SetEnvironmentVariable("ChocolateyInstall", $null, 'User')
    [System.Environment]::SetEnvironmentVariable("ChocolateyLastPathUpdate", $null, 'User')

#endregion

#region Remove Parallels Shared Folders shortcut on Public Desktop
    Write-Host "Remove-ParallelsDesktopShortcut"

    $path = "C:\Users\Public\Desktop\Parallels Shared Folders.lnk"
    if (Test-Path $path) { Remove-Item -Path $path -Force }
#endregion

Write-Host "copying SetupComplete.cmd to correct location"
mkdir C:\Windows\setup\scripts
copy-item a:\SetupComplete.cmd C:\Windows\setup\scripts\SetupComplete.cmd -Force

Write-Host "copying unattend.xml to correct location"
mkdir C:\Windows\Panther\Unattend
copy-item a:\postunattend.xml C:\Windows\Panther\Unattend\unattend.xml