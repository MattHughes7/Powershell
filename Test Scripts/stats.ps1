# Import the ActiveDirectory module to gain access to the AD CMDLETS.
Import-Module ActiveDirectory

# Enter the web farm to search for (ex web12*)
$Targets = (Read-Host "Enter Host")

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
Write-Host "Running stats on"  $Targers "." -foregroundcolor Yellow
Write-Host @"
"@
Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

cls

while ($true) {
  
Write-Host $Targets "Details" -foregroundcolor Green $loopcount 


foreach($node in $targers) {
$arrInfo += Get-WmiObject -query “Select `
Name,Manufacturer,Model, `
NumberOfProcessors, `
TotalPhysicalMemory `
From Win32_ComputerSystem” `
$node.Name
}
$arrInfo | format-table Name, Manufacturer, `
Model, NumberOfProcessors, TotalPhysicalMemory

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

