﻿############################ Clean Windows ##########################


########## GLOBAL VAR ###########

$RandomTempNumber = (Get-Random (100000..999999))
$AliveServers = ("C:\Cleanup." + $RandomTempNumber + ".txt") #No File Currently Used


############################ SEARCH AD FOR TARGETS ##########################

Import-Module ActiveDirectory
$Targets = (Read-Host "Enter Web Farm / Server")
$ADFarmTargets = Get-ADComputer -Server "172.21.3.33" -Filter {Name -like $Targets} | Where-Object {$_.DNSHostName -notlike "*-Test*"} | ForEach-Object {$_.DNSHostName}

Write-Host @"
"@

foreach ($Targets in $ADFarmTargets) {Write-Host $Targets -foregroundcolor green
$ServerCount++}

Write-Host "Any Key to Continue or Close the Window to Exit." -foregroundcolor red
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
$EntireStartTime = Get-Date #Scans Start Time

Write-Host @"
"@

function isServerAlive([string]$serverName)
{       
$results = Get-WMIObject -query "select StatusCode from Win32_PingStatus where Address = '$serverName'"
       $responds = $false   
       foreach ($result in $results) {
              if ($result.statuscode -eq 0) {
             $responds = $true
              break				
              }
       }
    If ($responds) { return $true } else { return $false }}

FOREACH($Targets in $ADFarmTargets){
IF (isServerAlive($Targets) -eq true){
Add-Content $AliveServers $Targets
Write-Host $Targets is alive -ForegroundColor Green }
ELSE{}}

$CleanTargets = Get-Content $AliveServers

##### BEGIN CLEANING #####

FOREACH ($Targets in $CleanTargets){

Invoke-Command -ComputerName $Targets {

#### Variables #### 
 
    $objShell = New-Object -ComObject Shell.Application 
    $objFolder = $objShell.Namespace(0xA) 
    $temp = get-ChildItem "env:\TEMP" 
    $temp2 = $temp.Value 
    $swtools = "c:\SWTOOLS\*" 
    $WinTemp = "c:\Windows\Temp\*" 
     
 
#2# Remove temp files located in "C:\Users\USERNAME\AppData\Local\Temp" 
    write-Host "Removing Junk files in $temp2." -ForegroundColor Magenta  
    Remove-Item -Recurse  "$temp2\*" -Force -Verbose 
 
#3# Remove Item in c:\Swtools folder excluding Checkpoint,landesk,useradmin folder ... remove  -what if it if you want to do it .. 
    # write-Host "Emptying $swtools folder."  
    #Remove-Item -Recurse $swtools   -Verbose -Force -WhatIf 
     
#4#    Empty Recycle Bin # 
    write-Host "Emptying Recycle Bin." -ForegroundColor Cyan  
    $objFolder.items() | %{ remove-item $_.path -Recurse -Confirm:$false} 
     
#5# Remove Windows Temp Directory  
    write-Host "Removing Junk files in $WinTemp." -ForegroundColor Green 
    Remove-Item -Recurse $WinTemp -Force  
     
#6# Running Disk Clean up Tool  
    #write-Host "Finally now , Running Windows disk Clean up Tool" -ForegroundColor Cyan 
    #cleanmgr /sagerun:1 | out-Null  
     
    $([char]7) 
    Sleep 1  
    $([char]7) 
    Sleep 1      
     
    write-Host "Clean Up Task Has Been Completed" -ForegroundColor Yellow  
	} #END INVOKE
} #END FOREACH
	
	Remove-Item $AliveServers
##### End of the Script #####