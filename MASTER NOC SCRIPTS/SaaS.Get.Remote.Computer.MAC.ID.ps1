Clear
 
$strComputer = ("T1WEB25J","T1WEB25K","T1WEB25L","T1WEB25M","T1WEB25N")
 
Clear
 
ForEach ($strComputer in $strComputer){

 
$colItems = GWMI -cl "Win32_NetworkAdapterConfiguration" -name "root\CimV2" `
-comp $strComputer -filter "IpEnabled = TRUE"
 
 
 
ForEach ($objItem in $colItems) 

{
Write-Host "Machine Name: " $strComputer
 
Write-Host "MAC Address: " $objItem.MacAddress

$WriteString = ($strComputer + ", " + $objItem.MacAddress) 
Add-Content c:\MacID.txt $WriteString


}}
