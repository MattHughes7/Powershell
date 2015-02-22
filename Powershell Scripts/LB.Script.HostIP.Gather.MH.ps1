$AliveServers = 'c:\webservers.Txt'
$FinishedFile = 'c:\webservers.Txt'

Clear-Content $FinishedFile -ErrorAction SilentlyContinue

Import-Module ActiveDirectory

[int]$num = 1
[int]$num = Read-host "Enter number of Server queries" -ErrorAction Stop

$ADFarmTargets = @()
1..$num | ForEach-Object {
$Targets = (Read-Host "Enter Web Farm / Server")
$ADFarmTargets += Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} | Where-Object {$_.DNSHostName -notlike "*-Test*"} | ForEach-Object {$_.DNSHostName}
}
Write-Host @"
"@

foreach ($Targets in $ADFarmTargets) {Write-Host $Targets -foregroundcolor green
$ServerCount++} 

Write-Host @"
"@

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

Get-Content $AliveServers | ForEach-Object {$_ -replace ".TOR01.Desire2Learn.D2L", ""} | Sort |  Set-Content $FinishedFile


$servers = get-content $finishedfile
foreach ($server in $servers) {
[System.Net.Dns]::GetHostAddresses("$server") | Select-Object IPaddresstostring | ForEach-Object {Write-Host $_.ipaddresstostring:80} } 



Invoke-Item $FinishedFile