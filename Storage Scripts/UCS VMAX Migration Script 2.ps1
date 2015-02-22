add-pssnapin VMware.VimAutomation.Core

#Verizon variable settings
$VIServer = "T1VCS02"
$Cluster = "UCS-Intel-Cluster"

#Connect to an ESX Cluster
Connect-VIServer $VIServer

#Clear the screen
Clear

$Servers = @(
"T1DB29A",
"T1DB29B",
"T1WEB104E",
"T1WEB106A",
"CA1TWEB029B",
"CA1TWeb059A",
"T1WEB105E",
"T1WEB16F",
"T1Web59B",
"T1WEB65I",
"T1WEB65J",
"T1WEB65K",
"CA1TUTIL029A",
"CA1TWeb049A",
"T1WEB16E",
"T1WEB16D",
"CA1PWEB076F",
"CA1TMAIL029A",
"T1Web16C",
"T1WEB65D",
"T1WIN8RENE",
"T1WEB104C",
"T1WEB104D",
"T1WEB106E",
"T1WEB106F",
"T1WEB106G",
"T1WEB102C",
"T1WEB102D",
"T1WEB102E",
"T1WEB103E",
"T1WEB104A",
"T1WEB105D",
"T1WEB106H",
"T1WEB106I",
"T1WEB106J",
"T1WEB105B",
"T1WEB105C",
"T1WEB29A",
"EC2Importer"
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
