#test-path ("\\" + $Targets + "\c$")
$Targets = ("CA1TWEB039A","CA1TWEB039B","CA1TWEB039C","CA1TWEB049A","CA1TWEB049B","CA1TWEB049C")


ForEach($Targets in $Targets){
Write-Host $Targets
#Test-Connection -Cn $Targets -BufferSize 16 -Count 1 -ea 0 -quiet
test-path ("\\" + $Targets + "\c$")
}

$Targets.Clear
$Targets = ("CA1TWEB039A","CA1TWEB039B","CA1TWEB039C","CA1TWEB049A","CA1TWEB049B","CA1TWEB049C")

ForEach($Targets in $Targets){
Write-Host Starting $Targets
Invoke-Command -ComputerName $Targets -AsJob {
$TargetsInvoked = ("CA1TWEB039A","CA1TWEB039B","CA1TWEB039C","CA1TWEB049A","CA1TWEB049B","CA1TWEB049C")
ForEach ($TargetsInvoked in $TargetsInvoked){
$Hostname = hostname
Write-Host $Hostname
#Test-Connection -Cn $TargetsInvoked -BufferSize 16 -Count 1 -ea 0 -quiet
test-path ("\\" + $TargetsInvoked + "\c$")
}}}

Wait-Job *
Receive-Job *

