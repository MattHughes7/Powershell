#.NET Scanner


$Targets = (Get-Content n:\Scripts\Librarys\TOR01.PS.Targets.IIS.txt)

$ResultsTargetFile = "N:\Scripts\Dump\dotNetVersions.txt"


ForEach ($Targets in $Targets){
IF ((Test-Connection $TempTargets  -Count 1 -Quiet) -like "True" ){
Invoke-Command -ComputerName $targets {Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' | sort pschildname -des | select -fi 1 -exp pschildname | Add-Content $ResultsTargetFile ($TempTargets + (select -fi 1 -exp pschildname)) 
Write-Host $TempTargets Connection OK -ForegroundColor Green
$ScanCount++}


}}