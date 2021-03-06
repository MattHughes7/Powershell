#SaaS Host File Looker
#Make a big window and give really cool name
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
$pswindow.windowtitle = "SuperChecker 2000 V0.9" #See... Really Cool Name
#Change Background Colour
$HOST.UI.RawUI.BackgroundColor = "Black"
#Count Stuff
$CountSiteUp = 0
$CountSiteDown = 0
$CountHostLooping = 0
$CountHostNotLooping = 0
$CountHostMissingEntry = 0

#Silence Erros 
$ErrorActionPreference = "SilentlyContinue" #Me too Powershell... Me too

# Import the ActiveDirectory module
Import-Module ActiveDirectory

#Import Get-IPAddress
#. N:\Scripts\Librarys\get.ipaddress.ps1 #Delete This Line

cls

#Static Details... so Far
$RandomFirst = "Temp" + (Get-Random -Minimum 100000 -Maximum 999999) + "\" #Creates a name for a random temp folder... Why you ask? Why not.. 
$FileDestination = "\\afox01\NOC SHARE\Scripts\Dump\" + $RandomFirst
$AllItemsInLocalDump = $FileDestination + "*"

New-Item $FileDestination -type directory #Creates the temp directory
CLS

# Aim Your Laser (Target Hosts)
$Targets = (Read-Host "Enter Web Farm Name")   #Select your servers
$URL = (Read-Host "Enter Web Site w/o http*")  #Enter the URL you are checking


cls

# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} | Where-Object {$_.DNSHostName -notlike "*-Test.TOR01.desire2learn.d2l"} | ForEach-Object {$_.DNSHostName}


#Display Targets
Write-Host @"
"@
foreach ($Targets in $ADFarmTargets) {
Write-Host $Targets -BackgroundColor DarkBlue -ForegroundColor Green
}
Write-Host @"
"@
foreach ($Targets in $ADFarmTargets) {
$WebServerCount++
}
Write-Host "A Total of"  $WebServerCount "Server(s) Have Been Targeted." -BackgroundColor DarkBlue -ForegroundColor Green
Write-Host @"
"@
Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
cls

Write-Host @"
"@

Write-Host Started Checking Targets Hosts File $URL -ForegroundColor Green
Write-Host @"
"@

#Compares the Hosts files for each COMP vs that COMPS IP Addresses
foreach ($Targets in $ADFarmTargets) {

$HostFile = "\c$\Windows\System32\drivers\etc\hosts"
$LocalSystemHostFile = "\\afox01\c$\Windows\System32\drivers\etc\hosts"
$RemoteHostTextFileName = $Targets + 'HOST' + '.txt'
$RemoteHostFileOnLocalPath = $FileDestination + $RemoteHostTextFileName
$RemoteHostTextFilePath = '\\' + $Targets + $HostFile

copy $RemoteHostTextFilePath $RemoteHostFileOnLocalPath #Copy Host File to Local.. Much Faster then getting content on remote. 

$TargetIPMatch = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $Targets | ForEach-Object {$_.IPAddress} #Collected all the COMPS IPs
$UrlMatch = "*" + $URL + "*"
$TextMatchPattren = Get-Content $RemoteHostTextFilePath | select-string -Pattern $URL | ForEach-Object {$_.Line} #Gets all the lines from HOSTS that matches the URL

#Parse IP Address 
$IPpos = $TextMatchPattren.IndexOf("`t") #Parse IP Address. Note it is looking for tabs.. Like hosts should be.. not spaces... tabs. not five spaces... tabs
$LeftPartOfHostEntry = $TextMatchPattren.Substring(0, $IPpos) #Parse IP Address 
$TextMatchPattrenLength = $TextMatchPattren.length

#Parse URL From Host Files
$HostUrlpos = $TextMatchPattren.IndexOf("`t") #Parse IP Address. Note it is looking for tabs.. Like hosts should be.. not spaces... tabs. not five spaces... tabs
$RightPartOfHostEntry = $TextMatchPattren.Substring($HostUrlPos, $TextMatchPattrenLength) #Parse Hostname
Write-Host $RightPartOfHostEntry

#Parse Comp From FQND
$CompPos = $Targets.IndexOf(".") #Parse CompName
$TargetCompName = $Targets.Substring(0, $CompPos) #CompName

#Looks for matches in three steps
IF ($TargetIPMatch -like $LeftPartOfHostEntry -and $TextMatchPattren -like $URLMatch ){
Write-Host $TargetCompName Looping $TargetCompName -ForegroundColor Green

Write-Host $RightPartOfHostEntry

$CountLooping++}

ElseIf ($TextMatchPattren -notlike $TargetIPMatch -and $TextMatchPattren -like $UrlMatch ){

$TextMatchPattrenLength = $TextMatchPattren.length

$HostNameFromIP = [System.Net.Dns]::GetHostEntry($LeftPartOfHostEntry) | ForEach-Object {$_.HostName} #Tries to resolve a hostname. BUT your DNS is setup poorly. So Rarely works.. 
Write-Host $TargetCompName Pointing to $HostNameFromIP -ForegroundColor Yellow

Write-Host $RightPartOfHostEntry

$CountNotLooping++}

ElseIf ($TextMatchPattren -notlike $URLMatch){
Write-Host $TargetCompName Host Entry Missing $URL -ForegroundColor RED

Write-Host $RightPartOfHostEntry

$CountHostEntryMissing++}


Else {Write-Host "EpicFail Something is Wrong!" -ForegroundColor red}

}

#Ta Da. Shows results
Write-Host @"
"@
Write-Host Servers Targeted $WebServerCount -ForegroundColor Blue
Write-Host Hosts Entries Looping $CountLooping -ForegroundColor Green
Write-Host Hosts Entries Pointing Elsewhere $CountNotLooping -ForegroundColor Yellow
Write-Host Hosts Entries Missing $CountHostEntryMissing -ForegroundColor Red

Write-Host @"
"@