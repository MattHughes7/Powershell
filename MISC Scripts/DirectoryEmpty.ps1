#(Get-ChildItem C:\test -recurse | Where-Object {$_.PSIsContainer -eq $True}) | 
#Where-Object {$_.GetFiles().Count -eq 0} | Select-Object FullName

#Export-Csv C:\PSScriptstest.txt

Write-Host "Starting.... This may take a while"
(Get-ChildItem "\\Fsc01\eLO\web\pages\personal" -recurse | Where-Object {$_.PSIsContainer -eq $True}) | 
Where-Object {$_.GetFiles().Count -eq 0} | Select-Object FullName | Export-Csv "C:\PSScripts\ExportedData\FinalEmpty.txt"
Write-Host "Finished"




#(Get-ChildItem "\\Fsc06\CCCS\web\pages\personal" -recurse | Where-Object {$_.PSIsContainer -eq $True}) | 
#Where-Object {$_.GetFiles().Count -gt 0} | Select-Object FullName | Export-Csv "C:\PSScripts\ExportedData\HasFiles.txt"


