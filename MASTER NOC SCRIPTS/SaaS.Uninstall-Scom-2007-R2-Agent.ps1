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
$pswindow.windowtitle = "UnInstall SCOM 2007 R2 Agent from Server"

# Import the ActiveDirectory module to gain access to the AD CMDLETS.
Import-Module ActiveDirectory

# Enter the web farm to search for (ex web12*)
$Targets = (Read-Host "Enter Web Farm / Server")

Write-Host "This Sciprt Uninstalls The SCOM 2007 R2 Agent From a Server Or Farm" -BackgroundColor Blue -ForegroundColor Green

# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} | ForEach-Object {$_.DNSHostName}
Write-Host @"
"@
foreach ($Targets in $ADFarmTargets) {
Write-Host $Targets -foregroundcolor green
}

Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

$ActionBatPath = "\\" + $Targets

Write-Host @"
"@

FOREACH($Targets in $ADFarmTargets){

$ActionBatPath = "\\" + $Targets + "\c$\" + "REMOVESCOM2007AGENT.BAT"
Write-Host Processing $Targets -ForegroundColor Green
Add-Content $ActionBatPath "msiexec /x {25097770-2B1F-49F6-AB9D-1C708B96262A} /qn /norestart"
Invoke-Command -ComputerName $Targets {c:\REMOVESCOM2007AGENT.BAT}
Remove-Item $ActionBatPath
Write-Host SCOM 2007 R2 Agent Has Been Removed
Write-Host @"
"@
}




#msiexec /x {25097770-2B1F-49F6-AB9D-1C708B96262A} /qn /norestart


