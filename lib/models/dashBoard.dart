class DashBoard {
  final int activeLeases;
  final String serverStatus;
  final String activeScope;
  final String gateway;
  final int poolSize;

  DashBoard({
    required this.activeLeases,
    required this.serverStatus,
    required this.activeScope,
    required this.gateway,
    required this.poolSize,
  });

  factory DashBoard.fromJson(Map<String, dynamic> json) {
    // Get scope info
    final scope = json['scope'] ?? {};

    // Subnet suffix
    String subnetSuffix = '';
    final subnetMaskStr = scope['SubnetMask']?['IPAddressToString'] as String?;
    if (subnetMaskStr != null) {
      final parts = subnetMaskStr.split('.').map(int.parse).toList();
      int bitCount = 0;
      for (final part in parts) {
        int value = part;
        while (value > 0) {
          bitCount += value & 1;
          value >>= 1;
        }
      }
      subnetSuffix = '/$bitCount';
    }

    // Pool size calculation
    int poolSize = 0;
    final poolStartStr = scope['PoolStart']?['IPAddressToString'] as String?;
    final poolEndStr = scope['PoolEnd']?['IPAddressToString'] as String?;

    if (poolStartStr != null && poolEndStr != null) {
      List<int> ipToParts(String ip) => ip.split('.').map(int.parse).toList();
      int toInt(List<int> parts) =>
          (parts[0] << 24) + (parts[1] << 16) + (parts[2] << 8) + parts[3];

      final startInt = toInt(ipToParts(poolStartStr));
      final endInt = toInt(ipToParts(poolEndStr));
      poolSize = endInt - startInt + 1;
    }

    // Active scope (use network + subnet suffix)
    String activeScope = '';
    if (scope['Gateway'] != null && subnetSuffix.isNotEmpty) {
      activeScope = '${scope['Gateway']}$subnetSuffix';
    }

    return DashBoard(
      activeLeases: (json['leases']?['activeCount'] as num?)?.toInt() ?? 0,
      serverStatus: json['serverStatus']?.toString() ?? 'Unknown',
      activeScope: activeScope,
      gateway: scope['Gateway']?.toString() ?? '',
      poolSize: poolSize,
    );
  }
}
