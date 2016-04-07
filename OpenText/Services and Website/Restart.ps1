Stop-WebSite -Name "Default Web Site" 
Start-WebSite -Name "Default Web Site" 
Restart-service -name OTCS
Restart-service -name OTCSadmin