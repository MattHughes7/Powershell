add-pssnapin VMware.VimAutomation.Core

function getNewSource([System.Array]$Datastores, [System.Double]$ThresholdLow, [System.Double]$ThresholdHigh)
{
	$Datastore = $null
	#Get the Datastore nearest capacity
	foreach ($DatastoreTemp in $Datastores)
	{
		if (!$Datastore -and $DatastoreTemp.FreeSpaceGB -gt $ThresholdLow -and $DatastoreTemp.FreeSpaceGB -lt $ThresholdHigh) { $Datastore = $DatastoreTemp }
		elseif ($Datastore.FreeSpaceGB -gt $DatastoreTemp.FreeSpaceGB -and $DatastoreTemp.FreeSpaceGB -gt $ThresholdLow -and $DatastoreTemp.FreeSpaceGB -lt $ThresholdHigh) { $Datastore = $DatastoreTemp }
	}
	return $Datastore
}

function getNewDestination([System.Array]$Datastores, [System.Double]$Threshold)
{
	$Datastore = $null
	#Get the Datastore with the most space
	foreach ($DatastoreTemp in $Datastores)
	{
		if (!$Datastore -and $DatastoreTemp.FreeSpaceGB -lt $Threshold) { $Datastore = $DatastoreTemp }
		elseif ($Datastore.FreeSpaceGB -lt $DatastoreTemp.FreeSpaceGB -and $DatastoreTemp.FreeSpaceGB -lt $Threshold) { $Datastore = $DatastoreTemp }
	}
	return $Datastore
}

function getSmallestVM($Datastore, $Threshold)
{
	$VMs = Get-VM -Datastore $Datastore
	$VM = $null
	#Get the VM that has the smallest footprint
	foreach ($VMTemp in $VMs)
	{
		if (!$VM -and $VMTemp.UsedSpaceGB -gt $Threshold) { $VM = $VMTemp }
		elseif ($VMTemp.UsedSpaceGB -lt $VM.UsedSpaceGB -and $VMTemp.UsedSpaceGB -gt $Threshold) { $VM = $VMTemp }
	}
	return $VM
}

#Verizon variable settings
$VIServer = "HFVCS01"
$Cluster = "Verizon Cluster"

#Bell variable settings
#$VIServer = "T1VCS01"
#$Cluster = "T1ESX_Cluster"

#Connect to an ESX Cluster
Connect-VIServer $VIServer

#Clear the screen
Clear

$DSLowerLimit = 0
$DSUpperLimit = 10000
$VMLowerLimit = 0

do
{
	#If we're not looking for a new VM, get the Datastores
	if ($VMLowerLimit -eq 0)
	{
		#Get all AMS Datastores
		$Datastores = Get-Datastore -Name "AMS_Datastore*"
		#Get the Source and Destination Datastores
		$DatastoreSource = getNewSource $Datastores $DSLowerLimit $DSUpperLimit
		$DatastoreDestination = getNewDestination $Datastores $DSUpperLimit
	}

	#Make sure the Datastores are valid
	if ($DatastoreSource -and $DatastoreDestination)
	{
		#Get the smallest VM on the Source or the next smallest if we're looking for a new VM
		$VM = getSmallestVM $DatastoreSource $VMLowerLimit
		#Make sure we have a legit VM
		if ($VM)
		{
			#Check to see if the migration would make sense
			if (($DatastoreSource.FreeSpaceGB + $VM.UsedSpaceGB) -lt ($DatastoreDestination.FreeSpaceGB - $VM.UsedSpaceGB) -and $DatastoreDestination.FreeSpaceGB - $VM.UsedSpaceGB -gt 100)
			{
				Write-Host ("Would migrate " + $VM.Name + " from " + $DatastoreSource.Name + " to " + $DatastoreDestination.Name)
				Move-VM -VM $VM -Datastore $DatastoreDestination
				#If we failed get a new VM, else repeat the process
				if (!$?) { $VMLowerLimit = $VM.UsedSpaceGB } else { $VMLowerLimit = 0 }
			}
			#The migration wouldn't make sense, get a new Source Datastore
			else
			{
				Write-Host ("Skipping migration of " + $VM.Name + " from " + $DatastoreSource.Name + " to " + $DatastoreDestination.Name)
				$VMLowerLimit = 0
				$DSLowerLimit = $DatastoreSource.FreeSpaceGB
			}
		}
		#Didn't get a legit VM, we need a new Source Datastore
		else
		{
			$VMLowerLimit = 0
			$DSLowerLimit = $DatastoreSource.FreeSpaceGB
		}
	}
} until (!$DatastoreSource)