# Boxstarter needs to run the Install-WMF5 because the remote WinRM session that packer initiates will fail the Install
# boxstarter is able to handle this and get it to install 
# REF http://www.hurryupandwait.io/blog/safely-running-windows-automation-operations-that-typically-fail-over-winrm-or-powershell-remoting
$secpasswd = ConvertTo-SecureString "vagrant" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("vagrant", $secpasswd)

Import-Module $env:appdata\boxstarter\boxstarter.chocolatey\boxstarter.chocolatey.psd1
Install-BoxstarterPackage -PackageName a:\Install-WMF5.ps1 -Credential $cred