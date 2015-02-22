

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

$pswindow.windowtitle = "SaaS IIS Bindings Checker"
#Change Background Colour
$HOST.UI.RawUI.BackgroundColor = "DarkBlue"
#$ErrorActionPreference = "SilentlyContinue"
cls

$TargetsBindingAsFile = "N:\Scripts\Dump\SuperCrawlBind.txt"
$TargetsBindingAsFileFormatted = "N:\Scripts\Dump\SuperCrawlBindFormatted.txt"

$Targets = "WEB08G"
$HostsFilePathOnTargets = "\\" + $Targets + "\c$\WINDOWS\system32\drivers\etc\hosts" #Assign a Path for remote Host Files

$GetIisSettings = Get-WmiObject -ComputerName WEB08G -Namespace "root/MicrosoftIISv2" -Class  IIsWebServerSetting  -Authentication 6 #WMI Command Being Used

$GetIISSettingsURL = $GetIisSettings | Select-Object -ExpandProperty ServerBindings | Where-Object { $_.HostName -notlike $null } | Select-Object {$_.HostName},{$_.IP}| Set-Content $TargetsBindingAsFile

Get-Content $TargetsBindingAsFile | ForEach-Object {$_-replace "{$_.HostName=",""} | Set-Content $TargetsBindingAsFileFormatted

#$GetIISSettingsNameIp = ($GetIisSettings | Select-Object -ExpandProperty ServerBindings | Where-Object { $_.HostName -notlike $null } |Select-Object {$_.HostName},{$_.IP}) #Gets IP and URL

#$GetHostRemoteHostsFileLines = (Get-Content $HostsFilePathOnTargets | Select-String -Pattern $GetIISSettingsURL | ForEach-Object {$_.Line}) #Gets Remote Host Files and Stores Them as Lines

#if($GetHostRemoteHostsFileLines -like $GetIISSettingsURL){Write-Host $GetIISSettingsNameIp}


#@{$_.HostName=elearning.wmcarey.edu; $_.IP=10.1.12.33}
#@{$_.HostName=WCU.desire2learn.com; $_.IP=10.1.12.33}
					
