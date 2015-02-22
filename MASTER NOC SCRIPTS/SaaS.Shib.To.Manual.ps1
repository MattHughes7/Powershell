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
$pswindow.windowtitle = "Sets Stopped Shib to Manual Startup"

$TempWorkFile = "N:\Scripts\Dump\Adams\TempWorkFile1" + (Get-Random -Minimum 111 -Maximum 9999) + ".txt"
$TempWorkFile1 = "N:\Scripts\Dump\Adams\TempWorkFile1Shib" + (Get-Random -Minimum 111 -Maximum 9999) + ".txt"

Import-Module ActiveDirectory

$TargetsDirty = (Read-Host "Enter Web Farm Name")

Write-Host "Sets Stopped Shib to Manual Startup" -BackgroundColor Blue -ForegroundColor Green
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
Write-Host @"
"@

foreach($Targets in $Targets){
$SafeToSetManual = Get-WmiObject -Class win32_service -ComputerName $Targets | Where { $_.name -like "shibd*" } | Select { $_.state -like "Running" }
IF($SafeToSetManual -match "True"){Write-Host $Targets is Running Shib -ForegroundColor Red}
Else{Write-Host $Targets is not Running Shib -ForegroundColor Green
Add-Content $TempWorkFile1 $Targets
}
}
$Targets1 = (Get-Content $TempWorkFile1)
$Fire = $Targets1
Write-Host @"
"@
Write-Host The Shib Services are going to be set to manual on the following Targets -ForegroundColor Green -BackgroundColor Blue
Write-Host @"
"@
ForEach($Targets1 in $Targets1){Write-Host $Targets1 -ForegroundColor Red -BackgroundColor White}
Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

foreach($Targets1 in $Fire){
Set-Service -ComputerName $Targets1 shibd_Default -startuptype "manual"
Write-Host $Targets1 SHib Service Has Been Set to Manual -ForegroundColor Green}



 









