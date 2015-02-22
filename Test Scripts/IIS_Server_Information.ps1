# By Daryl Rolleman
Import-Module ActiveDirectory
# Enter the web farm to search for (ex web12*)
#$Targets = (Read-Host "Enter Web Farm Name")

# Searches Active Directory for the Server that match the string in $Targets and creates an array called $ADFarmsearch. Any server appended with "-Test" will be excluded from the list.
#$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} | ForEach-Object {$_.DNSHostName}

$Win32_OS = Get-WmiObject -ComputerName WEB08G Win32_OperatingSystem -Authentication 6

if ($Win32_OS.BuildNumber -eq "7601")
		{
			Write-Host ("Internet Information Services 7 has been detected") -ForegroundColor Red
			Import-Module WebAdministration
				Get-Website
		}
			elseif ($Win32_OS.BuildNumber -eq "3790")
				{
					Write-Host ("Internet Information Services 6 has been detected") -ForegroundColor Red
					$iisSettings = Get-WmiObject -Namespace "root/MicrosoftIISv2" -Class  IIsWebServerSetting
					$iisSettings | Select-Object -ExpandProperty ServerBindings | Select-Object @{label="HostHeader";Expression={$_.HostName}}
					#$iisSettings | Select-Object -ExpandProperty ServerBindings | Select-Object @{label="HostHeader";Expression={$_.HostName}},@{label="IP";Expression={$_.IP}},@{label="Port";Expression={$_.Port}}
					
					
					
					
					#$iisSettings | 
                    #Select-Object @{label="Name";Expression={$_.ServerComment}},
                    #@{label="ID";Expression={$_.Name}},
                    #@{label="Site_IP";Expression={$_.ServerBindings | Select-Object -ExpandProperty IP}}#,
					#@{label="Site_Port";Expression={$_.ServerBindings | Select-Object -ExpandProperty Port}}
				}