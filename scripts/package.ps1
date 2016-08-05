$ErrorActionPreference = "Stop"

function Test-Command($cmdname)
{
    try {
      Get-Command -Name $cmdname
      return $true
    }
    catch {
      $global:error.RemoveAt(0)
      return $false
    }
}

Write-BoxstarterMessage "Enable Remote Desktop"
Enable-RemoteDesktop
netsh advfirewall firewall add rule name="Remote Desktop" dir=in localport=3389 protocol=TCP action=allow

Write-BoxstarterMessage "Enabling file sharing firewale rules"
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=yes

Update-ExecutionPolicy -Policy Unrestricted

# Remove unused features before installing windows updates
if (Test-Command -cmdname 'Uninstall-WindowsFeature') {
    Write-BoxstarterMessage "Removing unused features..."
    Remove-WindowsFeature -Name 'Powershell-ISE'
    Get-WindowsFeature | 
    Where-Object { $_.InstallState -eq 'Available' } | 
    Uninstall-WindowsFeature -Remove
}

#Write-BoxstarterMessage "Installing Windows Updates"
#Install-WindowsUpdate -AcceptEula

if(Test-PendingReboot){ Invoke-Reboot }

Write-BoxstarterMessage "Setting up WinRM"
netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow

$enableArgs=@{Force=$true}
try {
 $command = Get-Command Enable-PSRemoting
  if ($command.Parameters.Keys -contains "skipnetworkprofilecheck") {
      $enableArgs.skipnetworkprofilecheck=$true
  }
}
catch {
  $global:error.RemoveAt(0)
}

Enable-PSRemoting @enableArgs
Enable-WSManCredSSP -Force -Role Server
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
Write-BoxstarterMessage "winrm setup complete"