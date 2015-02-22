$Targets = (Get-Content c:\Disk.txt)
#$Targets = "afox001"

ForEach ($Targets in $Targets){
$TestResults = Test-Connection -Count 1 $Targets -ErrorAction SilentlyContinue
Write-Host $TestResults.address
}