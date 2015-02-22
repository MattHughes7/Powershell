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
$pswindow.windowtitle = "Massive Front Page Checker Watcher"

##### Get The File From Default Location #####

$OriginalFile = ("\\afox01\report\Massive.Front.Page.Check.Report.Sorted.Txt")
$ReportLocation = ("C:\Massive.Front.Page.Checker.Report.txt")

If((Test-Path $OriginalFile) -eq $false)
	
	{Write-Host '##### ' Cannot Read the Host File From $OriginalFile ' #####' -BackgroundColor Yellow -ForegroundColor Red
	Break}

		ELSE{Write-Host Backing up Orginal File From $OriginalFile -BackgroundColor Blue -ForegroundColor Green
		Sleep 1
		CLS
}

$OriginalFileContents = (Get-Content $OriginalFile)

##### BACKUP FILE ##### & ##### STRIP FILE OF HTTP:// #####

Get-Content $OriginalFile | Foreach-Object {$_ -replace "HTTP://", ""} | Set-Content $ReportLocation
#Copy-Item $OriginalFile $ReportLocation


##### CREATE HTML REPORT #####

$FinishedReport = "C:\Finished.Front.Page.Checker.Report.Html"
Clear-Content $FinishedReport
Add-Content $FinishedReport "<html>"
Add-Content $FinishedReport "<body>"
Add-Content $FinishedReport "<Center> <h1>Desire2Learn Massive Front Page Checker Report</h1> </Center>"
Add-Content $FinishedReport "<HR>"
Add-Content $FinishedReport "<BR>"

##### CREATE REPORT #####

$ReportResults = (Get-Content $ReportLocation)

Foreach ($ReportResults in $ReportResults){

If ($ReportResults -match "PASSED"){

##### PASSED STRING #####


$PassedString = '<P><FONT style="BACKGROUND-COLOR: Green" style="COLOR: white">' + $ReportResults +  '</FONT></P>'

Add-Content $FinishedReport $PassedString

}

ELSEIF ($ReportResults -match "FAILED" -and $ReportResults -notmatch "DAV.") {

$FailedString = '<P><FONT style="BACKGROUND-COLOR: Red" style="COLOR: white">' + $ReportResults +  '</FONT></P>'

Add-Content $FinishedReport $FailedString }

ELSE {}

}

###### END HTML FILE #####

Add-Content $FinishedReport "</html>"
Add-Content $FinishedReport "</body>"

##### OPEN REPORT #####

Invoke-Item $FinishedReport












#REMOVE REPORT WORKFILE
Remove-Item $ReportLocation












