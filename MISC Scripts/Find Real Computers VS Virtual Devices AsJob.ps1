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
$pswindow.windowtitle = "Find Real Computers... None of the VM Stuff"
$ErrorActionPreference = "SilentlyContinue"

$TempWorkFile = "\\afox01\NOC SHARE\Scripts\Dump\Adams\TempWorkFile" + (Get-Random -Minimum 111 -Maximum 9999) + ".txt"
$TempWorkFile1 = "\\afox01\NOC SHARE\Scripts\Dump\Adams\TempWorkFileRealComp" + (Get-Random -Minimum 111 -Maximum 9999) + ".txt"

Import-Module ActiveDirectory

$TargetsDirty = (Read-Host "Enter Web Farm Name")

Write-Host "Sets Stopped Shib to Manual Startup" -BackgroundColor Blue -ForegroundColor Green
$OpenTime = Get-Date
Write-Host Started On $OpenTime -ForegroundColor Green -BackgroundColor Blue

# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
$ADFarmTargetsDirty = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $TargetsDirty} | Where-Object {$_.DNSHostName -notlike "*-Test*" -and $_.DNSHostName -notlike "*scom*"} | ForEach-Object {$_.DNSHostName}

foreach ($TargetsDirty in $ADFarmTargetsDirty){
Write-Host Testing $TargetsDirty -ForegroundColor Blue
IF ((isServerAlive($TargetsDirty)) -eq $true){Add-Content $TempWorkFile $TargetsDirty
Write-Host $TargetsDirty is Alive -ForegroundColor Green}
ELSE{Write-Host $TargetsDirty is Dead -ForegroundColor Red}}
$Targets = (Get-Content $TempWorkFile)
$ADFarmTargets = $Targets
Write-Host @"
"@

foreach($Targets in $Targets){
Invoke-Command -computername $Targets -AsJob {
$HostName = hostname
$AdapterDisc = Get-WmiObject win32_networkadapterconfiguration -Filter 'ipenabled = "true"' | select description
IF($AdapterDisc -match "vmxnet" -or $AdapterDisc -match "vmware"){Write-Host $Targets is a Virtual Server -ForegroundColor Red}
Else{Write-Host $Targets is not A Virtual Server -ForegroundColor Green
Add-Content "\\afox01\NOC SHARE\Scripts\Dump\Adams\TempWorkFileRealComp.txt" $HostName
}}

Wait-Job *
Receive-Job *
Remove-Job *





 









