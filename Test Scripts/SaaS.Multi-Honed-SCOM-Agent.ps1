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
$pswindow.windowtitle = "SCOM Multi-Agent"



# Import the ActiveDirectory module to gain access to the AD CMDLETS.
Import-Module ActiveDirectory

# Enter the web farm to search for (ex web12*)
$Targets = (Read-Host "Enter Web Farm / Server")

$ScomAgent = New-Object -ComObject AgentConfigManager.MgmtSvcCfg
cls

# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} | ForEach-Object {$_.DNSHostName}

foreach ($Targets in $ADFarmTargets) {
Write-Host $Targets -foregroundcolor green
}

Write-Host @"
"@
foreach ($Targets in $Targets) {
Invoke-Command -ComputerName $Targets{
$ScomAgent = New-Object -ComObject AgentConfigManager.MgmtSvcCfg
$ScomAgent.RemoveManagementGroup("BELLSCOM") }}
