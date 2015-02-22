$Targets = ("T1web68c","t1web68a")

ForEach($Targets in $Targets){

Write-Host Starting $Targets Now -ForegroundColor Green -BackgroundColor Blue

#Invoke-Command -ComputerName $Targets -AsJob{

Invoke-Command -ComputerName $Targets{


#cd D:\Desire2Learn\bin\Recycle
#D:\Desire2Learn\bin\Recycle\Recycle.ps1 all
Write-Host $Targets
}}


Write-Host Waiting On Jobs to Complete -ForegroundColor Green
Wait-Job *
Receive-Job *
Remove-Job *

