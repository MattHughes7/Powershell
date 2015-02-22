$datetime = Get-Date -Format "yyyyMMddHHmmss";

# Import the ActiveDirectory module to gain access to the AD CMDLETS.
Import-Module ActiveDirectory

# Issue warning if % free disk space is less
$percentwarning = (Read-Host "What percentage of free disk space do you want to query for?(ie. 10, 15, 20)") 
$Targets = (Read-Host "Enter Web Farm Name")
# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} | ForEach-Object {$_.DNSHostName}
$Targets = $ADFarmTargets

# Get fixed drive info
	
	foreach($targets in $targets)
	{
	# Get fixed drive info
	Write-Host "Getting disk information..."
	$disks = Get-WmiObject Win32_LogicalDisk -ComputerName $Targets -Filter "DriveType = 3";
 
	foreach($disk in $disks)
	{
		$deviceID = $disk.DeviceID;
		[float]$size = $disk.Size;
		[float]$freespace = $disk.FreeSpace;
 
		$percentFree = [Math]::Round(($freespace / $size) * 100);
		$sizeGB = [Math]::Round($size / 1073741824, 2);
		$freeSpaceGB = [Math]::Round($freespace / 1073741824, 2);
 
		$colour = "Green";
		if($percentFree -lt $percentWarning)
		{
			$colour = "Red";
		}
		Write-Host -ForegroundColor $Colour "$targets $deviceID percentage free space = $percentFree %";
			}
}