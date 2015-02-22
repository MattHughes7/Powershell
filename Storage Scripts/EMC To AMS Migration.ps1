add-pssnapin VMware.VimAutomation.Core

#Verizon variable settings
$VIServer = "HFVCS01"
$Cluster = "Verizon Cluster"

#Connect to an ESX Cluster
Connect-VIServer $VIServer

#Clear the screen
Clear

#Get all the VMs on the EMC Datastores
$VMs = Get-VM -Datastore "AMS*" -Name "Web*"
$VMs = Get-VM -Datastore "AMS*" -Name "Web02*"
$VMs += Get-VM -Datastore "AMS*" -Name "Web03*"

foreach ($VM in $VMs)
{
	Write-Host $VM.Name
}
break
#Loop through the VMs
foreach ($VM in $VMs)
{
	#Get the used space of the VM
	$VMUsedSpace = $VM.UsedSpaceGB
	
	#Get the list of AMS Datastores
	$Datastores = Get-Datastore -Name "EMC*"

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
		#Make sure this Datastore will have 350GB after migration
		if ($Datastore.FreeSpaceGB - $VM.UsedSpaceGB -ge 350)
		{
			Write-Host ("Migrating " + $VM.Name + " to " + $Datastore.Name + "(" + ($Datastore.FreeSpaceGB - $VM.UsedSpaceGB) + "GB remaining).")
			#Migrate the VM
			Move-VM -Datastore $Datastore -VM $VM
		}
		#not enough space, get out
		else { }
	}
}
