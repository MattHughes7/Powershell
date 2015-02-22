#Clear the screen
Clear

#Bell variable settings
$VIServer = "T1VCS01"
$Cluster = "T1ESX_Cluster"
$CanonicalMask = "naa.*4600*"

#Verizon variable settings
#$VIServer = "HFVCS01"
#$Cluster = "Verizon Cluster"
#$CanonicalMask = "naa.*7100*"

#Verizon Intel variable settings
#$VIServer = "HFVCS02"
#$Cluster = "Intel Cluster"
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
	#Get the list of LUNs on this ESX Host that match our qualifier (AMS LUNs)
    $LUNs = $ESXHost | Get-ScsiLun -LunType "disk" -CanonicalName $CanonicalMask
    #Loop through the LUNs
    foreach ($LUN in $LUNs)
    {
    	#Make sure the LUN is not local (we only want SAN style disks, not DAS)
        if (!$LUN.IsLocal)
        {
			if ($LUN.MultipathPolicy -ne "RoundRobin")
			{
        		
				#Set the LUN multipath policy to Round Robin
           		#Write-Host ($LUN.VMHost.Name + "`t" + $LUN.CanonicalName + "`tNot Round Robin")
           		#Set-ScsiLun -ScsiLun $LUN -MultipathPolicy RoundRobin
           		#Sleep for 2 seconds between each change
           		#Start-Sleep -Seconds 2
			}
			else { Write-Host ($LUN.VMHost.Name + "`t" + $LUN.CanonicalName + "`tAlready Round Robin") }
		}
	}
} 