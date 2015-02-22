# Get IE Version by Daryl Rolleman

Import-Module ActiveDirectory
$Targets = (Read-Host "Enter Web Farm Name")
$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} -SearchBase "OU=Web,OU=Verizon,OU=Computers,OU=TOR01,DC=TOR01,DC=desire2learn,DC=d2l" | Where-Object {$_.DNSHostName -notlike "*-Test.TOR01.desire2learn.d2l"} | ForEach-Object {$_.DNSHostName}

$a = Invoke-Command -ComputerName $ADFarmTargets -ScriptBlock {
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Internet Explorer' | Select-Object PSChildName,Version 
}
$a | Sort-Object -Property PSComputerName | 
Export-Csv -Path "n:\Scripts\Dump\IEVersion_Verizon.csv"
$a.count | Out-File -Append "n:\Scripts\Dump\IEVersion_Verizon.csv"
$Error | Out-File "n:\Scripts\Dump\IEVersion_Verizon_Error.txt"
$Error.Count | Out-File -Append "n:\Scripts\Dump\IEVersion_Verizon_Error.txt"