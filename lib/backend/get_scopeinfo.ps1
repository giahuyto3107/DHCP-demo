param([string]$ScopeId)

# Get scope info
$scope = Get-DhcpServerv4Scope -ScopeId $ScopeId -ErrorAction SilentlyContinue
$options = Get-DhcpServerv4OptionValue -ScopeId $ScopeId -ErrorAction SilentlyContinue

if (-not $scope) {
    @{} | ConvertTo-Json -Depth 3
    exit
}

$gateway = ($options | Where-Object { $_.OptionId -eq 3 }).Value
$dns = ($options | Where-Object { $_.OptionId -eq 6 }).Value

# Calculate CIDR prefix length
$maskOctets = $scope.SubnetMask -split '\.'
$prefixLength = 0
foreach ($octet in $maskOctets) {
    $binary = [convert]::ToString([int]$octet, 2).PadLeft(8, '0')
    $prefixLength += ($binary.ToCharArray() | Where-Object { $_ -eq '1' }).Count
}
$networkCidr = $scope.SubnetAddress + "/$prefixLength"

$poolRange = "$($scope.StartRange) - $($scope.EndRange)"

# Function to convert IP to UInt32 (handles endianness)
function IpToUInt32 {
    param([System.Net.IPAddress]$ip)
    $bytes = $ip.GetAddressBytes()
    if ([BitConverter]::IsLittleEndian) {
        [Array]::Reverse($bytes)
    }
    return [BitConverter]::ToUInt32($bytes, 0)
}

$startInt = IpToUInt32 $scope.StartRange
$endInt = IpToUInt32 $scope.EndRange
$poolSize = $endInt - $startInt + 1

$result = [PSCustomObject]@{
    NetworkCidr = $networkCidr  # e.g., "192.168.2.0/24"
    Network     = $scope.SubnetAddress
    SubnetMask  = $scope.SubnetMask
    Gateway     = $gateway -join ", "
    DnsServer   = $dns -join ", "
    PoolRange   = $poolRange    # e.g., "192.168.2.100 - 192.168.2.200"
    PoolStart   = $scope.StartRange
    PoolEnd     = $scope.EndRange
    PoolSize    = $poolSize
    # NumberOfLeases added in Python
}

$result | ConvertTo-Json -Depth 3