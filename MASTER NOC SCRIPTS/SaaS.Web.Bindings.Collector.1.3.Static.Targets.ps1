
#Make a big window and give really cool name
$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.buffersize
$newsize.height = 3000
$newsize.width = 170
$pswindow.buffersize = $newsize
$newsize = $pswindow.buffersize
$pswindow.buffersize = $newsize
$newsize = $pswindow.windowsize
$newsize.height = 50
$newsize.width = 170
$pswindow.windowsize = $newsize
$pshost = get-host
$pswindow = $pshost.ui.rawui
$pswindow.windowtitle = "SaaS IIS Bindings Checker"
$FailCount = 0
$SuccessCount = 0
#Change Background Colour
$HOST.UI.RawUI.BackgroundColor = "DarkBlue"
#Hide Errors
$ErrorActionPreference = "SilentlyContinue"
cls
$TOR01TagetsFileWeb =  "N:\Scripts\Librarys\TOR01.PS.Targets.IIS.txt"

####GET SITE INFO FUNCTIONS
Function Get-SiteInfoNoSsl{

$objWMI = [WmiSearcher] "Select * From IISWebServerSetting"
$objWMI.Scope.Path = "\\" + $WebServers + "\root\microsoftiisv2" 
$objWMI.Scope.Options.Authentication = 6 
$sites = $objWMI.Get() 

$bindings = $site.psbase.properties | ? {$_.Name -contains "ServerBindings"} 
 
	foreach ($pair in $bindings.Value.GetEnumerator())
    {		$SiteBindings = $WebServers + ',' + $pair.Hostname + ',' + $pair.IP + ',' + $pair.Port  + ',' + " No Secure Biinding Port"
		$bindings = $null
		If ($Pair.Hostname = $null -or $Pair.Hostname -eq ""){}
	   Else{Write-Host $SiteBindings -ForegroundColor Red
	   Add-Content N:\Scripts\Dump\NoSslBindingsWeb1.txt $SiteBindings
	}}}
Function Get-SiteInfoSsl{

$objWMI = [WmiSearcher] "Select * From IISWebServerSetting"
$objWMI.Scope.Path = "\\" + $WebServers + "\root\microsoftiisv2" 
$objWMI.Scope.Options.Authentication = 6 
$sites = $objWMI.Get() 

$bindings = $site.psbase.properties | ? {$_.Name -contains "ServerBindings"} 
 
	foreach ($pair in $bindings.Value.GetEnumerator())
    {		$SslSiteBindings = $WebServers + ',' + $pair.Hostname + ',' + $pair.IP + ',' + $pair.Port  + ',' + " Uses Secure Biinding Port"
		$bindings = $null
		If ($Pair.Hostname = $null -or $Pair.Hostname -eq ""){}
	   Else{Write-Host $SslSiteBindings -ForegroundColor Green
	     Add-Content N:\Scripts\Dump\SslBindingsWeb1.txt $SslSiteBindings}}}

$StartTime = Get-Date

$WebServers = @(Get-Content $TOR01TagetsFileWeb |Sort-Object)

foreach ($WebServers in $WebServers) {

$SSlobjWMI = [WmiSearcher] "Select * From IISWebServerSetting"
$SSlobjWMI.Scope.Path = "\\" + $WebServers + "\root\microsoftiisv2" 
$SSlobjWMI.Scope.Options.Authentication = 6 
$SslSites = $SSlobjWMI.Get() 

# \Write-Host Server, HostHeader, IP Address, Port Number, SSL Port -ForegroundColor Green

foreach ($site in $SslSites)

{
    $SslBindings = $site.psbase.properties | ? {$_.Name -contains "SecureBindings"} 
	
 
	foreach ($SslPair in $SslBindings.Value.GetEnumerator()){$SslSiteBindings = $WebServers + ',' + $SslPair.Port
		$SslBindings = $null
	If ($SslPair.Port -notlike "*:*"){Get-SiteInfoNoSsl
	$ScanCount++}
	Else{Get-SiteInfoSsl
	$ScanCount++}}}}

$EndTime = (Get-Date)	
$TimeDiff = ($EndTime - $StartTime).TotalMinutes 
$ScansPerMin = ($ScanCount / $TimeDiff)



