#Server 2003 
#Get-EventLog -Logname System -ComputerName HFCRP01A -EntryType Error |Where-Object {$_.EventID -eq 123 -or $_.EventID -eq 1009 -or $_.EventID -eq 1010 -or $_.EventID -eq 1011 -or $_.EventID -eq 1074 -or $_.EventID -eq 1075 -or $_.EventID -eq 1076 -or $_.EventID -eq 1077 -or $_.EventID -eq 1078 -or $_.EventID -eq 1079 -or $_.EventID -eq 1080 -or $_.EventID -eq 1117 -or $_.EventID -eq 2262 -or $_.EventID -eq 2263} | Measure-Object -Sum Entrytype | Format-Table Count

$a = Get-Date
$EventTimeFrame = $a.AddHours(-1.5)

Write-Host As Of $EventTimeFrame -ForegroundColor Green
$ApplicationRecycles2003 = Get-EventLog -Logname System -ComputerName HFCRP01A -EntryType Warning |Where-Object {$_.EventID -eq 123 -or $_.EventID -eq 1009 -or $_.EventID -eq 1010 -or $_.EventID -eq 1011 -or $_.EventID -eq 1074 -or $_.EventID -eq 1075 -or $_.EventID -eq 1076 -or $_.EventID -eq 1077 -or $_.EventID -eq 1078 -or $_.EventID -eq 1079 -or $_.EventID -eq 1080 -or $_.EventID -eq 1117 -or $_.EventID -eq 2262 -or $_.EventID -eq 2263 -and $_.TimeGenerated -gt $EventTimeFrame} | Measure-Object -Sum Entrytype | Select Count	
Write-Host $ApplicationRecycles2003
