#Add base cmdlets with VMware
Add-PSSnapin VMware.VIMAutomation.core

#Connect to VIServer specified VI Server
Write-Host -ForegroundColor Green "Choose VI Server"
Write-Host -ForegroundColor Yellow "1) Bell (Toronto)"
Write-Host -ForegroundColor Yellow "2) Verizon (Toronto)"
Write-Host -ForegroundColor Yellow "3) Equinix (Sydney Austrailia)"

$server = Read-Host -Prompt 'Option'

If ($server -eq 1){
	Write-Host -ForegroundColor Green "Connecting to Bell.."
	Connect-VIServer T1VCS01
}
If ($server -eq 2){
	Write-Host -ForegroundColor Green "Connecting to Verizon.."
	Connect-VIServer HFVCS01
}
ElseIf ($server -eq 3){
	Write-Host -ForegroundColor Green "Connecting to Equinix.."
	Connect-VIServer AUSYEQS08VC0001
}
Else {
Write-Host -ForegroundColor Red "Error: select options 1,2 or 3."
}