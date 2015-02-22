$Targets = (Get-Content "n:\Toolbox\kerb\allservers.txt")

FOREACH ($Targets in $Targets){

$Hostname = $Targets

$OperatingSystemGet = (Get-WmiObject -ComputerName $Targets -class Win32_OperatingSystem).Caption

$WriteSting = ($Hostname + ", " + $OperatingSystemGet)

Write-Host $WriteSting

Add-Content c:\OSver.txt $WriteSting

}


#$Test = Get-WmiObject -ComputerName afox01 -class Win32_OperatingSystem
#Write-Host $Test