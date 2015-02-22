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

$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.buffersize
$newsize.height = 3000
$newsize.width = 177
$pswindow.buffersize = $newsize
$newsize = $pswindow.buffersize
$pswindow.buffersize = $newsize
$newsize = $pswindow.windowsize
$newsize.height = 50
$newsize.width = 177
$pswindow.windowsize = $newsize
$pshost = get-host
$pswindow = $pshost.ui.rawui
$pswindow.windowtitle = "SCANS IIS LOGS FOR ERRORS"

$TempWorkFile = "N:\Scripts\Dump\Adams\TempWorkFile1" + (Get-Random -Minimum 111 -Maximum 9999) + ".txt"

Import-Module ActiveDirectory

$TargetsDirty = (Read-Host "Enter Web Farm / Server")

Write-Host "FindsErrors in IIS Logs" -BackgroundColor Blue -ForegroundColor Green
$OpenTime = Get-Date
Write-Host Started On $OpenTime -ForegroundColor Green -BackgroundColor Blue

# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
$ADFarmTargetsDirty = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $TargetsDirty} | Where-Object {$_.DNSHostName -notlike "*-Test*" -and $_.DNSHostName -notlike "*DTC*"} | ForEach-Object {$_.DNSHostName}

foreach ($TargetsDirty in $ADFarmTargetsDirty){
Write-Host Testing $TargetsDirty -ForegroundColor Blue
IF ((isServerAlive($TargetsDirty)) -eq $true){Add-Content $TempWorkFile $TargetsDirty
Write-Host $TargetsDirty is Alive -ForegroundColor Green}
ELSE{Write-Host $TargetsDirty is Dead -ForegroundColor Red}}
$Targets = (Get-Content $TempWorkFile)
$ADFarmTargets = $Targets

#Below then Action Begins
 
#FOREACH 1 Gets the Directories
Write-Host @"
"@
FOREACH($Targets IN $ADFarmTargets){
$DateToCompare = (Get-date).AddHours(-4)
$LogPathRoot = "\\" + $Targets + "\d$\LogFiles"
$LogFiles = Get-ChildItem $LogPathRoot -Recurse -Force | where-object {$_.lastwritetime –gt $DateToCompare -and $_.psIsContainer -eq $false} | ForEach-Object -Process {$_.FullName}
}
ForEach ($LogFiles in $LogFiles){
[STRING]$DateAsString = get-date -uformat "%Y-%m-%d"
$ErrorLogFileName = "N:\SCOM.SCAN.FILES\"+ "IIS.LOG.ERRORS." + $DateAsString + ".csv"
$LogFileErrorString = (Select-String $LogFiles -pattern "Server_Too_Busy")
$WriteErrorToFile = $LogFileErrorString + ","
Add-Content $ErrorLogFileName $WriteErrorToFile}



