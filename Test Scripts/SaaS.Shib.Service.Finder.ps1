Import-Module ActiveDirectory
# Enter the web farm to search for (ex web12*)
$Targets = (Read-Host "Enter Web Farm Name")

# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} -SearchBase "OU=Web,OU=Verizon,OU=Computers,OU=TOR01,DC=TOR01,DC=desire2learn,DC=d2l" | ForEach-Object {$_.DNSHostName}
Get-Service "shib*" -ComputerName $ADFarmTargets