$Alias= (Read-Host "Enter Alias")
$FQDN= (Read-Host "Enter FQDN" )


dnscmd "t1dc02" /recordadd "tor01.desire2learn.d2l" $Alias CNAME $FQDN".tor01.desire2learn.d2l"
