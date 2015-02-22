#THIS SCRIPT IS DESIGNED FOR MOHAWK RECYCLE#
Write-Host STOP"!" This is designed to Recycle Web Servers -ForegroundColor Green 

Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

$Targets = ("CA1PWEB102F","CA1PWEB102g")

ForEach($Targets in $Targets){

Write-Host Starting $Targets Now -ForegroundColor Green -BackgroundColor Blue

#Invoke-Command -ComputerName $Targets -AsJob{

Invoke-Command -ComputerName $Targets{

cd D:\Desire2Learn\bin\Recycle

D:\Desire2Learn\bin\recycle\Recycle.ps1 D2LNETAppPool3

}}


Write-Host Waiting On Jobs to Complete -ForegroundColor Green
Wait-Job *
Receive-Job *
Remove-Job *

