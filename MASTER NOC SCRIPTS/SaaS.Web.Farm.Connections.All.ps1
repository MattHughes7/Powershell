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
$pswindow.windowtitle = "SaaS Web Farm Connection Scanner All Sites"

$RefreshTime = 10

# Import the ActiveDirectory module to gain access to the AD CMDLETS.
Import-Module ActiveDirectory

# Enter the web farm to search for (ex web12*)
$Targets = (Read-Host "Enter Web Farm Name")

$RefreshTime = (Read-Host "Enter Refresh Time In Seconds")
$TotalLoops = (Read-Host "Enter the Total Amount of Loops")
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

cls

while ($true) {
  
Write-Host "Web Server Connections Details" -foregroundcolor Green $loopcount 


foreach ($Targets in $ADFarmTargets) {
Get-WmiObject Win32_PerfFormattedData_W3SVC_WebService -ComputerName $Targets | Select-Object -Property Name , __server ,CurrentConnections,MaximumConnections,@{Name="TotalBytesReceived"; Expression ={"{0:N0}" -f ($_.TotalBytesReceived/1MB)}},@{Name="TotalBytesSent"; Expression ={"{0:N0}" -f ($_.TotalBytesSent/1MB)}}|Where-Object {$_.Name -like "*Sault*"} | Format-Table
}

$loopcount++
#Amount of Loops
if ($Loopcount -eq $TotalLoops) {
        Write-Host "Scan Has Been Completed" -Background DarkRed -ForegroundColor White
        break;
    }


Start-Sleep -s $RefreshTime
cls

    if ($Host.UI.RawUI.KeyAvailable -and ("q" -eq $Host.UI.RawUI.ReadKey("IncludeKeyUp,NoEcho").Character)) {
        Write-Host "Scan Has Been Completed" -Background DarkRed -ForegroundColor White
        break;
    }
}

