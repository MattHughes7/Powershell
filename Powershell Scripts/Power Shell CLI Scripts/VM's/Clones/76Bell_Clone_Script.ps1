Shutdown-VMGuest "T1Web76F" -Confirm:$false 
sleep 60
set-vm "T1Web76F" -totemplate -confirm:$false 
sleep 60
$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool ucs-intel-cluster -Name "CA1PWEB076A"  -Template "T1Web76F" -Datastore $Datastore -OSCustomizationspec CLI_CLONE_Customize
sleep 60
Start-VM "CA1PWEB076A" -Confirm:$false 

$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool ucs-intel-cluster -Name "CA1PWEB076B"  -Template "T1Web76F" -Datastore $Datastore -OSCustomizationspec CLI_CLONE_Customize
sleep 60
Start-VM "CA1PWEB076B" -Confirm:$false 

$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool ucs-intel-cluster -Name "CA1PWEB076C"  -Template "T1Web76F" -Datastore $Datastore -OSCustomizationspec CLI_CLONE_Customize
sleep 60
Start-VM "CA1PWEB076C" -Confirm:$false 

$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool ucs-intel-cluster -Name "CA1PWEB076D"  -Template "T1Web76F" -Datastore $Datastore -OSCustomizationspec CLI_CLONE_Customize
sleep 60
Start-VM "CA1PWEB076D" -Confirm:$false
sleep 350

set-template "T1Web76F" -tovm -Confirm:$false 

Start-VM "T1Web76F" -Confirm:$false 