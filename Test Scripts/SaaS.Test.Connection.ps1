Import-Module OperationsManager
# Connect to Operations Manager 2012 on HFSCOMMS01.TOR01.desire2learn.d2l
Start-OperationsManagerClientShell -ManagementServerName: "HFSCOMMS01.TOR01.desire2learn.d2l" -PersistConnection: $true -Interactive: $true;

$a = Get-SCOMAgent -DNSHostName "t1web51*" | ForEach-Object {
		if (Test-Connection $_.Displayname -ErrorAction SilentlyContinue)
			{
				Write-Host $_.Displayname UP -ForegroundColor Green
			}
		else {
				Write-Host $_.Displayname Down -ForegroundColor Red
			}
}