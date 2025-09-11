param([string]$ScopeId)

# Get DHCP leases for the given scope
$leases = Get-DhcpServerv4Lease -ScopeId $ScopeId -ErrorAction SilentlyContinue

if (-not $leases) {
    @() | ConvertTo-Json -Depth 3
    exit
}

$result = $leases | Select-Object `
    IPAddress,
    ScopeId,
    ClientId,
    HostName,
    AddressState

$result | ConvertTo-Json -Depth 3
