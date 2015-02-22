$ou = [ADSI]”LDAP://CN=Computers,DC=TOR01,DC=desire2learn,DC=d2l”
$computers = $ou.PSBase.Get_Children()
$arrInfo = @()
foreach($node in $computers) {
$arrInfo += Get-WmiObject -query “Select `
Name,Manufacturer,Model, `
NumberOfProcessors, `
TotalPhysicalMemory `
From Win32_ComputerSystem” `
-computername $node.Name
}
$arrInfo | format-table Name, Manufacturer, `
Model, NumberOfProcessors, TotalPhysicalMemory