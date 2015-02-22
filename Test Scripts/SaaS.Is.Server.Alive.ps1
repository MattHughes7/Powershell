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
    If ($responds) { return $true } else { return $false }
}


# Import the ActiveDirectory module to gain access to the AD CMDLETS.
Import-Module ActiveDirectory

# Enter the web farm to search for (ex web12*)
$Targets = (Read-Host "Enter Web Farm / Server")

$OpenTime = Get-Date
Write-Host Started On $OpenTime -ForegroundColor Green -BackgroundColor Blue

# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} | Where-Object {$_.DNSHostName -notlike "*-Test*"} | ForEach-Object {$_.DNSHostName}
Write-Host @"
"@
foreach ($Targets in $ADFarmTargets) {Write-Host $Targets -foregroundcolor green
$ServerCount++}

Write-Host @"
"@

FOREACH($Targets in $ADFarmTargets){
IF (isServerAlive($Targets) -eq true){
Add-Content C:\D2LNOC\D2LStorageTargets.txt $Targets
Write-Host $Targets is alive -ForegroundColor Green
}
ELSE{Write-Host $Targets is Dead -ForegroundColor Red}}
