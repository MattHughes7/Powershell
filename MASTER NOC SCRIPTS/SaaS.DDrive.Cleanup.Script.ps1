#	TIM TEMP DELETER	#
#
#RoboDelete.Exe /PATH:D:\Desire2Learn\Instances /RECURSIVE /EMPTYFOLDERS /AGEINTERVAL:N /MINAGE:7 /LOG:C:\RoboDelete.log /IFILES:*\tim\temp\* /IFOLDERS:*\tim\temp* 

#	GET TARGETS #

#$TARGETS = "ca1tweb049c.tor01.desire2learn.d2l"

Import-Module ActiveDirectory
$ADFarmTargets = @()

$Targets = (Read-Host "Enter Web Farm / Server")
$ADFarmTargets += Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} | Where-Object {$_.DNSHostName -notlike "*-Test*"} | ForEach-Object {$_.DNSHostName}

Write-Host @"
"@

foreach ($Targets in $ADFarmTargets) {Write-Host $Targets -foregroundcolor green
$ServerCount++}

Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
$EntireStartTime = Get-Date #Scans Start Time

Write-Host @"
"@


#	MOVE FILES	#
<#
FOREACH($TARGETS in $TARGETS){
	
	$SendToTargetStrings = "\\" + $TARGETS + $RoboDeleteFileDest
	$SendToTargetStringsBat = "\\" + $TARGETS + $RoboDeleteFileDestBat
	Copy-Item $RoboDeleteFileSource $SendToTargetStrings -Verbose -Force
	Copy-Item $RoboDeleteFileSourceBat $SendToTargetStringsBat -Verbose -Force
	Write-Host Copying RoboDelete to $TARGETS -ForegroundColor Green

}#>



FOREACH($TARGETS in $ADFarmTargets){


	#### DELETE LOGS PS ####
	
		Invoke-Command -ComputerName $Targets{
		#D:\Logfiles
		rd /s 'D:\$Recycle.bin'
		rd /s 'C:\$Recycle.bin'

		#----- define parameters -----#
		#----- get current date ----#
		$Now = Get-Date 
		#----- define amount of days ----#
		$Days = "31"
		#----- define folder where files are located ----#

		$TargetFolder = "d:\logfiles\"
		#----- define extension ----#
		$Extension = "*.log"
		#----- define LastWriteTime parameter based on $Days ---#
		$LastWrite = $Now.AddDays(-$Days)

		#----- get files based on lastwrite filter and specified folder ---#
		$Files = Get-Childitem $TargetFolder -Include $Extension -Recurse | Where {$_.LastWriteTime -le "$LastWrite"}

		foreach ($File in $Files){

		if ($File -ne $NULL)
		{
	write-host "Deleting File $File" -ForegroundColor "DarkRed"
	Remove-Item $File.FullName | out-null
	}
else
{
Write-Host "No more files to delete!" -foregroundcolor "Green"
}}}

### END PS LOG DELETER ###



	$Random = Get-Random (100..999)

	Write-Host Starting RoboDelete on $TARGETS 

	$BuiltPath = "\\" + $TARGETS + "\d$\Desire2Learn\Instances"

	$LogName = "N:\Toolbox\RoboDelete\LogFiles\RoboDelete." + $Targets + "." + $Random + ".log"

	Write-Host Attacking $BuiltPath

	CMD /C N:\Toolbox\RoboDelete\RoboDelete.Exe /PATH:$BuiltPath /RECURSIVE /EMPTYFOLDERS /AGEINTERVAL:N /MINAGE:7 /LOG:$LogName /IFILES:*\tim\temp\* /IFOLDERS:*\tim\temp* /test 

	$Random.Clear
}

$([char]7) 
Write-Host COMPLETED -ForegroundColor Green
$([char]7) 



