
############### LINE 210(ISH) MUST BE CHANGED TO SHOW CERT FILE NAME ################### 

#Define the Location on your Deployment Computer where the Cert is

#Temp Location on Target Computers. Must be Uniform Accross Target Enviroment
$TempLocation = "\Desire2Learn"

# Import the ActiveDirectory module to gain access to the AD CMDLETS.
Import-Module ActiveDirectory

#GUI
Write-Host "SaaS Certificate Deployment Tool v.1.0" -ForegroundColor Yellow
Write-Host @"
"@
Write-Host "Select the Certificate you Would Like to Import. Ensure Static Certname Changed in File On Imort Command" -ForegroundColor white
Write-Host @"
"@

#Get the Certificate and Define $CertOnLocal
Function Get-FileName($initialDirectory)
{  
 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
 Out-Null

 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
 $OpenFileDialog.initialDirectory = $initialDirectory
 $OpenFileDialog.filter = "Import Certificate (*.cer, *.crt)| *.*"
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.filename
} 
$CertOnLocal = Get-FileName -initialDirectory "N:\"
$CertName = split-path $CertOnLocal -Leaf 


# Enter the web farm to search for (ex WEB12*)
$Targets = (Read-Host "Enter Web Farm Name. ex "WEB12*" : ")

# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
$ADFarmTargets = Get-ADComputer -Server 172.21.3.33 -Filter {Name -like $Targets} | Where-Object {$_.DNSHostName -notlike "*-Test.TOR01.desire2learn.d2l"} | ForEach-Object {$_.DNSHostName}


#Display Targets
Write-Host @"
"@
foreach ($Targets in $ADFarmTargets) {
Write-Host $Targets -foregroundcolor green
}

Write-Host @"

"@

foreach ($Targets in $ADFarmTargets) {
$WebServerCount++
}
Write-Host "A Total of"  $WebServerCount "Web Servers Have Been Targeted" -foregroundcolor Yellow

Write-Host @"

"@

Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red

$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Write-Host @"
"@

Write-Host "Are You Sure?" -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Write-Host @"
"@


Write-Host "Proceeding with Deployment" -foregroundcolor Green
Write-Host @" 
"@

#	Copy the Certs to Targets	#

foreach ($Targets in $ADFarmTargets) {
Copy-Item -Path $CertOnLocal -Destination ('\\' + $Targets + $TempLocation) 
}


# Run Import-Certificate Function against all Targets
foreach ($Targets in $ADFarmTargets) {

Invoke-Command -computer $Targets -scriptblock { 
 
function Import-Certificate
{


	param
	(
		[IO.FileInfo] $CertFile = $(throw "Paramerter -CertFile [System.IO.FileInfo] is required."),
		[string[]] $StoreNames = $(throw "Paramerter -StoreNames [System.String] is required."),
		[switch] $LocalMachine,
		[switch] $CurrentUser,
		[string] $CertPassword,
		[switch] $Verbose
	)
	
	begin
	{
		[void][System.Reflection.Assembly]::LoadWithPartialName("System.Security")
	}
	
	process 
	{
        if ($Verbose)
		{
            $VerbosePreference = 'Continue'
        }
    
		if (-not $LocalMachine -and -not $CurrentUser)
		{
			Write-Warning "One or both of the following parameters are required: '-LocalMachine' '-CurrentUser'. Skipping certificate '$CertFile'."
		}

		try
		{
			if ($_)
            {
                $certfile = $_
            }
            $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $certfile,$CertPassword
		}
		catch
		{
			Write-Error ("Error importing '$certfile': $_ .") -ErrorAction:Continue
		}
			
		if ($cert -and $LocalMachine)
		{
			$StoreScope = "LocalMachine"
			$StoreNames | ForEach-Object {
				$StoreName = $_
				if (Test-Path "cert:\$StoreScope\$StoreName")
				{
					try
					{
						$store = New-Object System.Security.Cryptography.X509Certificates.X509Store $StoreName, $StoreScope
						$store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
						$store.Add($cert)
						$store.Close()
						Write-Verbose "Successfully added '$certfile' to 'cert:\$StoreScope\$StoreName'."
					}
					catch
					{
						Write-Error ("Error adding '$certfile' to 'cert:\$StoreScope\$StoreName': $_ .") -ErrorAction:Continue
					}
				}
				else
				{
					Write-Warning "Certificate store '$StoreName' does not exist. Skipping..."
				}
			}
		}
		
		if ($cert -and $CurrentUser)
		{
			$StoreScope = "CurrentUser"
			$StoreNames | ForEach-Object {
				$StoreName = $_
				if (Test-Path "cert:\$StoreScope\$StoreName")
				{
					try
					{
						$store = New-Object System.Security.Cryptography.X509Certificates.X509Store $StoreName, $StoreScope
						$store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
						$store.Add($cert)
						$store.Close()
						Write-Verbose "Successfully added '$certfile' to 'cert:\$StoreScope\$StoreName'."
					}
					catch
					{
						Write-Error ("Error adding '$certfile' to 'cert:\$StoreScope\$StoreName': $_ .") -ErrorAction:Continue
					}
				}
				else
				{
					Write-Warning "Certificate store '$StoreName' does not exist. Skipping..."
				}
			}
		}
	}
	
	end
	{ }

}

### IMPORTAINT ### CHANGE THE CERT FILE NAME BELOW. IF PASSWORD IS REQUIRED ADD -CERTPASSWORD SWITCH AND INCLUDE PASSWORD IN SINGLE QUOTES ''

Write-Host $CertOnRemote
#Import-Certificate -CertFile "D:\Desire2Learn\BrowardCollege.cer" Root -LocalMachine -Verbose
Import-Certificate -CertFile "D:\Desire2Learn\BrowardCollege.cer" CurrentUser -localmachine -Verbose

} 
}

# Remove the certificate from the target target machine.
foreach ($Targets in $ADFarmTargets) {
DEL ('\\' + $Targets + $TempLocation + '\' + $CertName) 
}


