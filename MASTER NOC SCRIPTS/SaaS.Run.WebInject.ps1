#Just A Lazy Way to Update the WebInject XML

#USER INPUT
$URL = (Read-Host "Enter Full Url")
#$MATCHCONTENT = (Read-Host "Content to Match? Default Username")
#$ERRORCONTENT = (Read-Host "Content to Error? Default Term Not Found") 
#$REPEAT = (Read-Host "Repeat How Many Times? Default 100")
#$SLEEP = (Read-Host "Sleep Between Tests in Seconds? Default 0")

#DEFAULTS
$MATCHCONTENT = "Username"
$ERRORCONTENT = "Term Not Found"
$REPEAT = [int] "100"
$SLEEP = [int] "0"

#DEFINE FILE LOCATIONS
$WebInjectXMLTemplate = "n:\Toolbox\webinject\D2L.xml.template"
$WebInjectXML = "n:\Toolbox\webinject\D2L.xml"
Remove-Item $WebInjectXMLTemplate -ErrorAction SilentlyContinue
Remove-Item $WebInjectXML -ErrorAction SilentlyContinue

#MAKE STRING
$REPEATstring = '<testcases repeat="' + $REPEAT + '">'
$DESCstring = 'description1="'+ $URL + '"'
$URLstring = 'url="' + $URL + '"'
$MATCHstring = 'verifypositive="' + $MATCHCONTENT + '"'
$ERRORstring = 'verifynegative="' + $ERRORCONTENT + '"'
$SLEEPstring = 'sleep="' + $SLEEP + '"'

#CREATE FILE
Add-Content $WebInjectXMLTemplate $REPEATstring
Add-Content $WebInjectXMLTemplate '<case'
Add-Content $WebInjectXMLTemplate 'id="1"'
Add-Content $WebInjectXMLTemplate $DESCstring
Add-Content $WebInjectXMLTemplate 'method="get"'
Add-Content $WebInjectXMLTemplate $URLstring
Add-Content $WebInjectXMLTemplate 'verifyresponsecode="200"'
Add-Content $WebInjectXMLTemplate $MATCHstring
Add-Content $WebInjectXMLTemplate $ERRORstring 
Add-Content $WebInjectXMLTemplate $SLEEPstring
Add-Content $WebInjectXMLTemplate '/>'
Add-Content $WebInjectXMLTemplate '</testcases>'

Copy-Item $WebInjectXMLTemplate $WebInjectXML

#N:\Toolbox\webinject\D2L.xml
N:\Toolbox\webinject\webinjectgui.exe
Exit
