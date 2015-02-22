$DataStore = Get-Datastore -Name "vmax0927_*" | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool Dell-AMD-Cluster -Name "CA2PWEB012A"  -Template "GoldImageWebServer(Matt Hughes Special Don't Use)" -Datastore $Datastore -OSCustomizationspec CLI_New_WebServer -confirm:$false 
sleep 30
Start-VM "CA2PWEB012A" -Confirm:$false 

$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool Dell-AMD-Cluster -Name "CA2PWEB012B"  -Template "GoldImageWebServer(Matt Hughes Special Don't Use)" -Datastore $Datastore -OSCustomizationspec CLI_New_WebServer -confirm:$false 
sleep 30
Start-VM "CA2PWEB012B" -Confirm:$false 
$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool Dell-AMD-Cluster -Name "CA2PWEB012C"  -Template "GoldImageWebServer(Matt Hughes Special Don't Use)" -Datastore $Datastore -OSCustomizationspec CLI_New_WebServer -confirm:$false 
sleep 30
Start-VM "CA2PWEB012C" -Confirm:$false 

$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool Dell-AMD-Cluster -Name "CA2PWEB012D"  -Template "GoldImageWebServer(Matt Hughes Special Don't Use)" -Datastore $Datastore -OSCustomizationspec CLI_New_WebServer -confirm:$false 
sleep 30
Start-VM "CA2PWEB012D" -Confirm:$false 


$DataStore = Get-Datastore | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool Dell-AMD-Cluster -Name "CA2PWEB012E"  -Template "GoldImageWebServer(Matt Hughes Special Don't Use)" -Datastore $Datastore -OSCustomizationspec CLI_New_WebServer -confirm:$false 
sleep 30
Start-VM "CA2PWEB012E" -Confirm:$false 




