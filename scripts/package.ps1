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
#if (Test-Command -cmdname 'Uninstall-WindowsFeature') {
#    Write-BoxstarterMessage "Removing unused features..."
#    Remove-WindowsFeature -Name 'Powershell-ISE'
#    Get-WindowsFeature | 
#    Where-Object { $_.InstallState -eq 'Available' } | 
#    Uninstall-WindowsFeature -Remove
#}
#
#Write-BoxstarterMessage "Installing Windows Updates"
#Install-WindowsUpdate -AcceptEula

Write-BoxstarterMessage "Setting up WinRM"

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

# Testing something by moving this:  if(Test-PendingReboot){ Invoke-Reboot }  to the end of the script
# It seems that if WMF5 is installed and then rebooted (now PS is running v5) and then the WinRM stuff is enabled, vagrant errors out with WinRM::WinRMAuthorizationError
# however if these settings are applied first then WMF5 is intalled it works fine... I have no idea why... Need to investgate further...
if(Test-PendingReboot){ Invoke-Reboot }

netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
Write-BoxstarterMessage "winrm setup complete"