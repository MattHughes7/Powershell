
New-vm -resourcepool Dell-Intel-Cluster -Name "CA2PWEB020H"  -Template "BlankTemplateQuickDeploy (GoldImage)" -Datastore vmax0928_dev443  
sleep 20
Start-VM "CA2PWEB020H" -Confirm:$false

New-vm -resourcepool Dell-Intel-Cluster -Name "CA2PWEB020I"  -Template "BlankTemplateQuickDeploy (GoldImage)" -Datastore vmax0928_dev443  
sleep 20
Start-VM "CA2PWEB020I" -Confirm:$false

New-vm -resourcepool Dell-Intel-Cluster -Name "CA2PWEB022M"  -Template "BlankTemplateQuickDeploy (GoldImage)" -Datastore vmax0928_dev443  
sleep 20
Start-VM "CA2PWEB022M" -Confirm:$false

New-vm -resourcepool Dell-Intel-Cluster -Name "CA2PWEB022N"  -Template "BlankTemplateQuickDeploy (GoldImage)" -Datastore vmax0928_dev443  
sleep 20
Start-VM "CA2PWEB022N" -Confirm:$false

New-vm -resourcepool Dell-Intel-Cluster -Name "CA2PWEB022O"  -Template "BlankTemplateQuickDeploy (GoldImage)" -Datastore vmax0928_dev443  
sleep 20
Start-VM "CA2PWEB022O" -Confirm:$false





