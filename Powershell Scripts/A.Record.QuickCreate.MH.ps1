$URL= (Read-Host "Enter URL")
$ipadd= (Read-Host "Enter Node IP" )

dnscmd "hfdns01" /recordadd "desire2learn.com" $URL A $ipadd  