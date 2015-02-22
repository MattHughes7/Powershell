$filestomoves = Get-Content D:\Shared\Star_delimited\03test.txt


Foreach ( $filestomove in $filestomoves){
copy-item $filestomove "x:\" }

out-file D:\Shared\Star_delimited\03results.txt
