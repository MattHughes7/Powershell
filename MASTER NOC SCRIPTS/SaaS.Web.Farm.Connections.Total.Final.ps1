
############################ CONNECTION MONITOR WATCHER LOGGER ##########################

########## GLOBAL VAR ###########

$RandomTempNumber = (Get-Random (100000..999999))

$AliveServers = ("C:\Connection.Monitor.Alive.File." + $RandomTempNumber + ".txt") #No File Currently Used
$TotalFarmConnections = [int] "0"
$TotalNodeCountInLoad = [int] "0"
$TotalNodeCountOutOfLoad = [int] "0"
$2K8ConnectionLimit = [int] "700"
$2K3ConnectionLimit = [int] "400"
$Total2K3Nodes = [int] "0"
$Total2K8Nodes = [int] "0"
$ConnectionsMinusThreeNode = "Not Enough Nodes"

############################ SEARCH AD FOR TARGETS ##########################

Import-Module ActiveDirectory
#$Targets = (Read-Host "Enter Web Farm / Server")
[int]$num = 1
[int]$num = Read-host "Enter number of Server queries" -ErrorAction Stop
$ADFarmTargets = @()
1..$num | ForEach-Object {
$Targets = (Read-Host "Enter Web Farm / Server")
$ADFarmTargets += Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} | Where-Object {$_.DNSHostName -notlike "*-Test*"} | ForEach-Object {$_.DNSHostName}
}
Write-Host @"
"@

foreach ($Targets in $ADFarmTargets) {Write-Host $Targets -foregroundcolor green
$ServerCount++}

Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
$EntireStartTime = Get-Date #Scans Start Time

Write-Host @"
"@

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
    If ($responds) { return $true } else { return $false }}

FOREACH($Targets in $ADFarmTargets){
IF (isServerAlive($Targets) -eq true){
Add-Content $AliveServers $Targets
Write-Host $Targets is alive -ForegroundColor Green }
ELSE{}}

$CleanTargets = Get-Content $AliveServers

###############################################


###### CHANGE THE WINDOW #####

$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.buffersize
$newsize.height = 3000
$newsize.width = 100
$pswindow.buffersize = $newsize
$newsize = $pswindow.buffersize
$pswindow.buffersize = $newsize
$newsize = $pswindow.windowsize
$newsize.height = 71
$newsize.width = 100
$pswindow.windowsize = $newsize
$pshost = get-host
$pswindow = $pshost.ui.rawui
$pswindow.windowtitle = "D2L SaaS NOC Web Farm Connection Checker"
$ErrorActionPreference = "SilentlyContinue" #Me too powershell... Me too
CLS

##################################################				CHECK CONNECTIONS AND OS VERSION				##################################################

$Heading = @"

	Host Name		Total Connections	Operating System		

"@

Write-Host $Heading -ForegroundColor Green -BackgroundColor Blue

FOREACH ($Targets in $CleanTargets){


$NodeDetails = (Get-WmiObject Win32_PerfFormattedData_W3SVC_WebService -ComputerName $Targets | Select-Object -Property Name , __server ,CurrentConnections,MaximumConnections,@{Name="TotalBytesReceived"; Expression ={"{0:N0}" -f ($_.TotalBytesReceived/1MB)}},@{Name="TotalBytesSent"; Expression ={"{0:N0}" -f ($_.TotalBytesSent/1MB)}}|Where-Object {$_.Name -like "*total*"})

$TotalConnections = $NodeDetails.CurrentConnections
$NodeName = $NodeDetails.__server

	$OperatingSystemGet = (Get-WmiObject -ComputerName $Targets -class Win32_OperatingSystem).Caption
	
	If ($OperatingSystemGet -match "2003" -and $TotalFarmConnections -ge 5){
		$OperatingSystem = "2K3"
		$Total2K3Nodes++}
		
		ELSEIF ($OperatingSystem -match "2K8" -and $TotalFarmConnections -ge 5){ 
		$Total2K8Nodes++}
		
		ELSEIF ($OperatingSystemGet -match "2003" ){
		$OperatingSystem = "2K3"}
		
		ELSEIF ($OperatingSystemGet -match "2008" ){
		$OperatingSystem = "2K8"}
		
		ELSE{}


$Body = @"

	$NodeName			$TotalConnections			$OperatingSystem		

"@

$TotalFarmConnections = ([int] $TotalFarmConnections + $TotalConnections)

Write-Host $Body -ForegroundColor Green

IF ($TotalConnections -le 5){
$TotalNodeCountOutOfLoad++
}
ELSE{$TotalNodeCountInLoad++}
}

$TotalPossibleConnections = (($Total2K3Nodes * $2K3ConnectionLimit) + ($Total2K8Nodes * $2K8ConnectionLimit))

$AverageConnectionsPerNode = ($TotalFarmConnections / $TotalNodeCountInLoad)
$AverageConnectionsPerNode = [math]::truncate($AverageConnectionsPerNode)
#If your readin this, I would imagine your considering changing the script. Please maker your own copy. Or I will dox you, and I will kill you. Well not really, 
#but you get the point
$TotalConnectionsStillPossible = ($TotalPossibleConnections - $TotalFarmConnections)
$ConnectionsMinusOneNode = [int] ($TotalFarmConnections / ($TotalNodeCountInLoad - 1))  
$ConnectionsMinusTwoNode = [int] ($TotalFarmConnections / ($TotalNodeCountInLoad - 2)) 
If ( $TotalNodeCountInLoad -le 3){}
Else{ $ConnectionsMinusThreeNode = [int] ($TotalFarmConnections / ($TotalNodeCountInLoad - 3)) } 

$Report = @"
 
 Total Nodes In the Load:		$TotalNodeCountInLoad
 
 Total Nodes Out Of Load:		$TotalNodeCountOutOfLoad
 
 Total Farm Connections:		$TotalFarmConnections

 Total Possible Connections:		$TotalPossibleConnections
 
 Total Remaining Connections:		$TotalConnectionsStillPossible

 Avrg Conn / Active Node:		$AverageConnectionsPerNode
 
 Conn / Node Removing One Node:		$ConnectionsMinusOneNodeca
 
 Conn / Node Removing Two Nodes: 	$ConnectionsMinusTwoNode
 
 Conn / Node Removing Three Nodes: 	$ConnectionsMinusThreeNode

"@

Write-Host $Report -ForegroundColor Green

$RunAgain = ( "N" )

$RunAgain = (Read-Host "Run the Script Again?(Y/N)")

If ($RunAgain -match "Y"){
'D:\MASTER NOC SCRIPTS\SaaS.Web.Farm.Connections.Total.Final.ps1' 

}

ELSE{ 
Remove-Item $AliveServers
EXIT }