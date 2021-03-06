#Make a big window
$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.buffersize
$newsize.height = 3000
$newsize.width = 100
$pswindow.buffersize = $newsize
$newsize = $pswindow.buffersize
$pswindow.buffersize = $newsize
$newsize = $pswindow.windowsize
$newsize.height = 50
$newsize.width = 100
$pswindow.windowsize = $newsize
$pshost = get-host
$pswindow = $pshost.ui.rawui
$pswindow.windowtitle = "SaaS Remote Process Viewer V1.0"
$loopcount = 0

# Import the ActiveDirectory module to gain access to the AD CMDLETS.
Import-Module ActiveDirectory

# Enter the web farm to search for (ex web12*)
$Targets = (Read-Host "Enter Web Farm Name")
$RefreshTime = 2
$TotalLoops = (Read-Host "Enter the Total Amount of Refreshes (e.g. 10)")
cls

# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} | Where-Object {$_.DNSHostName -notlike "*-Test.TOR01.desire2learn.d2l"} | ForEach-Object {$_.DNSHostName}

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

cls


while ($true) {
 
Write-Host @"
"@
Write-Host "HANDLES  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     id ProcessName" -foregroundcolor RED
Write-Host "_______  ______    _____      _____ _____   ______     __ ___________" -foregroundcolor Green $loopcount 
#Simple Details
foreach ($Targets in $ADFarmTargets) {
get-process -ComputerName $Targets | Sort-Object WS -Descending | where-object {$_.WorkingSet -gt 10000000}} 
$loopcount++
Start-Sleep -s $RefreshTime


if ($Loopcount -eq $TotalLoops) {
        Write-Host "Scan Has Been Completed" -Background DarkRed -ForegroundColor White
        break;
    }}


#Start-Sleep -s $RefreshTime

    if ($Host.UI.RawUI.KeyAvailable -and ("q" -eq $Host.UI.RawUI.ReadKey("IncludeKeyUp,NoEcho").Character)) {
        Write-Host "Scan Has Been Completed" -Background DarkRed -ForegroundColor White
        break;
    }
#}