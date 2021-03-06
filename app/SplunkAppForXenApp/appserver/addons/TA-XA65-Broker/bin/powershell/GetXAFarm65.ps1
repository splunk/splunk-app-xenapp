$snapins  = Get-PSSnapin Citrix.XenApp.Commands -ea 0

if ($snapins -eq $null)
{
   Get-PSSnapin -Registered "Citrix.XenApp.Commands" | Add-PSSnapin
}

$i = 0

$Users   = Get-XASession | where-object{ ($_.state -ne "Listening") -and ($_.Protocol -ne "console") } | 
                           foreach-object { $i++ ; $_ } | 
                           where-object{ $_.AccountName } | 
                           group-object -Property AccountName | 
                           measure-object | select -ExpandProperty count
                            
$Servers = Get-XAServer  | measure-object | select -ExpandProperty count

$ScriptRunTime = (get-date).ToFileTime()

Get-XAFarm | foreach-object {

    $Farm = $_
	if($Farm)
	{
		$output = $Farm | Get-Member -MemberType Properties | where-object{ $_.Name -ne "SessionCount" } | foreach-object {
			$Key = $_.Name
			$Value = $Farm.$Key -join ";" 
			'{0}="{1}"' -f $Key,$Value
		}
		
		$output += '{0}="{1}"' -f "Users",$Users
        $output += '{0}="{1}"' -f "SessionCount",$i
		$output += '{0}="{1}"' -f "Servers",$Servers
        $output += '{0}="{1}"' -f "ScriptRunTime",$ScriptRunTime
		
		Write-Host ("{0:MM/dd/yyyy HH:mm:ss} GMT - {1}" -f ((get-date).ToUniversalTime()),( $output -join " " ))
	}
} 