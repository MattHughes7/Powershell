
  $bigip = (Read-Host "Enter LTM 01-04")
  $user = (Read-Host "Enter User")
  $pass = (Read-Host "Enter Password")
  $poolmember = (Read-Host "Enter Node IP")

if ($bigip -eq "01"){
$bigip = "172.31.61.21"}

elseif ($bigip -eq "02"){
$bigip = "172.31.61.22"}

elseif ($bigip -eq "03"){
$bigip = "172.21.5.31"}

elseif ($bigip -eq "04"){
$bigip = "172.21.5.32"}


else {}

Set-PSDebug -strict;

#-------------------------------------------------------------------------
# function Write-Usage
#-------------------------------------------------------------------------
function Write-Usage()
{
  Write-Host "Usage: PoolLookup.ps1 host uid pwd [poolmember]";
  exit;
}

#-------------------------------------------------------------------------
# function Write-Match
#-------------------------------------------------------------------------
function Write-Match()
{
  param(
    [string]$pool = $null,
    [string]$address = $null,
    [int]$port = $null
  );
  if ( $pool -and $address -and $port )
  {
    $obj = 1 | select PoolMember, Pool
    $obj.PoolMember = "${address}:${port}";
    $obj.Pool = $pool;
    $obj;
  }
}

#-------------------------------------------------------------------------
# Lookup-Pool
#-------------------------------------------------------------------------
function Lookup-Pool()
{
  param([string]$query = $null);

  $addr = "*";
  $port = "*";

  if ( $query )
  {
    $addr = $query;
    $tokens = $query.Split(':');
    if ( $tokens.Length -eq 2 )
    {
      $addr = $tokens[0];
      $port = $tokens[1];
    }
    if ( !$addr ) { $addr = "*"; }
    if ( !$port ) { $port = "*"; }
  }

  $pool_list = (Get-F5.iControl).LocalLBPool.get_list();
  $member_lists = (Get-F5.iControl).LocalLBPool.get_member($pool_list);

  for($i=0; $i-lt$pool_list.Length; $i++)
  {
    $pool = $pool_list[$i];
    $member_list = $member_lists[$i];
    
    for($j=0; $j-lt$member_list.Length; $j++)
    {
      $maddr = $member_list[$j].address;
      $mport = $member_list[$j].port;
      
      if ( !($query) -or ("${maddr}:${mport}" -like "${addr}:${port}") )
      {
        Write-Match -pool $pool -address $maddr -port $mport;
      }
    }
    
  }
}

#-------------------------------------------------------------------------
# Do-Initialize
#-------------------------------------------------------------------------
function Do-Initialize()
{
  if ( (Get-PSSnapin | Where-Object { $_.Name -eq "iControlSnapIn"}) -eq $null )
  {
    Add-PSSnapIn iControlSnapIn
  }
  $success = Initialize-F5.iControl -HostName $bigip -Username $user -Password $pass;
  
  return $success;
}

#-------------------------------------------------------------------------
# Main Application Logic
#-------------------------------------------------------------------------
if ( ($bigip -eq $null) -or ($user -eq $null) -or ($pass -eq $null) )
{
  Write-Usage;
}

if ( Do-Initialize )
{
  if ( $poolmember )
  {
    Lookup-Pool $poolmember;
  }
  else
  {
    Lookup-Pool;
  }
}
else
{
  Write-Error "ERROR: iControl subsystem not initialized"
}
