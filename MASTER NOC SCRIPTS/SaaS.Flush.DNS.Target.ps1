#Make a big window
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
$pswindow.windowtitle = "SaaS Web Flush DNS"

$RefreshTime = 10

# Import the ActiveDirectory module to gain access to the AD CMDLETS.
Import-Module ActiveDirectory

# Enter the web farm to search for (ex web12*)
$Targets = (Read-Host "Enter Web Farm Name")


cls

# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets } | Where-Object {$_.DNSHostName -notlike "*-Test.TOR01.desire2learn.d2l"} | ForEach-Object {$_.DNSHostName}

#Display Targets
Write-Host @"
"@
foreach ($Targets in $ADFarmTargets) {
Write-Host $Targets -foregroundcolor green
}
Write-Host @"
"@
foreach ($Targets in $ADFarmTargets) {
$WebServerCount++
}
Write-Host "A Total of"  $WebServerCount "Server(s) Have Been Targeted." -foregroundcolor Yellow

Write-Host @"
"@

Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red

$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

#### START RECYCLE #######

Write-Host STOP"!" This is designed to Flush DNS -ForegroundColor Green 

Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red

$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

ForEach($Targets in $ADFarmTargets){

Write-Host Starting $Targets Now -ForegroundColor Green -BackgroundColor Blue

Invoke-Command -ComputerName $Targets -AsJob{

#Invoke-Command -ComputerName $Targets{

ipconfig /flushdns 

}}


Write-Host Waiting On Jobs to Complete -ForegroundColor Green
Wait-Job *
Receive-Job *
Remove-Job *