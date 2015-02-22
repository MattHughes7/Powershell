Shutdown-VMGuest "CA1PWEB026A" -Confirm:$false 
sleep 60
set-vm "CA1PWEB026A" -totemplate -confirm:$false 
sleep 60
$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool ucs-intel-cluster -Name "CA1PWEB026H"  -Template "CA1PWEB026A" -Datastore $Datastore -OSCustomizationspec CLI_CLONE_Customize
sleep 60
Start-VM "CA1PWEB026H" -Confirm:$false 

$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool ucs-intel-cluster -Name "CA1PWEB026I"  -Template "CA1PWEB026A" -Datastore $Datastore -OSCustomizationspec CLI_CLONE_Customize
sleep 60
Start-VM "CA1PWEB026I" -Confirm:$false 

$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool ucs-intel-cluster -Name "CA1PWEB026J"  -Template "CA1PWEB026A" -Datastore $Datastore -OSCustomizationspec CLI_CLONE_Customize
sleep 60
Start-VM "CA1PWEB026J" -Confirm:$false 

$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool ucs-intel-cluster -Name "CA1PWEB026K"  -Template "CA1PWEB026A" -Datastore $Datastore -OSCustomizationspec CLI_CLONE_Customize
sleep 60
Start-VM "CA1PWEB026K" -Confirm:$false 

$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool ucs-intel-cluster -Name "CA1PWEB026L"  -Template "CA1PWEB026A" -Datastore $Datastore -OSCustomizationspec CLI_CLONE_Customize
sleep 60
Start-VM "CA1PWEB026L" -Confirm:$false 

$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool ucs-intel-cluster -Name "CA1PWEB026M"  -Template "CA1PWEB026A" -Datastore $Datastore -OSCustomizationspec CLI_CLONE_Customize
sleep 60
Start-VM "CA1PWEB026M" -Confirm:$false 

$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool ucs-intel-cluster -Name "CA1PWEB026N"  -Template "CA1PWEB026A" -Datastore $Datastore -OSCustomizationspec CLI_CLONE_Customize
sleep 60
Start-VM "CA1PWEB026N" -Confirm:$false 

$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool ucs-intel-cluster -Name "CA1PWEB026O"  -Template "CA1PWEB026A" -Datastore $Datastore -OSCustomizationspec CLI_CLONE_Customize
sleep 60
Start-VM "CA1PWEB026O" -Confirm:$false 

$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool ucs-intel-cluster -Name "CA1PWEB026P"  -Template "CA1PWEB026A" -Datastore $Datastore -OSCustomizationspec CLI_CLONE_Customize
sleep 60
Start-VM "CA1PWEB026P" -Confirm:$false 

$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool ucs-intel-cluster -Name "CA1PWEB026Q"  -Template "CA1PWEB026A" -Datastore $Datastore -OSCustomizationspec CLI_CLONE_Customize
sleep 60
Start-VM "CA1PWEB026Q" -Confirm:$false 


sleep 350

set-template "CA1PWEB026A" -tovm -Confirm:$false 

Start-VM "CA1PWEB026A" -Confirm:$false 