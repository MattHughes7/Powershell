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

#get the servers from AD
$servers = New-Object System.Collections.ArrayList
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
foreach ($objResult in $colResults) {$objItem = $objResult.Properties; $objItem.name; $servers.add($objItem.name)}

#$servers = @(
#	"T1Web103A"
#)

Clear
#loop through all the computer objects
foreach ($server in $servers)
{
	#store the computer name in a string
	[string]$serverName = $server.Item(0)
	#check if the server is alive (ping)
	if (isServerAlive($serverName))
	{
		#run the psgetsid command on the remote host
		$results = & 'C:\PsGetsid.exe' \\$serverName 2> $null
		#make sure we have valid results back
		if ($results -is [System.Array]) 
		{
			$string1 = $results[1]
			$string2 = $results[2]
			#make sure we got back what we expected
			if ($string1.Contains("SID for"))
			{
				#output the results
				Write-Host ($string1.Substring(10, $string1.Length - 11) + "," + $string2)
			}
			#invalid results
			else
			{
				Write-Host ($serverName + ",Invalid results.")
			}
		}
		#couldn't run the psgetsid command
		else
		{
			Write-Host ($serverName + ",Failed to run PSGetSID.")
		}
	}
	#ping failed
	else
	{
		Write-Host ($serverName + ",PING fail.")
	}
}