#Builds a cross Reference. ONLY RUN ONE A DAY AT MOST
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
$ErrorActionPreference = "SilentlyContinue"
#Clear-Content N:\Scripts\Dump\Host.to.Site.Cross.Csv   #Clears Content Collected By CSV
$RefreshTime = 10

#Check Age of File

$FileAge = Get-ChildItem n:\Scripts\Dump\Host.to.Site.Cross.Csv | Select-Object @{Name="Age";Expression={ (((Get-Date) - $_.CreationTime).Days) }}


# Import the ActiveDirectory module to gain access to the AD CMDLETS.
Import-Module ActiveDirectory

# Enter the web farm to search for (ex web12*)
Write-Host File $FileAge 
$Targets = (Read-Host "Enter Web Farm Name")
#$RefreshTime = (Read-Host "Enter Refresh Time In Seconds")
#$TotalLoops = (Read-Host "Enter the Total Amount of Loops")
$TotalLoops = 1 #For Testing
cls

# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} | ForEach-Object {$_.DNSHostName}

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


Write-Host "Web Server Connections Details" -foregroundcolor Green $loopcount 
#Simple Details
foreach ($Targets in $ADFarmTargets) {
$Sites = Get-WmiObject Win32_PerfFormattedData_W3SVC_WebService -ComputerName $Targets | Select Name | Where-Object {$_.Name -notlike "*Total*" -and $_.Name -notlike "*Default*"} | ForEach-Object {$_.Name}
$SiteOnServers = $Targets + $Sites

#Add-Content N:\Scripts\Dump\Host.to.Site.Cross.Csv $SiteOnServers
}




        Write-Host "Scan Has Been Completed" -Background DarkRed -ForegroundColor White
