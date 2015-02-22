#$Targets = (Get-Content c:\targets.txt)

$Targets = "afox01"

ForEach ($Targets in $Targets){

Write-Host Testing $Targets -ForegroundColor Green
$TestResults = (test-path ("\\" + $Targets + "\d$\Desire2Learn\mail")) 

Write-Host $TestResults -ForegroundColor Green

#ELSE {
#IF ($TestResults -eq "AFOX01"){

Add-Content c:\TargetsSchedTask.txt $TestResults.address

}
#}

Wait-Job *
Remove-Job *