$WinlogonPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
Remove-ItemProperty -Path $WinlogonPath -Name AutoAdminLogon
Remove-ItemProperty -Path $WinlogonPath -Name DefaultUserName

iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/mwrock/boxstarter/master/BuildScripts/bootstrapper.ps1'))
Get-Boxstarter -Force

# Testing something by moving this: 
# It seems that if WMF5 is installed and then rebooted (now PS is running v5) and then the WinRM stuff is enabled, vagrant errors out with WinRM::WinRMAuthorizationError
# however if these settings are applied first then WMF5 is intalled it works fine... I have no idea why... Need to investgate further...
Write-Host "Setting up WinRM"
#block WinRM for now. need to hold off untill boxstarter is finished, then packer provisioning will take over
netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=block
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
Write-Host "winrm setup complete... with exception of firewall rule, blocking untill boxstarter finishes setup"

# Install latest version of PowerShell (currently v5) from chocolatey
# cannot using packer provisioning because it uses WinRM ... cannot install from WinRM, so this needs to be done before provisioning.
# REF http://www.hurryupandwait.io/blog/safely-running-windows-automation-operations-that-typically-fail-over-winrm-or-powershell-remoting
# Also after much trial and error there are issues installing it using Boxstarter, so doing it here instead

choco install powershell -y 

$secpasswd = ConvertTo-SecureString "vagrant" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("vagrant", $secpasswd)
Import-Module $env:appdata\boxstarter\boxstarter.chocolatey\boxstarter.chocolatey.psd1
Install-BoxstarterPackage -PackageName a:\package.ps1 -Credential $cred

# Testing something by using -DisableReboots
# It seems that if WMF5 is installed and then rebooted (now PS is running v5) and then the WinRM stuff is enabled, vagrant errors out with WinRM::WinRMAuthorizationError
# however if these settings are applied first then WMF5 is intalled it works fine... I have no idea why... Need to investgate further...