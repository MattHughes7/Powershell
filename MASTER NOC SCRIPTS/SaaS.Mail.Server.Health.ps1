###### CHANGE THE WINDOW #####

$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.buffersize
$newsize.height = 3000
$newsize.width = 100
$pswindow.buffersize = $newsize
$newsize = $pswindow.buffersize
$pswindow.buffersize = $newsize
$newsize = $pswindow.windowsize
$newsize.height = 71
$newsize.width = 100
$pswindow.windowsize = $newsize
$pshost = get-host
$pswindow = $pshost.ui.rawui
$pswindow.windowtitle = "D2L Mail Server Health Check"
$ErrorActionPreference = "SilentlyContinue" #Me too powershell... Me too
CLS

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

ForEach ($items in $CleanTargets){

Invoke-Command -ComputerName $CleanTargets {
$HostName = hostname
$MailPathPresent = (Test-Path c:\Inetpub\mailroot)

If ($MailPathPresent -eq "True"){
Write-Host $Hostname has a Mail Server -ForegroundColor Green}
ELSE{Write-Host $Hostname has a Mail Server -ForegroundColor Red}


}}
Remove-Item $AliveServers