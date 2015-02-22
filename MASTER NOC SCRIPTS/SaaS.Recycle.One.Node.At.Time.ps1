#THIS SCRIPT IS DESIGNED FOR MOHAWK RECYCLE#
Write-Host STOP"!" This is designed to Recycle Nodes -ForegroundColor Green 

Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

$Targets = ("t1web35a")


ForEach($Targets in $Targets){
Write-Host Starting $Targets Now -ForegroundColor Green -BackgroundColor Blue

Invoke-Command -ComputerName $Targets -AsJob {


cd D:\Desire2Learn\bin\recycle\

D:\Desire2Learn\bin\recycle\Recycle.ps1 D2LNETAppPool3
D:\Desire2Learn\bin\recycle\Recycle.ps1 D2LIPRAppPool
D:\Desire2Learn\bin\recycle\Recycle.ps1 D2LIPMSAppPool


Sleep 1

}

Sleep 1


}

Wait-Job *

Receive-Job *

Write-Host Completed! -ForegroundColor Green

