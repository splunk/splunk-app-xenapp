$snapins  = Get-PSSnapin Citrix.XenApp.Commands -ea 0

if ($snapins -eq $null)
{
   Get-PSSnapin -Registered "Citrix.XenApp.Commands" | Add-PSSnapin
}

$FarmName = Get-XAFarm | select -ExpandProperty FarmName
$ScriptRunTime = (get-date).ToFileTime()

Get-XASession -Full -ServerName $Env:ComputerName | ?{ ($_.protocol -ne "console") -and ($_.state -ne "Listening") } | foreach-object {

    $Session = $_
    $output = $Session | Get-Member -MemberType Properties | foreach-object {
        $Key = $_.Name
        $Value = $Session.$Key -join ";" 
        '{0}="{1}"' -f $Key,$Value
    }

    $output += '{0}="{1}"' -f "UserName",($_.AccountName -replace ".*\\(.*)",'$1')
    $output += '{0}="{1}"' -f "FarmName",$FarmName
    
    if($Session.LogonTime -is [System.DateTime])
    {
        $LogonTime = $Session.LogonTime.ToFileTime()
    }
    else
    {
        $LogonTime = "NoLogonTime"
    }
    
    $output += 'SessionUID="{0}:{1}:{2}"' -f $LogOnTime,$Session.SessionId,$Session.ServerName
    $output += '{0}="{1}"' -f "ScriptRunTime",$ScriptRunTime
    
    Write-Host ("{0:MM/dd/yyyy HH:mm:ss} GMT - {1}" -f ((get-date).ToUniversalTime()),( $output -join " " ))

} 
