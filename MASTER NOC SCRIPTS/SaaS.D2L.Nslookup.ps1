#D2LNsLookup

$listofIPs = "10.1.7.236"

$ResultList = @() 

Clear-Content c:\output1.txt

foreach ($ip in $listofIPs) 

{ 

Write-Host Scanning $ip -ForegroundColor Green



     $result = $null
     $currentEAP = $ErrorActionPreference
     $ErrorActionPreference = "silentlycontinue"
     $result = [System.Net.Dns]::gethostentry($ip) 
     $ErrorActionPreference = $currentEAP
     If ($Result) 
     { 
          $Resultlist += "$IP - " + [string]$Result.HostName
     } 
     Else
     { 
          $Resultlist += "$IP - No HostNameFound"
     } 
} 

$resultlist | Out-File c:\output1.txt 

$ResultList