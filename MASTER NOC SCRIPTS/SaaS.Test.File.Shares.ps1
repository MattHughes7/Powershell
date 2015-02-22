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
$pswindow.windowtitle = "FileShare Test"

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

#LOOOP LINES
WHILE ($loop -le 3){

foreach ($Targets in $ADFarmTargets) {Write-Host $Targets -foregroundcolor green
$ServerCount++}

Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
$EntireStartTime = Get-Date #Scans Start Time

Write-Host @"
"@

FOREACH($Targets in $ADFarmTargets){
IF (isServerAlive($Targets) -eq true){
Add-Content C:\Alive.txt $Targets
Write-Host $Targets is alive -ForegroundColor Green
}
ELSE{Write-Host $Targets is Dead -ForegroundColor Red}}


###############################################


$TargetsClean = (Get-Content C:\Alive.txt)

Foreach ($TargetsClean in $TargetsClean){

Sleep 1
Write-Host Starting On $TargetsClean

Invoke-Command -ComputerName $TargetsClean -AsJob {

$TestShares = ("\\FS-PGPROD\")

ForEach ($TestShares in $TestShares){

ipconfig /flushdns

$TestPath = '"' + $TestShares + 'pgprod\Temp\test' + '"'

Write-Host Testing $TestPath -ForegroundColor Green

sleep 3

Net Use W: $TestPath /persistent:no /user:tor01.desire2learn.d2l\afoxcolo 8849622LaraPamisfat

Sleep 3

$Results = (Test-Path W:\Check-in.txt)

$HostName = hostname

$WriteToFile = $HostName + " " + $TestPath

Add-Content W:\Check-in.txt $WriteToFile

Net Use W: /Delete

Sleep 1

}}}

Write-Host Waiting On Jobs to Complete -ForegroundColor Green
Wait-Job *
Write-Host Jobs Completed -ForegroundColor Green
Remove-Job *

#END LOOP
$loop++
}

Clear-Content C:\Alive.txt	

$EndTime = Get-Date

Write-Host Started $OpenTime Ended $EndTime


