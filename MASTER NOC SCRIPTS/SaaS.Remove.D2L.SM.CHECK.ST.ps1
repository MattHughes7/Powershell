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
$pswindow.windowtitle = "Removes D2L SM Check"

$Targets = (Get-Content 'n:\Action Files - Delete After Use\D2LSMCHECK.Targets.txt')


foreach ($Targets in $Targets){
$KillPath = "\\" + $Targets + "\d$\d2lservicecheck.bat"
Remove-Item $KillPath
}


