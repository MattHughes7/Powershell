
$servers = get-content C:\webservers.txt
foreach ($server in $servers) {Invoke-Command -ComputerName $server {  
#Write-Host $env:COMPUTERNAME
import-module webAdministration 
Get-ChildItem -Path IIS:\Sites 

}

}


$servers = "Ca1pweb025d, ca1pweb025e" #get-content C:\webservers.txt
$session = New-PSSession $server
foreach ($server in $servers){

Invoke-Command -Session $session  {Import-Module webAdministration}

Invoke-Command -Session $session  {Get-ChildItem -Path IIS:\Sites}}