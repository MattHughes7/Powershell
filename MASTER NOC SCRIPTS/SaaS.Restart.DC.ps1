
throw "DONT RUN THIS, DUMBASS"
$RebootServerTargets2K3 = Get-Content n:\Toolbox\kerb\2k3.txt

Write-Host "You Want To Reboot All 2K3 Servers?" -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Write-Host "You Really Want to Boot a Freaking DC?" -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Foreach ($RebootServerTargets2K3 in $RebootServerTargets2K3){

Write-Host Restarting $RebootServerTargets2K3
#Restart-Computer -ComputerName $RebootServerTargets2K3 -Force

Sleep 1
}