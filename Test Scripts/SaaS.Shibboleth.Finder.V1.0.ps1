# Formats PowerShell Window #
$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.buffersize
$newsize.height = 3000
$newsize.width = 110
$pswindow.buffersize = $newsize
$newsize = $pswindow.buffersize
$pswindow.buffersize = $newsize
$newsize = $pswindow.windowsize
$newsize.height = 50
$newsize.width = 110
$pswindow.windowsize = $newsize
$pshost = get-host
$pswindow = $pshost.ui.rawui
$pswindow.windowtitle = "D2L SAAS NOC SHIBD FINDER V1.0 ." 
#Change Background Colour
$HOST.UI.RawUI.BackgroundColor = "Black"
#Count Stuff
$CountSiteUp = 0
$CountSiteDown = 0
$CountHostLooping = 0
$CountHostNotLooping = 0
$CountHostMissingEntry = 0
# Formats PowerShell Window #
$ErrorActionPreference = "SilentlyContinue" #me too Powershell... me too

$ShibdOutputDirectory = "c:\" #<-------------  Change this to alter the output directory

[STRING]$ShibdFilename = $ShibdOutputDirectory + "Shib.Finder." + (get-date -f MM.dd.yyyy) + "." + (Get-Random -Minimum 100 -Maximum 999) + ".txt" #Creates Shib File Output Name
New-Item $ShibdFilename -type file -Force #Creates the outputfile
CLS

Import-Module ActiveDirectory # Import the ActiveDirectory module. If this cannot load it must be added as a windows feature

$Targets = "T1*" #<============ Aim Your Laser (Target Hosts) Default for Bell is T1*

# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} | Where-Object {$_.DNSHostName -notlike "*-Test.TOR01.desire2learn.d2l"} | ForEach-Object {$_.DNSHostName}

$StartTime = Get-Date #Scans Start Time

#This Scans Each target and then writes "TRUE" Values to the Output file
FOREACH ($Targets in $ADFarmTargets){
$ShibService = Get-WmiObject -Class win32_service -ComputerName $Targets | Where { $_.name -like "shibd*" } | Select { $_.state -like "Running" }
$CountTargets++
IF ($ShibService -match "True"){Write-Host Shibboleth is Running on $Targets -ForegroundColor Green
Add-Content $ShibdFilename $Targets
$CountShibsOn++} 
Else {Write-Host Shibboleth is not Running on $Targets -ForegroundColor Red
$CountShibsOff++}}


#The Following has no impact on the script. Counters and Timers.
$EndTime = (Get-Date)	
$TimeDiff = ($EndTime - $StartTime).TotalMinutes 
$ScansPerMin = ($CountTargets / $TimeDiff)

Write-Host @"
"@
Write-Host Servers Targeted $CountTargets -ForegroundColor Blue
Write-Host Shibboleth is Running on $CountShibsOn -ForegroundColor Green
Write-Host Shibboleth is Not Running on $CountShibsOff -ForegroundColor Red 
Write-Host $TimeDiff Minutes at $ScansPerMin Scans Per Minute  -ForegroundColor Yellow











