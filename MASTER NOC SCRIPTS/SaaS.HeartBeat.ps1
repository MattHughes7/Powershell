##### CREATES A HEARTBEAT EVENT AT 12 NOON LOCAL TIME THAT SCOM REPORTS BACK WITH ## ADAM FOX
## Script Variables

#Change for location
$DCID = "CA1/CA2"



$Time = (Get-Date)
$Log = "System"
$Source = "System Center Operations Manager Heartbeat"
$Message = "CA1/CA2 SCOM Heartbeat. Local System Time is " + $Time + "."
$ID = "41199"
$AlertType = "Information" 
$ComputerName = "."
$RawData = ""
 
##Register the source
New-eventlog -logname $Log -ComputerName $ComputerName -Source $Source -ErrorVariable Err -ErrorAction SilentlyContinue
 
##Write to the system log
Write-eventlog -logname $Log -ComputerName $ComputerName -Source $Source -Message $Message -id $ID -EntryType $AlertType
