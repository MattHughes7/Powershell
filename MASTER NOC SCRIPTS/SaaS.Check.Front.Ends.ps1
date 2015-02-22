##### YOU MUST CHANGE THE PASSWORD AND CREDS ON LINE 113 TO MATCH YOURS. REMOVE THEM AFTERWARDS. #####

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
$pswindow.windowtitle = "Massive Front Page Checker"

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

Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
$EntireStartTime = Get-Date #Scans Start Time

Write-Host @"
"@

$AliveServers = ("C:\AliveMassiveTest.txt")

If ((Test-Path $AliveServers) -eq $true){Clear-Content $AliveServers}
ELSE{}


FOREACH($Targets in $ADFarmTargets){
IF (isServerAlive($Targets) -eq true){

$AliveServers = ("C:\AliveMassiveTest.txt")

Add-Content c:\FML\alive.txt $Targets

Write-Host $Targets is alive -ForegroundColor Green
}
ELSE{Write-Host $Targets is Dead -ForegroundColor Red}}

$Targets.Clear

$CleanTargets = Get-Content $AliveServers

###############################################

Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
########### BEGIN THE TESTING ##########

