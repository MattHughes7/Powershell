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
$pswindow.windowtitle = "Check for Application Pool Recycles"

$TempWorkFile = "N:\Scripts\Dump\Adams\TempWorkFile1" + (Get-Random -Minimum 111 -Maximum 9999) + ".txt"
$TempWorkFile1 = "N:\Scripts\Dump\Adams\TempWorkFile1WebServers" + (Get-Random -Minimum 111 -Maximum 9999) + ".txt"
$ErrorActionPreference = "Stop"

$TargetsDirty = $GetGroupServers

Import-Module OperationsManager
Start-OperationsManagerClientShell -ManagementServerName: "HFSCOMMS01.TOR01.desire2learn.d2l" -PersistConnection: $true -Interactive: $true;

$PrimaryMgmtServer = Get-SCOMManagementServer -Name "HFSCOMMS01.TOR01.desire2learn.d2l"
$group = Get-SCOMClassInstance | Where { $_.DisplayName -eq "D2L Data Center Web Servers"}
$MonitoringClass = Get-SCOMClass -Name "Microsoft.Windows.Computer"
$group.GetRelatedMonitoringObjects($MonitoringClass,"Recursive") | Select DisplayName | Out-File -Encoding ascii $TempWorkFile1
(Get-Content $TempWorkFile1 | Select-Object -Skip 1) | Set-Content $TempWorkFile1

$Targets = (Get-Content $TempWorkFile1)
#$Targets = (IMPORT-CSV "N:\Scripts\Dump\Adams\TempWorkFile1WebServers1716.txt")
Write-Host $TargetsDirty


Write-Host "Check for Application Pool Recycles" -BackgroundColor Blue -ForegroundColor Green
$OpenTime = Get-Date
Write-Host Started On $OpenTime -ForegroundColor Green -BackgroundColor Blue
Write-Host @"
"@
$ProcessStartTime = Get-Date

ForEach( $Targets in $Targets){
Write-Host $Targets
Invoke-Command -ComputerName $Targets -AsJob {$a = Get-Date
$HostName = Hostname
$EventTimeFrame = $a.AddHours(-720)
$ApplicationRecycles2003 = Get-EventLog -Logname System -EntryType Warning |Where-Object {$_.EventID -eq 123 -or $_.EventID -eq 1009 -or $_.EventID -eq 1010 -or $_.EventID -eq 1011 -or $_.EventID -eq 1074 -or $_.EventID -eq 1075 -or $_.EventID -eq 1076 -or $_.EventID -eq 1077 -or $_.EventID -eq 1078 -or $_.EventID -eq 1079 -or $_.EventID -eq 1080 -or $_.EventID -eq 1117 -or $_.EventID -eq 2262 -or $_.EventID -eq 2263 -and $_.TimeGenerated -gt $EventTimeFrame} | Measure-Object -Sum Entrytype | Select Count	

Write-Host $HostName $ApplicationRecycles2003
}}

Wait-Job *
Receive-Job * 

$ProcessEndTime = Get-Date
$ProcessTime = ($ProcessEndTime - $ProcessStartTime).TotalMinutes 
Write-Host @"
"@

Write-Host $ProcessTime Minutes to Complete -ForegroundColor Green 







