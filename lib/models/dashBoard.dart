class DashBoard {
  int activeLeases;
  String serverStatus;
  String activeScope;
  String gateway;
  int poolSize;

  DashBoard({
    required this.activeLeases,
    required this.serverStatus,
    required this.activeScope,
    required this.gateway,
    required this.poolSize,
  });

  factory DashBoard.fromJson(Map<String, dynamic> json) {
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

    // Calculate poolSize from PoolRange
    int poolSize = (json['PoolSize'] as num?)?.toInt() ?? 0;
    if (['PoolRange'] != null) {
      final RegExp ipRegex = RegExp(r"'IPAddressToString': '(\d+\.\d+\.\d+\.\d+)'");
      final matches = ipRegex.allMatches(json['PoolRange'] as String).toList();
      if (matches.length == 2) {
        final startIp = matches[0].group(1)!;
        final endIp = matches[1].group(1)!;
        final startParts = startIp.split('.').map((e) => int.parse(e)).toList();
        final endParts = endIp.split('.').map((e) => int.parse(e)).toList();
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
    }

    return DashBoard(
      activeLeases: (json['ActiveLeases'] as num?)?.toInt() ?? 0,
      serverStatus: json['ServerStatus']?.toString() ?? 'Unknown',
      activeScope: json['ScopeId'] != null
          ? '${json['ScopeId']}$subnetSuffix'
          : '',
      gateway: json['Gateway']?.toString() ?? '',
      poolSize: poolSize,
    );
  }
}