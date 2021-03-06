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
$pswindow.windowtitle = "SCOM Add 2007 Homing"

# Import the ActiveDirectory module to gain access to the AD CMDLETS.
Import-Module ActiveDirectory

# Enter the web farm to search for (ex web12*)
$Targets = (Read-Host "Enter Web Farm / Server")

cls
Write-Host "This Sciprt Add the BELLSCOM Management Group from the Agent" -BackgroundColor Blue -ForegroundColor Green

# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} | Where-Object {$_.DNSHostName -notlike "*-Test*"}| ForEach-Object {$_.DNSHostName}
Write-Host @"
"@
foreach ($Targets in $ADFarmTargets) {
Write-Host $Targets -foregroundcolor green
}

Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Write-Host @"
"@
foreach ($Targets in $ADFarmTargets)
{
Invoke-Command -ComputerName $Targets{
$HostName = hostname
Write-Host Processing $HostName	-ForegroundColor Green
$ScomAgent = New-Object -ComObject AgentConfigManager.MgmtSvcCfg
$ScomAgent.AddManagementGroup("BELLSCOM", "T1SCOMRMSSERV.TOR01.desire2learn.d2l",5723)
$ScomAgent.ReloadConfigurationMethod
Write-Host Configuration Added on $HostName -ForegroundColor Green
Sleep 4
Restart-Service -DisplayName "System Center Management"
Sleep 4
$ServiceStatus = Get-Service -DisplayName "System Center Management" | Select {$_.status}

Write-Host System Center Management Service is $ServiceStatus on $HostName -f Green
Write-Host @"
"@
}}


