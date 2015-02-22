#region File Locations
#Define our locations
$locations = @(
"\\fs-COE\TEMP\",
"\\fs-DemoRoot\TEMP\",
"\\fs-Maryville\TEMP\",
"\\FSC02\analyticsdemo\temp\",
"\\fs-BCCampus\TEMP\",
"\\fs-CRI\TEMP\",
"\\fs-ECSD\TEMP\",
"\\fs-ISTE\TEMP\",
"\\fs-Maryland\TEMP\",
"\\fs-Schoolboards\TEMP\",
"\\fs-SCL\TEMP\",
"\\fs-SIDES\TEMP\",
"\\fs-USC_Rossier\TEMP\",
"\\fs-VLN\TEMP\",
"\\fs-ALSDE\TEMP\",
"\\fs-Partners\TEMP\",
"\\fs-Rosalind\TEMP\",
"\\fs-SDBOR\TEMP\",
"\\fs-SREB\TEMP\",
"\\fs-CDI\TEMP\",
"\\fs-eLO\TEMP\",
"\\fs-NFSTC\TEMP\",
"\\fs-ALSDE\TEMP\",
"\\fs-Schoolboards\TEMP\",
"\\fsc07\MWSU\temp\",
"\\fsc07\4CD\temp\",
"\\FSC07\AOE\temp\",
"\\FSC07\CICA\temp\",
"\\fsc05789-bell\Community\temp\",
"\\fsc07\eLOTestDemo\TEMP\",
"\\fsc07\FDLC\TEMP\",
"\\FSC07\GRU\temp\",
"\\FSC08\KNAER\temp\",
"\\FSC09\Langara\temp\",
"\\fsc07\NLU\temp\",
"\\fsc07\PGprod\temp\",
"\\fsc07\rcl\temp\",
"\\t1oruweb01\oru\TEMP\",
"\\fs-PNDevServer\TEMP\",
"\\fsc07\4CDTest\TEMP\",
"\\fsc08\aoe_dev\TEMP\",
"\\fsc07\aoe_test\TEMP\",
"\\fs-ASD20Test\TEMP\",
"\\fs-BCOnlineTest\TEMP\",
"\\fs-BJUTest\BJUTest\TEMP\",
"\\fsc09\CBCTest\TEMP\",
"\\fs-CENCOLTEST\TEMP\",
"\\fs-d2lcommtest\TEMP\",
"\\fsc08\DurhamStaging\TEMP\",
"\\FSC09\EFMOOCQA\TEMP\",
"\\FSC08\EFTDev\TEMP\",
"\\fs-EGTC_Test\EGTC_Test\TEMP\",
"\\fsc08\GSUDev\TEMP\",
"\\FSC09\GSUTest\TEMP\",
"\\FSC07\GwinnettTest\TEMP\",
"\\fs-HACCTest\TEMP\",
"\\fs-iLearnNYCTest\TEMP\",
"\\FSC07\LakeheadUTestTEMP\",
"\\fs-LCCTest\TEMP\",
"\\fs-LCLTest\TEMP\",
"\\fsc07\NEIUTest\TEMP\",
"\\fs-NJVS_Test\TEMP\",
"\\fsc07\ool_guelphtest\TEMP\",
"\\fsc07\OUHSCTest\TEMP\",
"\\FSC08\OUPDev\TEMP\",
"\\fs-OUPTest\OUPTest\TEMP\",
"\\fsc07\ParklandTest\TEMP\",
"\\HQPD03\PearsonQA\TEMP\",
"\\fsc07\PGTest\TEMP\",
"\\fs-PIMATest\TEMP\",
"\\fs-PJETest\TEMP\",
"\\FSC07\SAITTest\TEMP\",
"\\T1WEB88A-Test\Sandbox_S_Test\TEMP\",
"\\HFQAFS01\TEMP\",
"\\FSC09\SheridanQA\TEMP\",
"\\fs-SIUTest\TEMP\",
"\\fs-TAMUKTEST\TEMP\",
"\\fs-UCBTest\TEMP\",
"\\fsc09\UCOTest\TEMP\",
"\\fsc09\uwaterloodev\TEMP\",
"\\fs-UWaterlooTest\TEMP\",
"\\fs-WIUTest\TEMP\",
"\\FS-GSU\TEMP\"
)

$locations = @(
"\\fsc07\4CDTest\temp\"
)
#endregion

#region Functions
function crawlFolder($rootFolder, $deletedSize, $deletedCount, $skipSize, $skipCount, $errorFiles, $suspectFiles)
{
	#Get the subfolders in this folder
	$folders = Get-ChildItem -Path ($rootFolder) | where {$_.PSIsContainer}
	#Make sure we have at least one subfolder
	if ($folders)
	{
		#Loop through the subfolders
		foreach ($folder in $folders) 
		{
			#Crawl this subfolder and add it to the total size
			$deletedSize, $deletedCount, $skipSize, $skipCount, $errorFiles, $suspectFiles = crawlFolder $folder.FullName $deletedSize $deletedCount $skipSize $skipCount $errorFiles $suspectFiles
		}
	}
	#Get the list of files in this folder
	$files = Get-ChildItem $rootFolder | Where-Object { !$_.PSIsContainer }
	#Make sure we have at least one file
	if ($files)
	{
		#Loop through the files
		foreach ($file in $files)
		{
			#Check to see if the file is older than our threshold
			if ($file.lastWriteTime -lt (Get-Date).AddHours(-$dateModifiedThreshold))
			{
				#Delete the file
				#Remove-Item -Path $file.FullName 2> $null
				#If the file was deleted, add it to the total size
				if ($?) { $deletedSize += $file.Length; $deletedCount++ }
				#Couldn't delete the file...add it to the list
				else { $errorFiles += ($file.FullName + ",") }
			}
			#File is under our threshold
			else 
			{ 
				#Add this file to the list of skipped files
				$skipSize += $file.Length
				$skipCount++;
				#Check if this file is over our suspect threshold
				if ($file.Length -ge ($suspectFileThreshold * 1024 * 1024)) { $suspectFiles += ($file.FullName + " (" + ([Math]::Round($file.Length / 1024 / 1024, 2)) + " MB),") }
			}
		}
	}
	#Return the total size of the files deleted so far
	return $deletedSize, $deletedCount, $skipSize, $skipCount, $errorFiles, $suspectFiles
}

function sendSMTPMessage($messageBody)
{
	$SMTP = New-Object Net.Mail.SmtpClient("mail2.desire2learn.com")
	$mailMessage = New-Object Net.Mail.MailMessage
	$mailMessage.From = "noreply@desire2learn.com"
	$mailMessage.To.Add("kevin.fox@desire2learn.com")
	$mailMessage.Subject = ("File Server - Temp Clean")
	$mailMessage.Body = $messageBody
	$mailMessage.IsBodyHtml = $true
	$SMTP.Send($mailMessage)
}
#endregion

#region Variables
$dateModifiedThreshold 	= 24		#Hours
$suspectFileThreshold 	= 1		#MB
$outputFile				= ("I:\" + $MyInvocation.MyCommand.Name + ".txt")
#endregion

Clear

#region Main
#Create the output file and write the header
$outputStream = [System.IO.StreamWriter] $outputFile
if ($outputStream) { $outputStream.WriteLine("Location,Deleted Files,Deleted Size (MB),Ignored Files,Ignored Size (MB)") }
#Loop through the temp locations
foreach ($location in $locations)
{
	#Go through this folder deleting necessary files
	$deletedSize, $deletedCount, $skipSize, $skipCount, $errorFiles, $suspectFiles = crawlFolder $location 0 0 0 0 $errorFiles $suspectFiles
	Write-Host ($location + "," + $deletedCount + "," + $deletedSize + "," + $skipCount + "," + $skipSize)
	if ($outputStream) { $outputStream.WriteLine($location + "," + $deletedCount + "," + $deletedSize + "," + $skipCount + "," + $skipSize) }
	#Add to the mail message
	$mailMessage += "<tr>"
	$mailMessage += ("<td>" + $location + "</td>")
	$mailMessage += ("<td>" + $deletedCount + "</td>")
	$mailMessage += ("<td>" + ([Math]::Round($deletedSize / 1024 / 1024, 2)) + "</td>")
	$mailMessage += ("<td>" + $skipCount + "</td>")
	$mailMessage += ("<td>" + ([Math]::Round($skipSize / 1024 / 1024, 2)) + "</td>")
	$mailMessage += "</tr>"
}
#Finalize the mail message
$mailMessage = ("<table border=`"1`"><tr><td><b>Location</b></td><td><b>Deleted Files</b></td><td><b>Deleted Size (MB)</b></td><td><b>Files Ignored</b></td><td><b>Ignored Size (MB)</b></td></tr>" + $mailMessage + "</table><br>")
#Check for any files we had errors on
if ($errorFiles) 
{ 
	$errorFiles = $errorFiles.Substring(0, $errorFiles.Length - 1)
	$mailMessage += "<br><b>Files Could Not Be Deleted:</b><br>"
	foreach ($file in $errorFiles.Split(",")) 
	{ 
		$mailMessage += ($file + "<br>") 
		if ($outputStream) { $outputStream.WriteLine("Could not delete file: " + $file) }
	}
}
#Check for any suspect files
if ($suspectFiles) 
{ 
	$suspectFiles = $suspectFiles.Substring(0, $suspectFiles.Length - 1)
	$mailMessage += "<br><b>Suspect Files:</b><br>"
	foreach ($file in $suspectFiles.Split(",")) 
	{
		$mailMessage += ($file + "<br>") 
		if ($outputStream) { $outputStream.WriteLine("File is suspect: " + $file) }
	}
}
#Close the output file
if ($outputStream) { $outputStream.close() }
#Send the email
sendSMTPMessage $mailMessage
#endregion