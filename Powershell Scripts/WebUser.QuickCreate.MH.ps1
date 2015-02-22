$Webuser = (Read-Host "Enter Webuser name")

Import-Module ActiveDirectory
New-ADUser -Server "T1DC04.tor01.desire2learn.d2l" -name $webuser -UserPrincipalName "$webuser@TOR01.desire2learn.d2l"  -SamAccountName $Webuser  -DisplayName $Webuser  -Path "OU=D2LAppusers,OU=TOR01,DC=TOR01,DC=desire2learn,DC=d2l" -PasswordNeverExpires $true -CannotChangePassword $true -AccountPassword (Read-Host -AsSecureString "AccountPassword") -PassThru | Enable-ADAccount
Add-ADGroupMember -Identity "D2LWebUsers" -Member $Webuser