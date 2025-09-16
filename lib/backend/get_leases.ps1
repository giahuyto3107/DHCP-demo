param([string]$ScopeId)

# Get DHCP leases for the given scope
$leases = Get-DhcpServerv4Lease -ScopeId $ScopeId -ErrorAction SilentlyContinue

if (-not $leases) {
    @() | ConvertTo-Json -Depth 3
    exit
}

$result = $leases | Select-Object @{
    Name = 'IPAddress'; Expression = { $_.IPAddress.ToString() }
}, @{
    Name = 'ScopeId'; Expression = { $_.ScopeId.ToString() }
}, @{
    Name = 'ClientId'; Expression = { $_.ClientId }
}, @{
    Name = 'HostName'; Expression = { $_.HostName }
}, @{
    Name = 'AddressState'; Expression = { $_.AddressState }
}, @{
    Name = 'LeaseExpiryTime'; Expression = { $_.LeaseExpiryTime.ToString("yyyy-MM-ddTHH:mm:ss") }
}

$result | ConvertTo-Json -Depth 3