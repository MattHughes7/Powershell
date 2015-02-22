
$SendtoAddress = (Read-Host "Send Email To")
$FromAddress = (Read-Host "From")
$Subject = (Read-Host "Subject")
$SMTP = "172.21.1.93"
$Body = (Read-Host "Message")
#$file = (Read-Host "Location of Attachment")

    
    Send-MailMessage -To $sendtoaddress -From $fromaddress -Subject $subject -SmtpServer $smtp -Body $body #-attachment $file
    
