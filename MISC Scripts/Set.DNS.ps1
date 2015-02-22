$servers = ("t1web55b","t1web55c","t1web55d","t1web55e","t1web55f","t1web55g","t1web55h","t1web55i")

foreach($server in $servers)

{

    Write-Host "Connect to $server..."

    $nics = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $server -ErrorAction Inquire | Where{$_.IPEnabled -eq "TRUE"}

    $newDNS = "172.21.3.33","172.19.3.7"

    foreach($nic in $nics)

    {

        Write-Host "`tExisting DNS Servers " $nic.DNSServerSearchOrder

        $x = $nic.SetDNSServerSearchOrder($newDNS)

        if($x.ReturnValue -eq 0)

        {

            Write-Host "`tSuccessfully Changed DNS Servers on " $server

        }

        else

        {

            Write-Host "`tFailed to Change DNS Servers on " $server

        }

    }

}