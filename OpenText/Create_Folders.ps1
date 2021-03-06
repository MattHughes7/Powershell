############# Folder Creation Section #################

$CSVersion = Read-Host -Prompt 'Input Content Version shortname for Folder creation'


New-Item c:\EFS -type directory
New-Item c:\upload -type directory
New-Item c:\data -type directory
New-Item c:\$CSVersion -type directory


net share EFS="c:\EFS"

Write-Host "Press any key to continue ..."

$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

######## User Account  Setup Section #################

$Username = Read-Host -Prompt 'Enter User Account name i.e OTCS'
$Password = Read-Host -Prompt 'Enter User Account password'

NET USER $Username $Password /ADD



# Use this filter so WMI doesn't spend forever talking to domain controllers.
$user = Get-WmiObject Win32_UserAccount -Filter ("Domain='{0}' and Name='{1}'" -f $env:ComputerName,$Username)
$user.PasswordChangeable = $false
$user.PasswordExpires = $false
$user.Put()





