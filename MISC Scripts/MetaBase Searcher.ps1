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

#This is the temp File Location
$TempWorkFile = "N:\Scripts\Dump\Adams\TempWorkFileWEB20" + (Get-Random -Minimum 111 -Maximum 9999) + ".txt"

Import-Module ActiveDirectory

#This is your target hosts. Use * for ... well you know why and when
$TargetsDirty = "WEB20*"

Write-Host "FindsErrors in MetaBase" -BackgroundColor Blue -ForegroundColor Green
$OpenTime = Get-Date
Write-Host Started On $OpenTime -ForegroundColor Green -BackgroundColor Blue

# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
$ADFarmTargetsDirty = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $TargetsDirty} | Where-Object {$_.DNSHostName -notlike "*-Test*" -and $_.DNSHostName -notlike "*DTC*"} | ForEach-Object {$_.DNSHostName}


#This steps finds servers that are actually alive because our AD sucks...

foreach ($TargetsDirty in $ADFarmTargetsDirty){
Write-Host Testing $TargetsDirty -ForegroundColor Blue
IF ((isServerAlive($TargetsDirty)) -eq $true){Add-Content $TempWorkFile $TargetsDirty
Write-Host $TargetsDirty is Alive -ForegroundColor Green}
ELSE{Write-Host $TargetsDirty is Dead -ForegroundColor Red}}
$Targets = (Get-Content $TempWorkFile)
$ADFarmTargets = $Targets

#Below then Action Begins
 
Write-Host @"
"@
FOREACH($Targets IN $ADFarmTargets){
Write-Host Processing $Targets -ForegroundColor Green

#This is the aciton path. It will find all files in the dir and sub-dir
#$DateToCompare = (Get-date).AddHours(-4)
#$LogPathRoot = "\\" + $Targets + "\c$\Windows\System32\inetsrv\"
$LogFiles = "\\" + $Targets + "\c$\Windows\System32\inetsrv\MetaBase.xml"
#$LogFiles = Get-ChildItem $LogPathRoot -Recurse -Force | where-object {$_.psIsContainer -eq $false} | ForEach-Object -Process {$_.FullName}
#Use string below if you are looking only at file modified within the time frame defined by $DateToCompare and add a # infront of $LogFiles above
#$LogFiles = Get-ChildItem $LogPathRoot -Recurse -Force | where-object {$_.lastwritetime –gt $DateToCompare -and $_.psIsContainer -eq $false} | ForEach-Object -Process {$_.FullName}


[STRING]$DateAsString = get-date -uformat "%Y-%m-%d"
#This is where the results get written
$ErrorLogFileName = "N:\SCOM.SCAN.FILES\"+ "IIS.LOG.ERRORS.good" + $DateAsString + "T1WEB86" + ".csv"

#Change the pattren below in $LogFileErrorString
$LogFileErrorString = (Select-String $LogFiles -pattern "FSC06")
$WriteErrorToFile = $LogFileErrorString
Add-Content $ErrorLogFileName $WriteErrorToFile}



