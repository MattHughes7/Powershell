########## Purpose ##############
# This script is meant to be used to search mail from mail servers, in order to decided what mail should be deleted 
# Policy is located at the following location
# http://desire2know.desire2learn.d2l/D2L_Tools/Learning_Environment/Email/Mail_Archival_Policy

########## GLOBAL VAR ###########
$Targets = "HFSCOMRPT01"
$FileTypesToMove = "*.bad,*.bdp,*.bdr"
#$ErrorActionPreference = "SilentlyContinue"

######################### MAIN FUNCTIONS #########################################

FOREACH ($Targets in $Targets) {
Write-Host Starting $Targets
	Invoke-Command -ComputerName $Targets -AsJob {
	#Move-Item c:\inetpub\mailroot\*.bad -Destination \\fs-support\support\test\ -Force
	
	#robocopy.exe /recursive /log+:c:\MailMoverLog.txtjhigh


	Get-ChildItem c:\inetpub -Include *.bad -Recurse | Foreach {
	
	#Move-Item $_.FullName -destination "\\fs-support\support\test" -force -ErrorAction:SilentlyContinue
	Write-Host $_Name 
  }
}}

Wait-Job *
Receive-Job *
Remove-Job *
exit	
