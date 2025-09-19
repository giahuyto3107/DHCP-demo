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
    print('ScopeInfo JSON input: $json'); // Debug input

    // Extract fields with fallbacks
    final subnetMaskStr = json['SubnetMask']?['IPAddressToString']?.toString() ?? "";
    final poolStartStr = json['PoolStart']?['IPAddressToString']?.toString() ?? "";
    final poolEndStr = json['PoolEnd']?['IPAddressToString']?.toString() ?? "";

    // Use API-provided poolSize
    final poolSize = (json['PoolSize'] as num?)?.toInt() ?? 0;

    // Calculate network and subnet suffix
    String network = json['Network']?.toString() ?? "";
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
    if (network.isEmpty && json['Gateway'] != null && subnetMaskStr.isNotEmpty) {
      final gatewayParts = (json['Gateway'] as String).split('.').map(int.parse).toList();
      final subnetParts = subnetMaskStr.split('.').map(int.parse).toList();
      network = List.generate(4, (i) => gatewayParts[i] & subnetParts[i]).join('.');
    }
    if (network.isNotEmpty && subnetSuffix.isNotEmpty) {
      network = "$network$subnetSuffix";
    } else if (json['NetworkCidr'] != null) {
      network = json['NetworkCidr'].toString(); // Fallback to NetworkCidr if available
    }

    return ScopeInfo(
      activeLeases: (json['NumberOfLeases'] as num?)?.toInt() ?? 0, // Changed to NumberOfLeases
      dnsServer: json['DnsServer']?.toString() ?? "",
      gateway: json['Gateway']?.toString() ?? "",
      poolStart: poolStartStr,
      poolEnd: poolEndStr,
      poolSize: poolSize,
      network: network,
      subnetMask: subnetMaskStr,
    );
  }
}