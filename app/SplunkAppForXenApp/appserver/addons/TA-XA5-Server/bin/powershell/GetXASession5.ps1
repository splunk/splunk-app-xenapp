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
	$output = '{0}="{1}" ' -f "SessionId", $Session.SessionID
	$output += '{0}="{1}" ' -f "SessionName", $Session.SessionName
	$output += '{0}="{1}" ' -f "ServerName", $Session.ServerName
	$output += '{0}="{1}" ' -f "AccountName", $Session.UserName
	$output += '{0}="{1}" ' -f "BrowserName", $Session.AppName
	$output += '{0}="{1}" ' -f "State", (GetXASessionState($Session.SessionState))
	$output += '{0}="{1}" ' -f "ClientName", $Session.ClientName
	$output += '{0}="{1}" ' -f "LogOnTime", (ConvertMFTime($Session.LogonTime))
	$output += '{0}="{1}" ' -f "Protocol", (GetProtocolType($Session.ProtocolType))
	$output += '{0}="{1}" ' -f "VirtualIP", $Session.VIPAddress
	$output += '{0}="{1}" ' -f "EncryptionLevel", $Session.ClientEncryption
	$output += '{0}="{1}" ' -f "ServerBuffers", $Session.ServerBuffers
	$output += '{0}="{1}" ' -f "ClientIPV4", $Session.ClientAddress
	$output += '{0}="{1}" ' -f "ClientBuffers", $Session.ClientBuffers
	$output += '{0}="{1}" ' -f "ClientBuildNumber", $Session.ClientBuild
	$output += '{0}="{1}" ' -f "ColorDepth", $Session.ClientColorDepth
	$output += '{0}="{1}" ' -f "ClientDirectory", $Session.ClientDirectory
	$output += '{0}="{1}" ' -f "ClientProductId", $Session.ClientProductID
	$output += '{0}="{1}" ' -f "HorizontalResolution", $Session.ClientHRes
	$output += '{0}="{1}" ' -f "VerticalResolution", $Session.ClientVRes
	$output += '{0}="{1}" ' -f "ConnectionTime", (ConvertMFTime($Session.ConnectTime(0)))
	$output += '{0}="{1}" ' -f "DisconnectTime", (ConvertMFTime($Session.DisconnectTime(0)))
	$output += '{0}="{1}" ' -f "LastInputTime", (ConvertMFTime($Session.LastInputTime(0)))
	$output += '{0}="{1}" ' -f "CurrentTime", (ConvertMFTime($Session.CurrentTime(0)))
	$output += '{0}="{1}" ' -f "ClientCacheLow", $Session.ClientCacheLowMem
	$output += '{0}="{1}" ' -f "ClientCacheTiny", $Session.ClientCacheTiny
	$output += '{0}="{1}" ' -f "ClientCacheXms", $Session.ClientCacheXms
	$output += '{0}="{1}" ' -f "ClientCacheDisk", $Session.ClientCacheDisk
	$output += '{0}="{1}" ' -f "ClientCacheSize", $Session.ClientDimCacheSize
	$output += '{0}="{1}" ' -f "ClientCacheMinBitmapSize", $Session.ClientDimBitmapMin
	
    $output += '{0}="{1}" ' -f "UserName",($Session.UserName -replace ".*\\(.*)",'$1')
    $output += '{0}="{1}" ' -f "FarmName",$FarmName
    
    $output += 'SessionUID="{0}:{1}:{2}" ' -f (ConvertMFTime($Session.LogonTime)),$Session.SessionId,$Session.ServerName
    $output += '{0}="{1}" ' -f "ScriptRunTime",$ScriptRunTime
    
    Write-Host ("{0:MM/dd/yyyy HH:mm:ss} GMT - {1}" -f ((Get-Date).ToUniversalTime()), $output )

} 
