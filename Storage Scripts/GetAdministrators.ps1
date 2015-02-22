#function to test if a server is alive
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

#loop through all the AD servers
foreach ($server in $Servers)
{
	#get just the server name (removing the AD object portions)
	$server = $server.Item(0)
	#see if we can ping the server
	if (isServerAlive $server)
	{
		#get the users from the remote server
		$admins = Gwmi Win32_GroupUser -ComputerName $server
		#strip out everything except admins
		$admins = $admins |? {$_.GroupComponent –like '*"Administrators"'}
		#loop through the admin strings
		foreach ($admin in $admins)
		{
			#check if the object is a user account
			if ($admin.PartComponent.Contains("Win32_UserAccount"))
			{
				#grab the name out of the string
				$admin.PartComponent -match ".*,Name\=(.+)$" > $null
				#write to the screen
				Write-Host ($server + "," + $matches[1].Trim('"'))
			}
		}
	}
}