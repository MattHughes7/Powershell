add-pssnapin VMware.VimAutomation.Core

#Verizon variable settings
$VIServer = "T1VCS02"
$Cluster = "UCS-Intel-Cluster"

#Connect to an ESX Cluster
Connect-VIServer $VIServer

#Clear the screen
Clear

$Servers = @(
"T1DB32A",
"T1DB32B",
"T1TS01",
"T1Web16B",
"CA1TWeb029A",
"T1WEB65C",
"T1WEB101A",
"T1WEB101B",
"T1WEB103A",
"CA1PWEB076E",
"T1WEB101D",
"T1WEB65E",
"CA1PWEB076G",
"CA1PWEB107C",
"CA1TLRM029A",
"T1WEB65G",
"T1WEB65H",
"CA1TWEB029C",
"T1WEB65F",
"T1WEB104F",
"T1WEB104G",
"T1VCS02",
"T1WEB102A",
"T1WEB102B",
"T1WEB103B",
"T1WEB101C",
"T1WEB104B",
"T1WEB106B",
"T1WEB106C",
"T1WEB106D",
"T1WEB101E",
"T1WEB103C",
"T1WEB103D"
)

#Loop through the Servers
foreach ($Server in $Servers)
{
	#Get the VM object
	$VM = Get-VM -Name $Server
	
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
