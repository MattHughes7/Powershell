add-pssnapin VMware.VimAutomation.Core

#Verizon variable settings
$VIServer = "T1VCS01"
$Cluster = "T1ESX_Cluster"

#Connect to an ESX Cluster
Connect-VIServer $VIServer

#Clear the screen
Clear

$Servers = @(
"T1WEB102A",
"T1WEB102B",
"T1WEB102C",
"T1WEB102D",
"T1WEB102E",
"T1WEB103A",
"T1WEB103B",
"T1WEB103C",
"T1WEB103D",
"T1WEB103E",
"T1WEB104A",
"T1WEB104B",
"T1WEB104C",
"T1WEB104D",
"T1WEB104E",
"T1WEB105A",
"T1WEB105B",
"T1WEB105C",
"T1WEB105D",
"T1WEB105E",
"T1WEB106A",
"T1WEB106B",
"T1WEB106C",
"T1WEB106D",
"T1WEB106E",
"T1WEB106F",
"T1WEB106G",
"T1WEB106H",
"T1WEB106I",
"T1WEB106J",
"T1Web16A",
"T1Web16B",
"T1Web25F"
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
