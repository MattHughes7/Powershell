function isServerAlive([string]$serverName)
{
       $results = Get-WMIObject -query "select StatusCode from Win32_PingStatus where Address = '$serverName'"
       $responds = $false   
       foreach ($result in $results) {
              if ($result.statuscode -eq 0) {
             $responds = $true
              break
              }
       }
    If ($responds) { return $true } else { return $false }
}

$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.buffersize
$newsize.height = 3000
$newsize.width = 177
$pswindow.buffersize = $newsize
$newsize = $pswindow.buffersize
$pswindow.buffersize = $newsize
$newsize = $pswindow.windowsize
$newsize.height = 50
$newsize.width = 177
$pswindow.windowsize = $newsize
$pshost = get-host
$pswindow = $pshost.ui.rawui
$pswindow.windowtitle = "Massive Front Page Checker"

# Import the ActiveDirectory module to gain access to the AD CMDLETS.
Import-Module ActiveDirectory

# Enter the web farm to search for (ex web12*)
$Targets = (Read-Host "Enter Web Farm / Server")

$OpenTime = Get-Date
Write-Host Started On $OpenTime -ForegroundColor Green -BackgroundColor Blue

# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} | Where-Object {$_.DNSHostName -notlike "*-Test*"} | ForEach-Object {$_.DNSHostName}
Write-Host @"
"@
foreach ($Targets in $ADFarmTargets) {Write-Host $Targets -foregroundcolor green
$ServerCount++}

Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
$EntireStartTime = Get-Date #Scans Start Time

Write-Host @"
"@

$AliveServers = ("C:\AliveMassiveTest.txt")

If ((Test-Path $AliveServers) -eq $true){Clear-Content $AliveServers}
ELSE{}


FOREACH($Targets in $ADFarmTargets){
IF (isServerAlive($Targets) -eq true){

$AliveServers = ("C:\AliveMassiveTest.txt")

Add-Content $AliveServers $Targets
Write-Host $Targets is alive -ForegroundColor Green
}
ELSE{Write-Host $Targets is Dead -ForegroundColor Red}}

$Targets.Clear

$CleanTargets = Get-Content $AliveServers

###############################################


########### BEGIN THE TESTING ##########

#CLEAR REPORT FILE

$ReportFileCheck = "\\AFOX01\Report\Massive.Front.Page.Check.Report.Txt"

#CHECK IF REPORT FILE IS PRESENT


$ReportFilePresent = (Test-Path $ReportFileCheck)

If ($ReportFilePresent -eq $true){
Clear-Content $ReportFileCheck }
else{}

#Start the PS Session

$StartTotalTime = (Get-Date)

ForEach ($CleanTargets in $CleanTargets){

#### START INVOKE ####

Sleep 1

Invoke-Command -ComputerName $CleanTargets -AsJob {

#Poor Mans Throttle

$RandomTime1 = (Get-Random (1..90))
$RandomTime2 = (Get-Random (1..90))
$RandomTime = ($RandomTime1 + $RandomTime2)

Sleep $RandomTime

#Mount Report Dri
Net Use W: "\\AFOX01\REPORT" /persistent:no /user:tor01.desire2learn.d2l\afoxcolo Password

#Define Url Test File

$UrlTargetFile = ("c:\TestSitesTemp.Txt")

#Check if present and clear if is

$UrlFilePresent = (Test-Path $UrlTargetFile)
If ($UrlFilePresent -eq $true){
Clear-Content $UrlTargetFile }
else{}

$ServerName = "localhost"

#Get Websites

$websites = [ADSI]"IIS://$ServerName/W3SVC"
$websites.Children | ? { $_.Name -match "^\d+`$" } | % {
    $d2lDir = [ADSI]"$($_.Path)/ROOT/D2L"    
    $_.ServerBindings | % { 
        if( $_ -match ":([^:]+):([^:]+)" ) {
            $url = "HTTP://" + $matches[2]
			Add-Content $UrlTargetFile $url 
		
			
            
        }
    }
}


#TEST SITE


$TestSites = (Get-Content $UrlTargetFile)
$webClient = new-object System.Net.WebClient
$webClient.Headers.Add("user-agent", "PowerShell Script")
 
ForEach ($TestSites in $TestSites) {

   $output = ""
 
 	$ReportFile = "W:\Massive.Front.Page.Check.Report.Txt"
 
   $startTime = get-date
   
   Write-Host Testing $TestSites -ForegroundColor Green
   
   $output = $webClient.DownloadString($TestSites)
   
   $endTime = get-date
 
   if ($output -like "*Login*") {
   
	
	
	#Report Success
	
	$HostName = hostname
	
	$SuccessString = ($TestSites + ", " + $HostName + ", " + "PASSED")
	
	Add-Content $ReportFile $SuccessString
	 
	  
   } else {
     
	
	  
	  #Report Fail
	  
	  	$HostName = hostname
	
	$FailedString = ($TestSites + ", " + $HostName + ", " + "FAILED")
	
	Add-Content $ReportFile $FailedString 
	
   }
 
}

#Clean Up After Invoke
Net Use W: /Delete
Remove-Item $UrlTargetFile

#End Invoke-Command
}
#End for Each Loop
}


Write-Host Waiting On Jobs to Complete -ForegroundColor Green
Wait-Job *
Write-Host Jobs Completed -ForegroundColor Green
Remove-Job *

$EndTotalTime = (Get-Date)

$TotalLoadTime = (($EndTotalTime - $StartTotalTime).TotalSeconds)

Write-Host Did the WHOLE Jam 'in' $TotalLoadTime Seconds. Report is Done and Waiting'!' -BackgroundColor Blue -ForegroundColor Green 

#SORT AND OPEN

$ReportFile2 = "\\AFOX01\Report\Massive.Front.Page.Check.Report.Txt"
$ReportFileSorted = "\\AFOX01\Report\Massive.Front.Page.Check.Report.Sorted.Txt"
IF ((Test-Path $ReportFileSorted) -eq $true){Clear-Content $ReportFileSorted}
ELSE{}

Get-Content $ReportFile2 | sort | get-unique > $ReportFileSorted

Invoke-Item $ReportFileSorted