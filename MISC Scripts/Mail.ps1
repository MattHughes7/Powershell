function sendMail{
 
     Write-Host "Sending Email"
  $Date = Get-Date
     #SMTP server name
     $smtpServer = "mailgw.tor01.desire2learn.d2l"
 
     #Creating a Mail object
     $msg = new-object Net.Mail.MailMessage
 
     #Creating SMTP server object
     $smtp = new-object Net.Mail.SmtpClient($smtpServer)
 
     #Email structure 
     $msg.From = "ScomAlerts2012@desire2learn.Com"
     $msg.ReplyTo = "ScomAlerts2012@desire2learn.Com"
     $msg.To.Add("d2lnoc@desire2learn.com")
     $msg.subject = "New Mail Gateway"
     $msg.body = $Date
 
     #Sending email 
     $smtp.Send($msg)
  
}
 
#Calling function
sendMail


#HFSCOMRPT01.tor01.DESIRE2LEARN.D2L

function sendMail{
 
     Write-Host "Sending Email"
 $Date = Get-Date
     #SMTP server name
     $smtpServer = "HFSCOMRPT01.tor01.DESIRE2LEARN.D2L"
 
     #Creating a Mail object
     $msg = new-object Net.Mail.MailMessage
 
     #Creating SMTP server object
     $smtp = new-object Net.Mail.SmtpClient($smtpServer)
 
     #Email structure 
     $msg.From = "ScomAlerts2012@desire2learn.Com"
     $msg.ReplyTo = "ScomAlerts2012@desire2learn.Com"
     $msg.To.Add("d2lnoc@desire2learn.com")
     $msg.subject = "SCOMS MailGateway"
     $msg.body = $Date
 
     #Sending email 
     $smtp.Send($msg)
  
}
 
#Calling function
sendMail
