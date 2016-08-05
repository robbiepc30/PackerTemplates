
REM This batch file should be copied via the File Provisioner in Packer template to
REM C:/Windows/Setup/scripts/SetupComplete.cmd
REM this will be batch file will automatically be executed after windows setup completes
REM ref https://technet.microsoft.com/en-us/library/cc766314(v=ws.10).aspx

REM Change WinRM service start type back to auto
cmd.exe /c sc config winrm start=auto

REM Start WinRM so Vagrant can now connect to VM
cmd.exe /c net start winrm
      