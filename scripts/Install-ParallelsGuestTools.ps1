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