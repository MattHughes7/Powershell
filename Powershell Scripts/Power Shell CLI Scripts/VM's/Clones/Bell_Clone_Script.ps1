Shutdown-VMGuest "CA1PWEB041A" -Confirm:$false 
sleep 60
set-vm "CA1PWEB041A" -totemplate -confirm:$false 
sleep 60
$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool ucs-intel-cluster -Name "CA1PWEB041B"  -Template "CA1PWEB041A" -Datastore $Datastore -OSCustomizationspec CLI_CLONE_Customize
sleep 60
Start-VM "CA1PWEB041B" -Confirm:$false 

sleep 350

set-template "CA1PWEB041A" -tovm -Confirm:$false 

Start-VM "CA1PWEB041A" -Confirm:$false 