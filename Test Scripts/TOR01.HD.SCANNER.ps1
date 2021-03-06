
[Uri]$Targets = (Get-Content "n:\Scripts\Librarys\TOR01.PS.Targets.txt")
$StartTime = Get-Date

ForEach ($Targets in $Targets){

Get-WmiObject Win32_LogicalDisk -filter "DriveType=3" -ComputerName $Targets |
		Where-Object {$_.DeviceID -ne "P:"} | Select-Object SystemName,DeviceID,@{Name="Size(GB)";Expression={"{0:N1}" -f($_.size/1gb)}},@{Name="FreeSpace(GB)";Expression={"{0:N1}" -f($_.freespace/1gb)}},@{Name="PerFree(%)";Expression={"{0:N0}" -f($_.freespace / $_.size * 100)}} |
		Sort-Object SystemName | Format-Table | Out-File -Append N:\Scripts\Dump\TOR01.DriveSpace.Scan.Txt
		$ScanCount++		}
		
$EndTime = (Get-Date)	
$TimeDiff = ($EndTime - $StartTime).TotalMinutes 
$ScansPerMin = ($ScanCount / $TimeDiff)
Write-Host $TimeDiff Minutes $ScanCount Scans "@" $ScansPerMin
		
	
