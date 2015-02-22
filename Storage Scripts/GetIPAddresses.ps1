function isServerAlive([string]$serverName)
{
	$results = Get-WMIObject -query "select StatusCode from Win32_PingStatus where Address = '$serverName'"
	$responds = $false   
	if ($serverName -eq "HFDNS02") { return $false }
	if ($serverName -eq "HFDNS01") { return $false }
	foreach ($result in $results) {
		if ($result.statuscode -eq 0) {
 	       $responds = $true
	       break
		}
	}
    If ($responds) { return $true } else { return $false }
}

Clear

#get the servers from AD
$Servers = New-Object System.Collections.ArrayList
$strFilter = "(&(objectCategory=Computer)(objectClass=Computer)(operatingSystem=*Server*))"
$objDomain = New-Object System.DirectoryServices.DirectoryEntry
$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.SearchRoot = $objDomain
$objSearcher.PageSize = 1000
$objSearcher.Filter = $strFilter
$objSearcher.SearchScope = "Subtree"
$colProplist = "name"
foreach ($i in $colPropList){$objSearcher.PropertiesToLoad.Add($i)}
$colResults = $objSearcher.FindAll()
foreach ($objResult in $colResults) {$objItem = $objResult.Properties; $objItem.name; $Servers.add($objItem.name)}

Clear

foreach ($ServerTemp in $Servers)
{
	[String]$Server = $ServerTemp.Item(0)
	Write-Host ($Server)
		if (isServerAlive $Server)
		{
			$Networks = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $Server | ? {$_.IPEnabled}
			foreach ($Network in $Networks)
			{	
				$Index = 0
				while ($Network.IPAddress[$Index])
				{
					$Index++
					$IPAddress = $Network.IpAddress[$Index]
					$SubnetMask = $Network.IPSubnet[$Index]
					$DefaultGateway = $Network.DefaultIPGateway
					if ($IPAddress) 
					{ 
						$DNSServers = $Network.DNSServerSearchOrder
						if ($DNSServers)
						{
							Write-Host $DNSServers.Count
							if ($DNSServers.Count -eq 1) 
							{ 
								$DNSServerString = $DNSServers[0] + "," 
							}
							elseif ($DNSServers.Count -gt 1) 
							{ 	
								$DNSServerString = $DNSServers[0] + "," + $DNSServers[1] 
							}
						}
						Write-Host ($Server + "," + $IPAddress + "," + $SubnetMask + "," + $DefaultGateway + "," + $DNSServerString) 
						Add-Content -Path "E:\IPAddresses.csv" -Value ($Server + "," + $IPAddress + "," + $SubnetMask + "," + $DefaultGateway + "," + $DNSServerString)
					}
				}
			}
		}
}