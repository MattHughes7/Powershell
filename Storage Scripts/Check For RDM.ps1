#this function is used to determine what LUNs are RDMs
function isRDM([string]$NAAID)
{
	#if ($NAAID -eq "naa.60060e80100af4600530274e0000007e") { return 0 }
	#if ($NAAID -eq "naa.60060e80100af4600530274e0000007b") { return 1 }
	#if ($NAAID -eq "naa.60060e80100af4600530274e00000083") { return 2 }
	#if ($NAAID -eq "naa.60060e80100af4600530274e0000007d") { return 0 }
	#if ($NAAID -eq "naa.60060e80100af4600530274e0000007f") { return 1 }
	#if ($NAAID -eq "naa.60060e80100af4600530274e00000078") { return 2 }
	#if ($NAAID -eq "naa.60060e80100af4600530274e00000080") { return 0 }
	#if ($NAAID -eq "naa.60060e80100af4600530274e00000079") { return 1 }
	#if ($NAAID -eq "naa.60060e80100af4600530274e00000081") { return 2 }
	#if ($NAAID -eq "naa.60060e80100af4600530274e0000007a") { return 0 }
	#if ($NAAID -eq "naa.60060e80100af4600530274e00000082") { return 1 }
	#if ($NAAID -eq "naa.60060e80100af4600530274e0000007c") { return 2 }
	#T1SQL29A
	if ($NAAID -eq "naa.60060e80100af4600530274e0000008f") { return 0 }
	if ($NAAID -eq "naa.60060e80100af4600530274e00000089") { return 1 }
	if ($NAAID -eq "naa.60060e80100af4600530274e0000008a") { return 2 }
	if ($NAAID -eq "naa.60060e80100af4600530274e0000008b") { return 0 }
	if ($NAAID -eq "naa.60060e80100af4600530274e0000008c") { return 1 }
	if ($NAAID -eq "naa.60060e80100af4600530274e0000008d") { return 2 }
	if ($NAAID -eq "naa.60060e80100af4600530274e0000008e") { return 0 }
	#T1SQL29B
	if ($NAAID -eq "naa.60060e80100af4600530274e00000084") { return 1 }
	if ($NAAID -eq "naa.60060e80100af4600530274e00000085") { return 2 }
	if ($NAAID -eq "naa.60060e80100af4600530274e00000086") { return 0 }
	if ($NAAID -eq "naa.60060e80100af4600530274e00000087") { return 1 }
	if ($NAAID -eq "naa.60060e80100af4600530274e00000088") { return 2 }
	#not an RDM
	return -1
}

#Clear the screen
Clear

#Bell variable settings
$VIServer = "T1VCS02"
$Cluster = "UCS-Intel-Cluster"
$CanonicalMask = "naa.*4600*"

#Verizon variable settings
#$VIServer = "HFVCS01"
#$Cluster = "Verizon Cluster"
#$CanonicalMask = "naa.*7100*"

#Connect to an ESX Cluster
Connect-VIServer $VIServer
#Get the list of ESX Hosts from the cluster
$ESXHosts = Get-Cluster $Cluster | Get-VMHost

#Clear the screen
Clear

#Loop through the ESX Hosts
foreach ($ESXHost in $ESXHosts)
{
	#we want T1ESX216 or T1ESX217
	#if (($ESXHost.Name -eq "t1esx116.tor01.desire2learn.d2l") -or ($ESXHost.Name -eq "t1esx117.tor01.desire2learn.d2l"))
	#{
		#Get the list of LUNs on this ESX Host that match our qualifier (AMS LUNs)
	    $LUNs = $ESXHost | Get-ScsiLun -LunType "disk" -CanonicalName $CanonicalMask
		#Loop through the LUNs
		foreach ($LUN in $LUNs)
		{
			#Make sure the LUN is not local (we only want SAN style disks, not DAS)
			if (!$LUN.IsLocal)
			{
				#check to see if it's an RDM
				$PathIndex = isRDM($LUN.CanonicalName)
				#it is an RDM - use Fixed
				if ($PathIndex -ne -1)
				{
					$Paths = Get-ScsiLunPath -ScsiLun $LUN
					Write-Host ($LUN.VMHost.Name + "`t" + $LUN.CanonicalName + "`t" + $LUN.MultipathPolicy + "`t" + $PathIndex)
					#Set the LUN multipath policy to Round Robin
					Set-ScsiLun -ScsiLun $LUN -MultipathPolic Fixed -PreferredPath $Paths[$PathIndex]
					#Sleep for 2 seconds between each change
					Start-Sleep -Seconds 2
				}
				#it's not an RDM - use Round Robin
				else
				{
					Write-Host ($LUN.VMHost.Name + "`t" + $LUN.CanonicalName + "`t" + $LUN.MultipathPolicy)
					#Set the LUN multipath policy to Round Robin
					#Set-ScsiLun -ScsiLun $LUN -MultipathPolic RoundRobin
					#Sleep for 2 seconds between each change
					#Start-Sleep -Seconds 2
				}
			}
		}
	#}
}
