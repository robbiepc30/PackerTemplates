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

Write-BoxstarterMessage "Enabling file sharing firewall rules"
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

if(Test-PendingReboot){ Invoke-Reboot }

Write-BoxstarterMessage "Enable WinRM firewall rule"
netsh advfirewall firewall set rule name="WinRM-HTTP" new action=allow
