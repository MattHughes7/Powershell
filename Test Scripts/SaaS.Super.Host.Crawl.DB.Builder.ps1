
Import-Module ActiveDirectory
. n:\Scripts\Librarys\ColourArray.ps1
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
$newsize.width = 50
$pswindow.windowsize = $newsize
$pswindow.windowtitle = "SaaS SuperCrawl DB Builder"
#Change Background Colour
$HOST.UI.RawUI.BackgroundColor =  "Black"
$ErrorActionPreference = "SilentlyContinue"
$TempTextFile = "N:\Scripts\Dump\" + "TargetTemp" + (Get-Random (100..999)) + ".txt"
$TOR01TagetsFile	 = "N:\Scripts\Librarys\TOR01.PS.Targets.txt"
$TOR01TagetsFileWeb =  "N:\Scripts\Librarys\TOR01.PS.Targets.IIS.txt"
$Targets = "*"
$StartTime = Get-Date




Copy $TOR01TagetsFile ($TOR01TagetsFile + ".bak")
Clear-Content $TOR01TagetsFile

$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} |  Where-Object {$_.DNSHostName -notlike "*-Test.TOR01.desire2learn.d2l"} | ForEach-Object {$_.DNSHostName}
CLS

ForEach ($Targets in $ADFarmTargets){ Add-Content $TempTextFile $Targets | Sort }
$TempTargets = Get-Content $TempTextFile 
ForEach ($TempTargets in $TempTargets){
IF ((Test-Connection $TempTargets  -Count 1 -Quiet) -like "True" ){Add-Content $TOR01TagetsFile $TempTargets
Write-Host $TempTargets Connection OK -ForegroundColor Green
$ScanCount++}
ELSE {Write-Host $TempTargets Failed Connection -ForegroundColor Red
$ScanCount++}}


$PSEnabledServers = (Get-Content $TOR01TagetsFile)

Copy $TOR01TagetsFileWeb ($TOR01TagetsFileWeb + ".bak")
Clear-Content $TOR01TagetsFileWeb

ForEach($PSEnabledServers in $PSEnabledServers){$iis = get-wmiobject Win32_Service -ComputerName $PSEnabledServers -Filter "name='IISADMIN'"
IF($iis.State -eq "Running"){Add-Content $TOR01TagetsFileWeb $PSEnabledServers
Write-Host $TempTargets IIS ON -ForegroundColor Green
$ScanCount++}
ELSE{Write-Host $TempTargets IIS ON -ForegroundColor Red
$ScanCount++}
}

$EndTime = Get-Date
$TimeDiff = ($EndTime - $StartTime).TotalMinutes 
$ScansPerMin = ($ScanCount / $TimeDiff)
Write-Host $timeDiff Minutes $ScanCount Scans "@" $ScansPerMin Scans Per Minute -BackgroundColor Black -ForegroundColor Green
Del $TempTextFile


