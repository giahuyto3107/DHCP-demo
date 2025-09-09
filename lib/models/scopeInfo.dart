class ScopeInfo {
  int activeLeases;
  String dnsServer;
  String gateway;
  String poolStart;
  String poolEnd;
  int poolSize;
  String network;
  IPAddress? subnetMask;

  ScopeInfo({
    required this.activeLeases,
    required this.dnsServer,
    required this.gateway,
    required this.poolStart,
    required this.poolEnd,
    required this.poolSize,
    required this.network,
    this.subnetMask,
  });

  factory ScopeInfo.fromJson(Map<String, dynamic> json) {
    // Calculate subnet suffix from SubnetMask
    String subnetSuffix = '';
    if (json['SubnetMask']?['IPAddressToString'] != null) {
      final subnetMask = json['SubnetMask']['IPAddressToString'] as String;
      final parts = subnetMask.split('.').map((e) => int.parse(e)).toList();
      int bitCount = 0;
      for (var part in parts) {
        int partInt = part; // Ensure part is int
        while (partInt > 0) {
          bitCount += partInt & 1; // Bitwise AND
          partInt >>= 1; // Right shift
        }
      }
      subnetSuffix = '/$bitCount';
    }

    // Calculate network if not provided
    String network = json['Network']?.toString() ?? '';
    if (network.isEmpty && json['Gateway'] != null && json['SubnetMask'] != null) {
      final gatewayParts = (json['Gateway'] as String).split('.').map((e) => int.parse(e)).toList();
      final subnetParts = (json['SubnetMask']['IPAddressToString'] as String)
          .split('.')
          .map((e) => int.parse(e))
          .toList();
      network = List.generate(4, (i) => gatewayParts[i] & subnetParts[i]).join('.');
    }

    // Calculate poolSize from PoolStart and PoolEnd
    int poolSize = (json['PoolSize'] as num?)?.toInt() ?? 0;
    String poolStart = '';
    String poolEnd = '';
    if (json['PoolStart']?['IPAddressToString'] != null && json['PoolEnd']?['IPAddressToString'] != null) {
      poolStart = json['PoolStart']['IPAddressToString'] as String;
      poolEnd = json['PoolEnd']['IPAddressToString'] as String;
      final startParts = poolStart.split('.').map((e) => int.parse(e)).toList();
      final endParts = poolEnd.split('.').map((e) => int.parse(e)).toList();
      final startInt = (startParts[0] << 24) +
          (startParts[1] << 16) +
          (startParts[2] << 8) +
          startParts[3];
      final endInt = (endParts[0] << 24) +
          (endParts[1] << 16) +
          (endParts[2] << 8) +
          endParts[3];
      poolSize = endInt - startInt + 1; // Inclusive
    }

    return ScopeInfo(
      activeLeases: (json['ActiveLeases'] as num?)?.toInt() ?? 0, // Default to 0 since not in JSON
      dnsServer: json['DnsServer'] != null ? json['DnsServer'].toString() : '',
      gateway: json['Gateway']?.toString() ?? '',
      poolStart: poolStart,
      poolEnd: poolEnd,
      poolSize: poolSize,
      network: '$network$subnetSuffix',
      subnetMask: json['SubnetMask'] != null
          ? IPAddress.fromJson(json['SubnetMask'])
          : null,
    );
  }
}

class IPAddress {
  String ipAddressToString;
  int address;
  int addressFamily;

  IPAddress({
    required this.ipAddressToString,
    required this.address,
    required this.addressFamily,
  });

  factory IPAddress.fromJson(Map<String, dynamic> json) {
    return IPAddress(
      ipAddressToString: json['IPAddressToString'].toString(),
      address: (json['Address'] as num).toInt(),
      addressFamily: (json['AddressFamily'] as num).toInt(),
    );
  }
}