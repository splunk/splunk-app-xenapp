# Getting current path of the script and changing directory
$Parent = Split-Path $MyInvocation.MyCommand.Path -Parent
Set-location $Parent

# Killing any splunk-perfmon.exe processes
Get-Process splunk-perfmon -ea 0 | Stop-Process -ea 0

$TempPath = "{0}\{1}" -f $Env:Temp,"splunk_perfmon"

# Copying the contents of perfmon to temp
if(Test-Path $TempPath)
{
    Get-ChildItem $TempPath | Remove-Item -force
    copy ..\perfmon\*.* $TempPath
}
else
{
    mkdir $TempPath | out-null
    copy ..\perfmon\*.* $TempPath
}

# Starting Splunk-Perfmon
& "${TempPath}\splunk-perfmon.exe"