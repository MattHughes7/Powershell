#Clear the screen
Clear

#Bell variable settings
$VIServer = "T1VCS02"
$Cluster = "UCS-Intel-Cluster"

#Verizon variable settings
#$VIServer = "HFVCS01"
#$Cluster = "Verizon Cluster"
#$CanonicalMask = "naa.*7100*"

#Connect to an ESX Cluster
Connect-VIServer $VIServer
#Get the list of ESX Hosts from the cluster
$VMs = Get-VM
$VMs += Get-Template

#Clear the screen
Clear

#Loop through the VMs
foreach ($VM in $VMs)
{
	$View = $VM | Get-View
	foreach ($Device in $View.Config.Hardware.Device)
	{
		if (($Device.GetType()).Name -eq "VirtualDisk")
		{
			Write-Host ($VM.Name + "," + $Device.DeviceInfo.Label + "," + $Device.Backing.ThinProvisioned)
		}
	}
}