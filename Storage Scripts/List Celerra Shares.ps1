$folders = @(
	"\\fsc07"
#	"\\fsc09"
)

function getShares($fileServer)
{
	$shares = ""
	$netView = (NET.EXE VIEW $fileServer)
	foreach ($string in $netView)
	{
		if ($string.Length -ge 22)
		{
			if ($string.Substring(18, 4) -eq "Disk") { $shares += ($string.Substring(0, 18).Trim() + ",") }
		}
	}
	return $shares.SubString(0, $shares.Length - 1)
}

Clear

foreach ($folder in $folders)
{
	Write-Host $folder
	$shares = getShares $folder
	foreach ($share in $shares.Split(","))
	{
		Write-Host $share
	}
}