REM Change WinRM service start type to manual, this clears up issues with Vagrant trying to connect to a machine during sysprep 
REM (initial sysprep reboots cause Vagrant to loose connection and destroy the vm)
REM This is changed back to auto and service started in SetupComplete.cmd, that batch file is executed automatically after windows setup completes

sc config winrm start=demand

REM Sysprep/Generalize windows, use unattend file for OOBE
C:/windows/system32/sysprep/sysprep.exe /generalize /oobe /unattend:C:/Windows/Panther/Unattend/unattend.xml /quiet /shutdown