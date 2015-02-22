SET /P PCNAME=Please enter the computer name:
wmic computersystem where name="%COMPUTERNAME%" call rename name="%PCNAME%"



shutdown /r /t 5 /d p:4:1

