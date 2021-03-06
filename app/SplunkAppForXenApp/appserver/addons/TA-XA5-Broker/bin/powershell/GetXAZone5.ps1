$XA5Farm = New-Object -ComObject MetaFrameCOM.MetaFrameFarm
$XA5Farm.Initialize(1)

$FarmName = $XA5Farm.FarmName
$ScriptRunTime = (Get-Date).ToFileTime()

foreach($Zone in $XA5Farm.Zones)
{
	$output = '{0}="{1}" ' -f "ZoneName", $Zone.ZoneName
	$output += '{0}="{1}" ' -f "DataCollector", $Zone.DataCollector
    $output += '{0}="{1}" ' -f "FarmName",$FarmName
    $output += '{0}="{1}"' -f "ScriptRunTime",$ScriptRunTime
    
    Write-Host ("{0:MM/dd/yyyy HH:mm:ss} GMT - {1}" -f ((Get-Date).ToUniversalTime()),$output)

} 
