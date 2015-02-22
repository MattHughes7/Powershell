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
$pswindow.windowtitle = "FileShare Test"

# Enter the web farm to search for (ex web12*)
#$Targets = (Read-Host "Enter Web Farm / Server")

$OpenTime = Get-Date
Write-Host Started On $OpenTime -ForegroundColor Green -BackgroundColor Blue


Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
$EntireStartTime = Get-Date #Scans Start Time

Write-Host @"
"@

###############################################

$TargetsClean = (Get-Content C:\sjsutest.txt)


Foreach ($TargetsClean in $TargetsClean){

Write-Host Starting $TargetsClean -ForegroundColor Green

Invoke-Command -ComputerName $TargetsClean {

#\\fs-sjsu\temp\Test1\

$TestShares = ("\\fs-sjsu\")

ForEach ($TestShares in $TestShares){

$TestPath = '"' + $TestShares + 'SJSU' + '"'

Write-Host Testing $TestPath -ForegroundColor Green

Net Use W: $TestPath /persistent:no /user:tor01.desire2learn.d2l\afoxcolo PASSWORD

Sleep 1

$Results = (Test-Path W:\Check-in.txt)

$HostName = hostname

$WriteToFile = $HostName + " " + $TestPath

Add-Content W:\Check-in.txt $WriteToFile

Net Use W: /Delete
Sleep 1

}}}

Clear-Content C:\Alive.txt	

$EndTime = Get-Date

Write-Host Started $OpenTime Ended $EndTime
