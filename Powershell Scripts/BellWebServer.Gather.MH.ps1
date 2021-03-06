
############################ SEARCH AD FOR TARGETS ##########################

$AliveServers = 'D:\Scripts\PowerShell\BellWebServers.txt'
$FinishedFile = 'D:\Scripts\PowerShell\BellWebServers.Txt'

Clear-Content $AliveServers -ErrorAction SilentlyContinue

Import-Module ActiveDirectory

$ADFarmTargets = @()
$Targets = "*"
$ADFarmTargets = Get-ADComputer -Server "172.21.2.95" -Filter {Name -like $Targets} | Where-Object {$_.DNSHostName -like "T1web*" -or $_.DNSHostName -like "CA1pweb*" -or $_.DNSHostName -like "CA1tweb*" } | ForEach-Object {$_.DNSHostName}

Write-Host @"
"@

foreach ($Targets in $ADFarmTargets) {Write-Host $Targets -foregroundcolor green
$ServerCount++}

#Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red

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

Get-Content $AliveServers | ForEach-Object {$_ -replace ".TOR01.Desire2Learn.D2L", ""} | Sort | Set-Content $FinishedFile

Invoke-Item $FinishedFile
