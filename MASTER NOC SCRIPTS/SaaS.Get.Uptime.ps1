
#GET TARGETS
Import-Module ActiveDirectory
$Targets = (Read-Host "Enter Web Farm / Server")
$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} | Where-Object {$_.DNSHostName -notlike "*-Test*"} | ForEach-Object {$_.DNSHostName}

Write-Host @"
"@

foreach ($Targets in $ADFarmTargets) {Write-Host $Targets -foregroundcolor green
$ServerCount++}

Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
$EntireStartTime = Get-Date #Scans Start Time

Write-Host @"
"@

$AliveServers = "c:\AliveServersUptime.txt"

function isServerAlive([string]$serverName)
{       
$results = Get-WMIObject -query "select StatusCode from Win32_PingStatus where Address = '$serverName'"
       $responds = $false   
       foreach ($result in $results) {
              if ($result.statuscode -eq 0) {
             $responds = $true
              break				
              }
       }
    If ($responds) { return $true } else { return $false }}

FOREACH($Targets in $ADFarmTargets){

IF (isServerAlive($Targets) -eq true){

Add-Content $AliveServers $Targets
Write-Host $Targets is alive -ForegroundColor Green }

ELSE{}}

$CleanTargets = Get-Content $AliveServers

FOREACH ($CleanTargets in $CleanTargets){

$LastBoot = (Get-WmiObject -Class Win32_OperatingSystem `
        -computername $CleanTargets).LastBootUpTime
		Write-Host $LastBoot

$HostName = $CleanTargets

$WriteString = $hostname + ", " + $LastBoot

Add-Content c:\BellUptime.Txt $WriteString}

$ServerUptime.Clear 

Remove-Item $AliveServers



