<#
.Synopsis
  Recycles application pools matching a string and hits the warm-up page for all D2L sites using that pool
.Description
  Recycles application pools matching a string and hits the warm-up page for all D2L sites using that pool
  
  The complete order of operations is:
  1. Get a full list of D2L sites and their app pools
  2. Recycle app pools that match the provided app pool string, and hit the warm-up page of sites in that pool
  
  All sites must be in the hosts file configured to point to the local server
    
.Parameter AppPoolString
  Application pools containing this string will be recycled.  Wildcards allowed.  Defaults to "warmuponly" so no recycles occur if nothing is passed (but the warmup URLs are hit), if "all" is passed it recycles all the net pools ("*D2LNet*").
  If "warmuponly" (or nothing) is passed as the AppPoolString it skips the recycle entirely and just warms up all pools

.Example    
    Recycles the D2LNETAppPool, and hits the appropriate warm-up pages
    .\Recycle.ps1 "D2LNETAppPool"
.Example    
    Recycles all D2LNet application pools, and hits the appropriate warm-up pages
    .\Recycle.ps1 "all"
.Example
    Performs no recycles, just hits all warm-up pages
    .\Recycle.ps1 "warmuponly"
.Example
    Performs no recycles, just hits all warm-up pages
    .\Recycle.ps1
#>

param
(
    [parameter()][string] $AppPoolString = "warmuponly"
)


if ( $AppPoolString -eq "all" ) {
	$AppPoolString = "*D2LNet*"
}

$WarmUpOnly = 0

if ( $AppPoolString -eq "warmuponly" ) {
	$WarmUpOnly = 1
	$AppPoolString = "*D2LNet*"
}

$ServerName = "localhost"

$sitePools = @{}
$websites = [ADSI]"IIS://$ServerName/W3SVC"
$appPools = [ADSI]"IIS://$ServerName/W3SVC/AppPools"

$websites.Children | ? { $_.Name -match "^\d+`$" } | % {
    $d2lDir = [ADSI]"$($_.Path)/ROOT/D2L"    
    $_.ServerBindings | % { 
        if( $_ -match ":([^:]+):([^:]+)" ) {
            $url = $matches[2]
            $sitePools.Add($url,$d2lDir.AppPoolId)
        }
    }
}

$appPools.Children | ? { $_.Name -like $AppPoolString } | % { 
    $appPoolName = $_.Name
    if ( $WarmUpOnly -eq 0 ) {
    	echo "Recycling $appPoolName..."
	    $_.Recycle()
    	    Start-Sleep -s 3
    }
    
    echo "Hitting status pages for websites in $appPoolName..."
    $sitePools.keys | ? { $sitePools."$_" -eq $appPoolName } | % {
	$url = $_
        $site = new-object System.Net.WebClient
        $site.Headers.Add("user-agent", "WarmUpPage")
        try {
            $siteLoad = $site.DownloadString("http://$url/d2l/common/admin/status.d2l")
            echo "`tStatus page loaded for $url..."
        }
        catch [system.exception] {
            echo "`t$url is inaccesible - $($_)..."
        }  
    }
}
