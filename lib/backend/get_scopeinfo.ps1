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

$result = [PSCustomObject]@{
    Network    = $scope.SubnetAddress
    SubnetMask = $scope.SubnetMask
    Gateway    = $gateway -join ", "
    DnsServer  = $dns -join ", "
    PoolStart  = $scope.StartRange
    PoolEnd    = $scope.EndRange
    PoolSize   = ($scope.EndRange.Address - $scope.StartRange.Address + 1)
}

$result | ConvertTo-Json -Depth 3
