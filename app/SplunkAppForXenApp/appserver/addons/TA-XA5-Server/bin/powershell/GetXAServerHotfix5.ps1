. (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) XAFunctions.ps1)

$XA5Farm = New-Object -ComObject MetaFrameCOM.MetaFrameFarm
$XA5Server = New-Object -ComObject MetaFrameCOM.MetaFrameServer
$XA5Farm.Initialize(1)

# 6 is the enumeration value for MetaFrameWinSrvObject
$XA5Server.Initialize(6, $Env:COMPUTERNAME)

$FarmName = $XA5Farm.FarmName
$ScriptRunTime = (Get-Date).ToFileTime()

foreach($Hotfix in $XA5Server.WinServerObject.Hotfixes)
{
	$output = '{0}="{1}" ' -f "ServerName", $Server.ServerName
	$output += '{0}="{1}" ' -f "HotfixName", $Hotfix.name
	$output += '{0}="{1}" ' -f "InstalledBy", $Hotfix.InstalledBy
	$output += '{0}="{1}" ' -f "InstalledOn", (ConvertMFTime($Hotfix.InstalledOn))
	$output += '{0}="{1}" ' -f "Valid", $Hotfix.Valid
	$output += '{0}="{1}" ' -f "TargetProduct", ($Hotfix.TargetProduct).ProductName
	$output += '{0}="{1}" ' -f "HotfixType", $Hotfix.HotfixType
	$output += '{0}="{1}" ' -f "LanguageId", $Hotfix.LanguageID
	$output += '{0}="{1}" ' -f "HotfixesReplaced", (($Hotfix.HotfixesReplaced) -join ";")
	$output += '{0}="{1}" ' -f "MoreInformationAt", $Hotfix.Url

	$output += '{0}="{1}" ' -f "FarmName",$FarmName
	$output += '{0}="{1}"' -f "ScriptRunTime",$ScriptRunTime

    Write-Host ("{0:MM/dd/yyyy HH:mm:ss} GMT - {1}" -f ((Get-Date).ToUniversalTime()), $output)
}