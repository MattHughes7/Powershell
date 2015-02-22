
#PUT THE TARGET SERVERS IN THE FILE BELOW#

$Targets = Get-Content "N:\Toolbox\kerb\2k8.txt"

Foreach ($Targets in $Targets){

Invoke-Command -ComputerName $Targets -AsJob {

#clear the screen
Clear

#user defined variables
[String] $userAccount = "TOR01\D2LAPPUSER"
[String] $logonSessionShare = "\\172.19.3.180\Shared\"
#application variables
[System.Management.Automation.PSObject] $regValue
[System.Array] $results
$logonSessions = New-Object System.Collections.Generic.List[String]
[String] $logonSession


#check if the logonsessions command exists
if (!(Test-Path -Path "C:\Windows\System32\logonsessions.exe"))
{
	#copy the file from a remote server
	Copy-Item -Path ($logonSessionShare + "logonsessions.exe") -Destination "C:\Windows\System32\"
}

#check if the logonsessiosn EULA has been accepted
$regValue = Get-ItemProperty -Path HKCU:SOFTWARE\Sysinternals\LogonSessions -Name "EulaAccepted" 2> $null
#value is missing
if ($regValue -eq $null)
{
	#add the registry entry to accept the EULA
	New-Item -Path HKCU:SOFTWARE\Sysinternals -Name "LogonSessions" -Force > $null
	New-ItemProperty -Path HKCU:SOFTWARE\Sysinternals\LogonSessions -Name "EulaAccepted" -PropertyType "DWORD" -Value 1 > $null
}

#run the logon sessions command and grab the output
$results = C:\Windows\System32\logonsessions.exe

#run through the output and look for valid logon sessions
foreach ($result in $results)
{
	#check for the logon session line and save the session
	if ($result.ToUpper().Contains("LOGON SESSION")) { $logonSession = $result }
	#check for the user we want
	elseif ($result.ToUpper().Contains($userAccount))
	{
		#grab the lower portion of the logon session (this is what we need for klist)
		$logonSession = $logonSession.Substring($logonSession.Length - 9, 8)
		#add it to the list
		$logonSessions.Add($logonSession)
	}
}

#loop through the collection sessions
foreach ($session in $logonSessions)
{
	#run the klist command purging this session
	$arguments = ("-li " + $session + " purge")
	Start-Process "c:\windows\system32\klist.exe" -ArgumentList $arguments
}

#Recycle the application pools
D:\Desire2Learn\bin\Recycle\Recycle.ps1 "all"

}
}

Wait-Job *
Receive-Job *
Remove-Job *