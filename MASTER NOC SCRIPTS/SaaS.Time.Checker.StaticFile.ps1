#SaaS Host File Looker
#Make a big window and give really cool name
$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.buffersize
$newsize.height = 3000
$newsize.width = 120
$pswindow.buffersize = $newsize
$newsize = $pswindow.buffersize
$pswindow.buffersize = $newsize
$newsize = $pswindow.windowsize
$newsize.height = 50
$newsize.width = 120
$pswindow.windowsize = $newsize
$pshost = get-host
$pswindow = $pshost.ui.rawui
$pswindow.windowtitle = "SuperTimeChecker 2000 0.9" #See... Really Cool Name
#Change Background Colour
$HOST.UI.RawUI.BackgroundColor = "Black"
$ErrorActionPreference = "SilentlyContinue"

Import-Module ActiveDirectory

#$Targets = (Read-Host "Enter Web Farm Name")
$Targets = get-content "N:\Scripts\Dump\servers.txt"

# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
#$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} | ForEach-Object {$_.DNSHostName}
Write-Host @"
"@
 Write-Host Target Server and Target Server Time -ForegroundColor cyan  -nonewline; Write-Host " | " -ForegroundColor White -nonewline; Write-Host Local Systems Current Time -ForegroundColor Yellow -nonewline;  Write-Host " | " -ForegroundColor White -nonewline; Write-Host Time Difference Between Server and Local -ForegroundColor Green
Write-Host @"
"@

ForEach ($Targets in $Targets) {
    $time = ([WMI]'').ConvertToDateTime((gwmi win32_operatingsystem -computername $Targets).LocalDateTime)
	$nowtime = Get-Date
	$OverHeadTime = New-Object System.TimeSpan 0, 0, 0, 0, 20
	$timeDiff = ($nowtime.subtract($OverHeadTime) - $time).TotalSeconds
	[STRING] $WriteToFile =  $Targets + ',' + $time + ',' + $nowtime + ',' + $timediff 
	
Add-Content N:\Scripts\Dump\TimeDiff.csv $WriteToFile -encoding ASCII 
	
	
	If ($timeDiff -lt 3 -and $timeDiff -gt -3){
	
    Write-Host $Targets $time -ForegroundColor cyan  -nonewline; Write-Host " | " -ForegroundColor White -nonewline; Write-Host $nowtime -ForegroundColor Yellow -nonewline;  Write-Host " | " -ForegroundColor White -nonewline; Write-Host $timediff -ForegroundColor Green 
#$Targets $time -ForegroundColor cyan  -nonewline; Write-Host " | " -ForegroundColor White -nonewline; Write-Host $nowtime -ForegroundColor Yellow -nonewline;  Write-Host " | " -ForegroundColor White -nonewline; Write-Host $timediff -ForegroundColor Green




$time = $null
$timeDiff = $null
$nowtime =$null
}
Else{
Write-Host $Targets $time -ForegroundColor cyan  -nonewline; Write-Host " | " -ForegroundColor White -nonewline; Write-Host $nowtime -ForegroundColor Yellow -nonewline;  Write-Host " | " -ForegroundColor White -nonewline; write-host $timediff -ForegroundColor red	
$ServersWithDiff = @($ServersWithDiff + $Targets)
$time = $null
$timeDiff = $null
$nowtime =$null
}
}

