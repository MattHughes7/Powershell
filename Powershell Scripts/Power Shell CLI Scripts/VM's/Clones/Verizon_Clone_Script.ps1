Shutdown-VMGuest "CA2PWEB022I" -Confirm:$false 
sleep 60
set-vm "CA2PWEB022I" -totemplate -confirm:$false 
sleep 60

$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool Dell-Intel-Cluster -Name "CA2PWEB022J"  -Template "CA2PWEB022I" -Datastore $Datastore -OSCustomizationspec CLI_CLONE_Customize
sleep 60
Start-VM "CA2PWEB022J" -Confirm:$false 

$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool Dell-Intel-Cluster -Name "CA2PWEB022K"  -Template "CA2PWEB022I" -Datastore $Datastore -OSCustomizationspec CLI_CLONE_Customize
sleep 60
Start-VM "CA2PWEB022K" -Confirm:$false


sleep 350

set-template "CA2PWEB022I" -tovm -Confirm:$false 

Start-VM "CA2PWEB022I" -Confirm:$false 