
$servers = Get-Content D:\Scripts\PowerShell\bellwebservers.txt


Foreach ( $server in $servers)
{& D:\Scripts\PowerShell\copy_IIS_logs_PowerShell.ps1 ("\\" + $server + "\d$\logfiles*") ("\\Archive\IIS_Logs\" + $server) }

Foreach ( $server in $servers)
{& D:\Scripts\PowerShell\cleanup_files_PowerShell.ps1 ("\\" + $server + "\d$\logfiles*") ("\\Archive\IIS_Logs\" + $server) }
