add-pssnapin VMware.VimAutomation.Core

#Verizon variable settings
$VIServer = "T1VCS01"
$Cluster = "T1ESX_Cluster"

#Connect to an ESX Cluster
Connect-VIServer $VIServer

#Clear the screen
Clear

$Servers = @(
"T1Web25H",
"T1Web25J",
"T1Web25M",
"T1WEB26A",
"T1WEB26F",
"T1WEB26Q",
"T1WEB26R",
"T1WEB28C",
"T1Web49C",
"T1Web58A",
"T1WEB65A",
"T1WEB75A",
"T1Web75B",
"T1WEB75C",
"T1WEB75D",
"T1WEB75E",
"T1WEB75F",
"T1Web75G",
"T1Web75H",
"T1Web75I",
"T1Web75J",
"T1Web75K",
"T1Web75L",
"T1Web75M",
"T1Web75N",
"T1Web75O",
"T1Web75P",
"T1Web75Q",
"T1Web75R",
"T1Web75S",
"T1Web78B",
"T1Web85B",
"T1Web88C",
"T1WSUS01"
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
