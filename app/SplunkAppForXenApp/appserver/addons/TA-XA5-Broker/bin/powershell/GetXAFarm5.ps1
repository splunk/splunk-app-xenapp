$XA5Farm = New-Object -ComObject MetaFrameCOM.MetaFrameFarm
$XA5Farm.Initialize(1)

$FarmName = $XA5Farm.FarmName
$Users = New-Object System.Collections.ArrayList

foreach ($Session in $XA5Farm.Sessions)
{
	if(!($Users -contains $Session.UserName))
	{ 
		$Users.Add($Session.UserName)
	}
}

$output = '{0}="{1}" ' -f "FarmName",$FarmName
$output += '{0}="{1}" ' -f "SessionCount",$XA5Farm.Sessions.Count
$output += '{0}="{1}" ' -f "Users", $Users.Count
$output += '{0}="{1}" ' -f "Servers",$XA5Farm.Servers.Count
$output += '{0}="{1}"' -f "Applications",$XA5Farm.Applications.Count

$ScriptRunTime = (Get-Date).ToFileTime()

Write-Host ("{0:MM/dd/yyyy HH:mm:ss} GMT - {1}" -f ((Get-Date).ToUniversalTime()), $output)