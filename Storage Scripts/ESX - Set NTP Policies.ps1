#Clear the screen
Clear

#Connect to T1VCS01
Connect-VIServer "T1VCS01"
#Get the list of ESX Hosts from T1VCS01 in the T1ESX_Cluster cluster
$ESXHosts = Get-Cluster "T1ESX_Cluster" | Get-VMHost
$ESXHosts = $ESXHosts | Sort
#Clear the screen
Clear

#Loop through the ESX Hosts
foreach ($ESXHost in $ESXHosts)
{
	Remove-VMHostNtpServer -VMHost $ESXHost -NtpServer (Get-VMHostNtpServer -VMHost $ESXHost) -Confirm:$false
	Add-VMHostNtpServer -VMHost $ESXHost -NtpServer "ntp.tor01.desire2learn.d2l"
	$NTPPolicy = (Get-VMHostService -VMHost $ESXHost | Where-Object {$_.key -eq "ntpd"}).Policy
	if ($NTPPolicy -ne "automatic") { Set-VMHostService -HostService (Get-VMHostservice -VMHost $ESXHost | Where-Object {$_.key -eq "ntpd"}) -Policy "Automatic" }
	$FirewallRule = (Get-VMHostFirewallException -VMHost $ESXHost -Name "NTP Client").Enabled
	if (!$FirewallRule) { Get-VmhostFirewallException -VMHost $ESXHost -Name "NTP Client" | Set-VMHostFirewallException -Enabled:$true }
	Get-VmHostService -VMHost $ESXHost | Where-Object {$_.key -eq "ntpd"} | Restart-VMHostService -Confirm:$false
}

foreach ($ESXHost in $ESXHosts)
{
	$NTPServer = Get-VMHostNtpServer -VMHost $ESXHost
	$NTPStatus = (Get-VmHostService -VMHost $ESXHost | Where-Object {$_.key -eq "ntpd"}).Running
	Write-Host ($ESXHost.Name + "`t" + $NTPServer + "`t" + $NTPStatus)
	#Get-VMHost |Sort Name|Select Name, @{N=“NTPServer“;E={$_ |Get-VMHostNtpServer}}, @{N=“ServiceRunning“;E={(Get-VmHostService -VMHost $_ |Where-Object {$_.key-eq “ntpd“}).Running}}
}
