#Make a big window and give really cool name
$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.buffersize
$newsize.height = 3000
$newsize.width = 170
$pswindow.buffersize = $newsize
$newsize = $pswindow.buffersize
$pswindow.buffersize = $newsize
$newsize = $pswindow.windowsize
$newsize.height = 50
$newsize.width = 170
$pswindow.windowsize = $newsize
$pshost = get-host
$pswindow = $pshost.ui.rawui
$pswindow.windowtitle = "SaaS Who Is Logged In V1.0"
$FailCount = 0
$SuccessCount = 0
#Change Background Colour
$HOST.UI.RawUI.BackgroundColor = "DarkBlue"
#Hide Errors
#$ErrorActionPreference = "SilentlyContinue"
cls


# Import the ActiveDirectory module to gain access to the AD CMDLETS.
Import-Module ActiveDirectory

#Import Terminal Services Module
Import-Module PSTerminalServices

# Enter the web farm to search for (ex web12*)
$Targets = (Read-Host "Enter Web Farm Name ")
$SpecUser = (Read-Host "Enter Specific *UserName* or * ")


# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} |  Where-Object {$_.DNSHostName -notlike "*-Test.TOR01.desire2learn.d2l"} | ForEach-Object {$_.DNSHostName}
cls
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

foreach ($Targets in $ADFarmTargets) {

Get-TSSession -ComputerName $Targets | Where-Object {$_.SessionID -gt 0 -and $_.SessionID -lt 30 -and $_.UserName -like $SpecUser -and $_.UserName -ne $null}   

}

#Gwmi Win32_Computersystem -Computer WEB25a | Select Name, UserName

