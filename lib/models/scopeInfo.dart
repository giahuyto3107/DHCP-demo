class ScopeInfo {
  final int activeLeases;
  final String dnsServer;
  final String gateway;
  final String poolStart;
  final String poolEnd;
  final int poolSize;
  final String network;
  final String subnetMask;

  ScopeInfo({
    required this.activeLeases,
    required this.dnsServer,
    required this.gateway,
    required this.poolStart,
    required this.poolEnd,
    required this.poolSize,
    required this.network,
    required this.subnetMask,
  });

  factory ScopeInfo.fromJson(Map<String, dynamic> json) {
    // Extract SubnetMask string
    final subnetMaskStr = json['SubnetMask']?['IPAddressToString']?.toString() ?? "";

    // Calculate subnet suffix if mask exists
    String subnetSuffix = '';
    if (subnetMaskStr.isNotEmpty) {
      final parts = subnetMaskStr.split('.').map(int.parse).toList();
      int bitCount = 0;
      for (var part in parts) {
        int p = part;
        while (p > 0) {
          bitCount += p & 1;
          p >>= 1;
        }
      }
      subnetSuffix = '/$bitCount';
    }

    // Calculate network (fallback if missing)
    String network = json['Network']?.toString() ?? '';
    if (network.isEmpty && json['Gateway'] != null && subnetMaskStr.isNotEmpty) {
      final gatewayParts = (json['Gateway'] as String).split('.').map(int.parse).toList();
      final subnetParts = subnetMaskStr.split('.').map(int.parse).toList();
      network = List.generate(4, (i) => gatewayParts[i] & subnetParts[i]).join('.');
    }

    // Pool start and end (safe fallback to "")
    String poolStart = json['PoolStart']?['IPAddressToString']?.toString() ?? "";
    String poolEnd = json['PoolEnd']?['IPAddressToString']?.toString() ?? "";

    // Calculate pool size (fallback to 0)
    int poolSize = 0;
    if (poolStart.isNotEmpty && poolEnd.isNotEmpty) {
      final startParts = poolStart.split('.').map(int.parse).toList();
      final endParts = poolEnd.split('.').map(int.parse).toList();
      final startInt =
          (startParts[0] << 24) + (startParts[1] << 16) + (startParts[2] << 8) + startParts[3];
      final endInt =
          (endParts[0] << 24) + (endParts[1] << 16) + (endParts[2] << 8) + endParts[3];
      poolSize = endInt - startInt + 1;
    }

    return ScopeInfo(
      activeLeases: (json['ActiveLeases'] as num?)?.toInt() ?? 0,
      dnsServer: json['DnsServer']?.toString() ?? "",
      gateway: json['Gateway']?.toString() ?? "",
      poolStart: poolStart,
      poolEnd: poolEnd,
      poolSize: poolSize,
      network: network.isNotEmpty ? "$network$subnetSuffix" : "",
      subnetMask: subnetMaskStr,
    );
  }
}
