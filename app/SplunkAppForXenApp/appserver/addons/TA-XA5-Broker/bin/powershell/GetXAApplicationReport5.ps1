. (Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) XAFunctions.ps1)

$XA5Farm = New-Object -ComObject MetaFrameCOM.MetaFrameFarm
$XA5Farm.Initialize(1)

$FarmName = $XA5Farm.FarmName
$ScriptRunTime = (Get-Date).ToFileTime()

foreach($Application in $XA5Farm.Applications)
{
	$Application.LoadData(1)
	
    $output = '{0}="{1}" ' -f "Accounts", (($Application.Accounts2 | Select-Object -ExpandProperty AccountName) -join ";")
	$output += '{0}="{1}" ' -f "ServerNames", (($Application.WinAppObject.ServerBindings | Select-Object -ExpandProperty ServerName) -join ";")
	$output += '{0}="{1}" ' -f "FileTypes", (($Application.FileTypes2 | Select-Object -ExpandProperty name) -join ";")
	$output += '{0}="{1}" ' -f "ApplicationType", (GetMFType($Application.AppType))
	$output += '{0}="{1}" ' -f "DisplayName", $Application.BrowserName
	$output += '{0}="{1}" ' -f "Description", $Application.Description
	$output += '{0}="{1}" ' -f "FolderPath", $Application.WinAppObject.ParentFolderDN
	$output += '{0}="{1}" ' -f "BrowserName", $Application.BrowserName
	$output += '{0}="{1}" ' -f "Enabled", $Application.EnableApp
	$output += '{0}="{1}" ' -f "HideWhenDisabled", $Application.WinAppObject.HideDisabledApp
	$output += '{0}="{1}" ' -f "ContentAddress", $Application.ContentObject.ContentAddress
	$output += '{0}="{1}" ' -f "CommandLineExecutable", $Application.WinAppObject.DefaultInitProg
	$output += '{0}="{1}" ' -f "WorkingDirectory", $Application.WinAppObject.DefaultWorkDir
	$output += '{0}="{1}" ' -f "ProfileLocation", $Application.StreamedAppObject.DefaultPackageLocation
	$output += '{0}="{1}" ' -f "ProfileProgramName", $Application.StreamedAppObject.PackageProgramName
	$output += '{0}="{1}" ' -f "ProfileProgramArguments", $Application.StreamedAppObject.PackageProgramArguments
	$output += '{0}="{1}" ' -f "AnonymousConnectionsAllowed", $Application.AllowAnonymousConnections
	$output += '{0}="{1}" ' -f "ClientFolder", $Application.WinAppObject.PNFolder
	$output += '{0}="{1}" ' -f "AddToClientStartMenu", $Application.WinAppObject.AddToClientStartMenu
	$output += '{0}="{1}" ' -f "StartMenuFolder", $Application.WinAppObject.StartMenuFolder
	$output += '{0}="{1}" ' -f "AddToClientDesktop", $Application.WinAppObject.AddShortcutToClientDesktop
	
	<#
	
	The following lines deal with Access Conditions.  Here are how they are defined:
	
		0 = Allow no connections
		1 = Allow no MSAM connection, but all other connections
		2 = Allow any MSAM and no other connections
		3 = Allow any connections
		4 = Allow MSAM connections that meets any of the following filters
	#>
	
	$allowCAG = "False"
	if($Application.AccessConditionFlag -ge 2)
		{ $allowCAG = "True" }
	$output += '{0}="{1}" ' -f "ConnectionsThroughAccessGatewayAllowed", $allowCAG
	
	$allowOtherConnections = "False"
	if(($Application.AccessConditionFlag -band 1) -or ($Application.AccessConditionFlag -band 3))
		{ $allowOtherConnections = "True" }
	$output += '{0}="{1}" ' -f "OtherConnectionsAllowed", $allowOtherConnections
	
	$accessConditionsEnabled = "False"
	if($Application.AccessConditionFlag -band 4)
		{ $accessConditionsEnabled = "True" }
	$output += '{0}="{1}" ' -f "AccessSessionCoditionsEnabled", $accessConditionsEnabled

	$output += '{0}="{1}" ' -f "AccessSessionConditions", ($Application.AccessSessionConditions -join ";")
	
	# End of Access Conditions
	
	$output += '{0}="{1}" ' -f "InstanceLimit", $Application.WinAppObject.InstanceLimit
	$output += '{0}="{1}" ' -f "CpuPriorityLevel", (GetCPUPriorityLevel($Application.WinAppObject.CPUPriority))
	$output += '{0}="{1}" ' -f "AudioType", (GetAudioType($Application.WinAppObject.DefaultSoundType))
	
	$audioRequired = "False"
	if($Application.WinAppObject.PNAttributes -band 2)
		{ $audioRequired = "True" }
	$output += '{0}="{1}" ' -f "AudioRequired", $audioRequired
	
	$output += '{0}="{1}" ' -f "SslConnectionEnabled", $Application.WinAppObject.EnableSSLConnections
	$output += '{0}="{1}" ' -f "EncryptionLevel", (GetEncryptionLevel($Application.WinAppObject.DefaultEncryption))
	
	$encryptionRequired = "False"
	if($Application.WinAppObject.PNAttributes -band 4)
		{ $encryptionRequired = "True" }
	$output += '{0}="{1}" ' -f "EncryptionRequired", $encryptionRequired
	
	$output += '{0}="{1}" ' -f "WaitOnPrinterCreation", $Application.WinAppObject.WaitOnPrinterCreation
	$output += '{0}="{1}" ' -f "WindowType", (GetWindowType($Application.WinAppObject.DefaultWindowType))
	$output += '{0}="{1}" ' -f "ColorDepth", (GetColorDepth($Application.WinAppObject.DefaultWindowColor))
	
	$hideTitleBar = "False"
	if($Application.WinAppObject.MFAttributes -band 2)
		{ $hideTitleBar = "True" }
	$output += '{0}="{1}" ' -f "TitleBarHidden", $hideTitleBar
	
	$maxOnStartup = "False"
	if($Application.WinAppObject.MFAttributes -band 1)
		{ $maxOnStartup = "True" }
	$output += '{0}="{1}" ' -f "MaximizeOnStartup", $maxOnStartup
	
	$output += '{0}="{1}" ' -f "CachingOption", (GetCachingOption($Application.StreamedAppObject.CachingOption))
	$output += '{0}="{1}" ' -f "AlternateProfiles", ($Application.StreamedAppObject.AlternatePackages -join ";")
	
    $output += '{0}="{1}" ' -f "FarmName",$FarmName
    $output += '{0}="{1}" ' -f "ScriptRunTime",$ScriptRunTime
    
    Write-Host ("{0:MM/dd/yyyy HH:mm:ss} GMT - {1}" -f ((Get-Date).ToUniversalTime()),$output)

} 