@ECHO OFF
ECHO Enter IP Address 
SET /P ipaddr=

netsh interface ip set address name="Local Area Connection" static %ipaddr% 255.0.0.0 10.1.1.1

call step2.bat