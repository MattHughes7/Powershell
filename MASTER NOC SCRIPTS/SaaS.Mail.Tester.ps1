function sendMail{
 
     Write-Host "Sending Email"
  $Date.Clear
  $Date = Get-Date
     #SMTP server name
     $smtpServer = "HFSCOMRPT01"
 
     #Creating a Mail object
     $msg = new-object Net.Mail.MailMessage
 
     #Creating SMTP server object
     $smtp = new-object Net.Mail.SmtpClient($smtpServer)
 
     #Email structure 
     $msg.From = "d2lnoc@desire2learn.com"
     $msg.ReplyTo = "d2lnoc@desire2learn.com"
     $msg.To.Add("d2lnoc@desire2learn.com")
     $msg.subject = "Aine Blade Test"
     $msg.body = $Date
 
     #Sending email 
     $smtp.Send($msg)
  
}
 
#Calling function


While($Count -ne 4){

$SleepTime = (Get-Random (1..5))
Write-Host Sleeping $SleepTime -ForegroundColor Green 
$BeforeSend = (Get-Date)
$Date.Clear
sendMail

$AfterSend = (Get-Date)
$TimeDiff = ($AfterSend - $BeforeSend)
Write-Host Time Diff $TimeDiff

Sleep $SleepTime
$Count++
Write-Host $Count Passes so far -ForegroundColor Green -BackgroundColor Blue
}

