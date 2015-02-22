
$FileTypesToMove = "*.bad,*.bdp,*.bdr,*.txt"
	
Get-ChildItem c:\test -Include *.txt,*.bad -Recurse | Foreach {Write-Host $_.FullName
$Path = split-path $_.FullName -NoQualifier
$Hostname = hostname
$CleanPath = $Hostname + $Path.Replace("\","")
#Write-Host $_.FullName
Write-Host $CleanPath

#Move-Item $_.FullName -destination "\\fs-support\support\test" -force -ErrorAction:SilentlyContinue 

}