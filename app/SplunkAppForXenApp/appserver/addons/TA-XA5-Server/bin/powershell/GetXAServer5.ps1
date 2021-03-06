. (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) XAFunctions.ps1)

$XA5Farm = New-Object -ComObject MetaFrameCOM.MetaFrameFarm
$XA5Server = New-Object -ComObject MetaFrameCOM.MetaFrameServer
$XA5Farm.Initialize(1)

# 6 is the enumeration value for MetaFrameWinSrvObject
$XA5Server.Initialize(6, $Env:COMPUTERNAME)

$FarmName = $XA5Farm.FarmName
$ScriptRunTime = (Get-Date).ToFileTime()

$output = '{0}="{1}" ' -f "ServerName", $XA5Server.ServerName
$output += '{0}="{1}" ' -f "FolderPath", $XA5Server.ParentFolderDN
$output += '{0}="{1}" ' -f "ZoneName", $XA5Server.ZoneName
$output += '{0}="{1}" ' -f "ElectionPreference", (GetXAElectionPreference($XA5Server.ZoneRanking))
$output += '{0}="{1}" ' -f "IPAddresses", (($XA5Server.WinServerObject.TcpAddresses) -join ";")
$output += '{0}="{1}.{2}.{3}" ' -f "OSVersion", 
	$XA5Server.WinServerObject.WinNTVerMajor, 
	$XA5Server.WinServerObject.WinNTVerMinor, 
	$XA5Server.WinServerObject.WinNTBuild

$output += '{0}="{1}" ' -f "OSServicePack", $XA5Server.WinServerObject.WinNTServicePack	

# This property will actually list all Citrix products installed, but for XenApp 6 compliance, we will only
# output "Citrix Presentation Server"
$output += '{0}="{1}" ' -f "CitrixProductName", "Citrix Presentation Server"
$output += '{0}="{1}.{2}" ' -f "CitrixVersion", $XA5Server.WinServerObject.MFWinVerMajor, $XA5Server.WinServerObject.MFWinVerMinor
$output += '{0}="{1}" ' -f "CitrixEdition", (GetXAEdition($XA5Server.WinServerObject.MPSEdition))
$output += '{0}="{1}" ' -f "CitrixEditionString", $XA5Server.WinServerObject.MPSEdition
$output += '{0}="{1}" ' -f "CitrixServicePack", $XA5Server.WinServerObject.MFWinServicePack
$output += '{0}="{1}" ' -f "CitrixInstallDate", (ConvertMFTime($XA5Server.WinServerObject.MFInstallDate2))
$output += '{0}="{1}" ' -f "LicenseServerName", $XA5Server.WinServerObject.LicenseServerName
$output += '{0}="{1}" ' -f "LicenseServerPortNumber", $XA5Server.WinServerObject.LicenseServerPort
$output += '{0}="{1}" ' -f "LogOnsEnabled", $XA5Server.WinServerObject.EnableLogon
$output += '{0}="{1}" ' -f "IcaPortNumber", $XA5Server.WinServerObject.IcaPortNumber
$output += '{0}="{1}" ' -f "RdpPortNumber", $XA5Server.WinServerObject.RdpPortNumber
$output += '{0}="{1}" ' -f "SessionCount", $XA5Server.SessionCount
$output += '{0}="{1}" ' -f "Applicaitons", (($XA5Server.Applications | Select-Object -ExpandProperty DistinguishedName) -join ";")

$output += '{0}="{1}" ' -f "FarmName",$FarmName
$output += '{0}="{1}"' -f "ScriptRunTime",$ScriptRunTime

Write-Host ("{0:MM/dd/yyyy HH:mm:ss} GMT - {1}" -f ((Get-Date).ToUniversalTime()), $output)