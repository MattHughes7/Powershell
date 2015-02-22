function Set-ScheduledTask
{
        [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]            

        param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [Alias("HOSTNAME")]
        [String[]]$ComputerName,            

        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [Alias("Run As User")]
        [String[]]$RunAsUser,            

        [Parameter(Mandatory=$true)]
        [String[]]$Password,            

        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [String[]]$TaskName
    )            

    Process
    {
        Write-Verbose  "Updating: $($_.'TaskName')"
        if ($pscmdlet.ShouldProcess($computername, "Updating Task: $TaskName "))
        {
            Write-Verbose "schtasks.exe /change /s $ComputerName /RU $RunAsUser /RP $Password /TN `"$TaskName`""
            $strcmd = schtasks.exe /change /s "$ComputerName" /RU "$RunAsUser" /RP "$Password" /TN "`"$TaskName`"" 2>&1
            Write-Host $strcmd
        }
    }
}


Set-ScheduledTask -Computername T1UTIL46 -TaskName "WHRO - Not A Real Task Nmae" -RunAsUser TOR01\D2LAPPUSER -Password Password