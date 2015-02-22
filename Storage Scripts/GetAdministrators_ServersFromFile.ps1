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

#get the servers from a text file
$Servers = Get-Content C:\ServerList.txt

Clear

#loop through all the AD servers
foreach ($server in $Servers)
{
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