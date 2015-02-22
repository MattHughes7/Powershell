#################################################################################################################
# This script will import data from a CSV file with the following columns: namenew,nameold,lun,source,host		#
# The script will then power off the VMs in the nameold column and delete them from disk and vCenter.			#
# Last but not least the script use the source machine to create clones using the namenew and lun information.	#
# The host information might need to be updated if this script is used outside of the Global 					#
# Training Environment.																							#
#################################################################################################################
$vms =  Import-Csv "C:\scripts\clonevms.csv"
Start-Sleep -Seconds 5
$stopvmtask = foreach ($customer in $vms) {stop-vm $customer.nameold -confirm:$false}
Start-Sleep -Seconds 50
$deletetask = foreach ($customer in $vms) {Remove-VM -VM $customer.nameold -DeletePermanently -confirm:$true -RunAsync}
Start-Sleep -Seconds 50
$cloneTask = foreach ($customer in $vms) { New-VM -Name $customer.namenew -VM (Get-VM $customer.source) -VMHost (Get-VMHost $customer.host) -Datastore (Get-Datastore $customer.lun) -RunAsync} 
