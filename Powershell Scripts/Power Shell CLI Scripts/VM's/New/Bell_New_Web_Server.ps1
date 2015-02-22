$DataStore = Get-Datastore -Name "vmax0927_*" | Sort-Object -Property FreeSpaceMb -Descending | Select -First 1

New-vm -resourcepool ucs-intel-cluster -Name "CA1PWEB025K"  -Template "GoldImage_Web_2008r2_Scripted" -Datastore $Datastore -OSCustomizationspec CLI_New_WebServer -confirm:$false 
sleep 120
Start-VM "CA1PWEB025K" -Confirm:$false 

