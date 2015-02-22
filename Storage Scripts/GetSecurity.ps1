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

$path = "C$\Windows"
$stream = [System.IO.StreamWriter]"E:\Security.csv"

foreach ($server in $Servers)
{
	if (isServerAlive($server))
	{
		$security = Get-Acl -Path ("\\" + $server + "\" + $path) 2>$null
		foreach ($acl in $security.Access)
		{
			Write-Host ($server + ";" + $path + ";" + $acl.IdentityReference.ToString() + ";" + $acl.AccessControlType.ToString() + ";" + $acl.FileSystemRights.ToString() + ";" + $acl.InheritanceFlags.ToString() + ";" + $acl.IsInherited.ToString() + ";" + $acl.PropagationFlags.ToString() + ";" + $security.Owner.ToString())
			$stream.WriteLine($server.Item(0).ToString() + ";" + $path + ";" + $acl.IdentityReference.ToString() + ";" + $acl.AccessControlType.ToString() + ";" + $acl.FileSystemRights.ToString() + ";" + $acl.InheritanceFlags.ToString() + ";" + $acl.IsInherited.ToString() + ";" + $acl.PropagationFlags.ToString() + ";" + $security.Owner.ToString())
		}
	}
}

$stream.Close()