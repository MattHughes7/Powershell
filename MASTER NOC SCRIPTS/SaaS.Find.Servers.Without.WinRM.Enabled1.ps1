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
$pswindow.windowtitle = "ENABLE WINRM"

$TempWorkFile = "N:\Scripts\Dump\Adams\TempWorkFile1" + (Get-Random -Minimum 111 -Maximum 9999) + ".txt"

Import-Module ActiveDirectory

$TargetsDirty = (Read-Host "Enter Web Farm / Server")

Write-Host "Enables WINRM" -BackgroundColor Blue -ForegroundColor Green
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
foreach ($Targets in $ADFarmTargets) {Write-Host $Targets -foregroundcolor green -BackgroundColor Blue}
foreach ($Targets in $ADFarmTargets){
$BatPath = "\\" + $Targets + "\c$\Windows\System32\Enable.WinRM.bat"
 
Add-Content $BatPath "WinRM qc -q"
Psexec.exe -s \\$Targets cmd /c "c:\Windows\System32\Enable.WinRM.bat"
Remove-Item $BatPath
}

Write-Host DONE!!!! -ForegroundColor Green -BackgroundColor Red
Remove-Item $TempWorkFile