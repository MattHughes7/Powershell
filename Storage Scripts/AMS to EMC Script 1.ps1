add-pssnapin VMware.VimAutomation.Core

#Verizon variable settings
$VIServer = "T1VCS02"
$Cluster = "UCS-Intel-Cluster"

#Connect to an ESX Cluster
Connect-VIServer $VIServer

#Clear the screen
Clear

$Servers = @(
	"T1Web95I"
)

#Loop through the Servers
foreach ($Server in $Servers)
{
	#Get the VM object
	$VM = Get-VM -Datastore "AMS*" -Name $Server
	
	#Make sure the VM is valid
	if ($VM)
	{
		#Get the used space of the VM
		$VMUsedSpace = $VM.UsedSpaceGB
	
		#Get the list of VMAX Datastores
		$Datastores = Get-Datastore -Name "vmax*"

		$FreeSpace = -1
		$Datastore = $null
		#Get the best Datastore to migrate to (the one with the most space)
		foreach ($DS in $Datastores)
		{
			#Check to see if this Datastore is better than the last one
			if ($DS.FreeSpaceGB -gt $FreeSpace) 
			{ 
				#Save this Datastore
				$Datastore = $DS 
				$FreeSpace = $DS.FreeSpaceGB
			}
		}

		#Check to make sure we have a valid Datastore
		if ($Datastore)
		{
			#Make sure this Datastore will have 300GB after migration
			if ($Datastore.FreeSpaceGB - $VM.UsedSpaceGB -ge 300)
			{
				Write-Host ("Migrating " + $VM.Name + " to " + $Datastore.Name + "(" + ($Datastore.FreeSpaceGB - $VM.UsedSpaceGB) + "GB remaining).")
				#Migrate the VM
				Move-VM -Datastore $Datastore -VM $VM
			}	
			#not enough space, get out
			else { }
		}
	}
}
