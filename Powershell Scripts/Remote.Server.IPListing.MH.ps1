
$Server = Read-Host "Enter Server Name"
$TempFile = "c:\temp.txt"
 
$colItems = GWMI -cl "Win32_NetworkAdapterConfiguration" -name "root\CimV2" `
-comp $Server -filter "IpEnabled = TRUE"
 
ForEach ($objItem in $colItems)
{Write-Host "Server Name: " $Server
[String]$RemoteIP =  $objItem.IpAddress

##Unlock if you just want to see on screen## $RemoteIP.split(" ")


Add-Content $TempFile $RemoteIP.split(" ")
Invoke-Item $TempFile 
Sleep 5
Remove-Item $TempFile -Force

}

