param([string]$ScopeId)

# Get DHCP leases for the given scope
$leases = Get-DhcpServerv4Lease -ScopeId $ScopeId -ErrorAction SilentlyContinue

if (-not $leases) {
    @() | ConvertTo-Json -Depth 3
    exit
}

$result = @($leases | Select-Object @{
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
    Name = 'LeaseExpiryTime'; Expression = {
        # Convert to milliseconds since Unix epoch (1970-01-01 00:00:00 UTC)
        $epoch = [DateTime]::ParseExact("1970-01-01T00:00:00Z", "yyyy-MM-ddTHH:mm:ssZ", $null)
        $milliseconds = [int64](($_.LeaseExpiryTime.ToUniversalTime() - $epoch).TotalMilliseconds)
        "/Date($milliseconds)/"
    }
})

$result | ConvertTo-Json -Depth 3