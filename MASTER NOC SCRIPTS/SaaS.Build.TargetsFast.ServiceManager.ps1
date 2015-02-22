$Targets = (Get-Content c:\Disk.txt)

#$Targets = "afox01"

ForEach ($Targets in $Targets){

Write-Host Testing $Targets -ForegroundColor Green
#$TestResults = (test-path ("\\" + $Targets + "\c$")) 
Test-Connection -ComputerName $Targets -Count 1 -AsJob

#Wait-Job *
$TestResults = Receive-Job *

Write-Host $TestResults.Address -ForegroundColor Green

#ELSE {
#IF ($TestResults -eq "AFOX01"){

Add-Content c:\diskgood11.txt $TestResults.address

}
#}

Wait-Job *
Remove-Job *