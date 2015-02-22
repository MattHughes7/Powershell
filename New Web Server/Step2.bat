@ECHO OFF
ECHO Enter Domain Join Password 
SET /P password=

netdom.exe join /d:tor01.desire2learn.d2l %COMPUTERNAME% /userd:tor01\svc_join_domain /Passwordd:%password%

slmgr.vbs -ipk "H69CC-4CXG6-GR3T2-YHTYW-HRTPR"

slmgr.vbs -ato

call step3.bat