Import-Module $env:appdata\boxstarter\boxstarter.chocolatey\boxstarter.chocolatey.psd1

$secpasswd = ConvertTo-SecureString "vagrant" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("vagrant", $secpasswd)

# temp disable checksumFiles, Boxstarter creates a chocolatey package that doesnt have a checksum.
#      this seems to cause issues with the install of WMF since it is downloaded over the internet
choco feature disable -n checksumFiles

# Boxstarter uses chocolatey to install the latest version of powershell currently v5, boxstarter gets around issues of installing over WinRM
# REF http://www.hurryupandwait.io/blog/safely-running-windows-automation-operations-that-typically-fail-over-winrm-or-powershell-remoting
Install-BoxstarterPackage -PackageName powershell -Credential $cred -DisableReboots

# re-enable checksumFiles
choco feature disable -n checksumFiles\

# Note: boxstarter may say that it failed, but ... it most likely didn't. WMF5 requires a reboot to finish. this will be completed later