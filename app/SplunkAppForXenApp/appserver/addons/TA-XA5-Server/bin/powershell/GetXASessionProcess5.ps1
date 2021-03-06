. (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) XAFunctions.ps1)

$XA5Farm = New-Object -ComObject MetaFrameCOM.MetaFrameFarm
$XA5Server = New-Object -ComObject MetaFrameCOM.MetaFrameServer
$XA5Farm.Initialize(1)

# 6 is the enumeration value for MetaFrameWinSrvObject
$XA5Server.Initialize(6, $Env:COMPUTERNAME)

$FarmName = $XA5Farm.FarmName
$ScriptRunTime = (Get-Date).ToFileTime()

foreach($Session in $XA5Server.Sessions)
{
	foreach($Process in $Session.Processes)
	{
		$output = '{0}="{1}" ' -f "ProcessName", $Process.ProcessName
		$output += '{0}="{1}" ' -f "ProcessId", $Process.ProcessID
		$output += '{0}="{1}" ' -f "SessionId", $Process.SessionID
		$output += '{0}="{1}" ' -f "ServerName", $Process.ServerName
		$output += '{0}="{1}" ' -f "AccountDisplayName", $Process.UserName
		$output += '{0}="{1}" ' -f "State", (GetProcessState($Process.WinProcessObject.ProcessState))
		$output += '{0}="{1}" ' -f "CreationTime", (ConvertMFTime($Process.WinProcessObject.CreationTime2))
		$output += '{0}="{1}" ' -f "UserTime", (GetMFDuration($Process.WinProcessObject.UserTime2))
		$output += '{0}="{1}" ' -f "KernelTime", (GetMFDuration($Process.WinProcessObject.KernelTime2))
		$output += '{0}="{1}" ' -f "BasePriority", $Process.WinProcessObject.BasePriority
		$output += '{0}="{1}" ' -f "PeakVirtualSize", $Process.WinProcessObject.PeakVirtualSize
		$output += '{0}="{1}" ' -f "CurrentVirtualSize", $Process.WinProcessObject.CurrentVirtualSize
		$output += '{0}="{1}" ' -f "PageFaultCount", $Process.WinProcessObject.PageFaultCount
		$output += '{0}="{1}" ' -f "PeakWorkingSetSize", $Process.WinProcessObject.PeakWorkingSetSize
		$output += '{0}="{1}" ' -f "CurrentWorkingSetSize", $Process.WinProcessObject.CurrentWorkingSetSize
		$output += '{0}="{1}" ' -f "PeakPagedPoolQuota", $Process.WinProcessObject.PeakPagedPoolQuota
		$output += '{0}="{1}" ' -f "CurrentPagedPoolQuota", $Process.WinProcessObject.CurrentPagedPoolQuota
		$output += '{0}="{1}" ' -f "PeakNonPagedPoolQuota", $Process.WinProcessObject.PeakNonPagedPoolQuota
		$output += '{0}="{1}" ' -f "PageFileUsage", $Process.WinProcessObject.PageFileUsage
		$output += '{0}="{1}" ' -f "PrivatePageCount", $Process.WinProcessObject.PrivatePageCount
		
		Write-Host ("{0:MM/dd/yyyy HH:mm:ss} GMT - {1}" -f ((Get-Date).ToUniversalTime()), $output)
	}
}