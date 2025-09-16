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
    // Pool size calculation
    int poolSize = 0;
    final poolStartStr = json['poolRange']?['start'] as String?;
    final poolEndStr = json['poolRange']?['end'] as String?;

    if (poolStartStr != null && poolEndStr != null) {
      List<int> ipToParts(String ip) => ip.split('.').map(int.parse).toList();
      int toInt(List<int> parts) =>
          (parts[0] << 24) + (parts[1] << 16) + (parts[2] << 8) + parts[3];

      final startInt = toInt(ipToParts(poolStartStr));
      final endInt = toInt(ipToParts(poolEndStr));
      poolSize = endInt - startInt + 1;
    }

    return DashBoard(
      activeLeases: (json['numberOfLeases'] as num?)?.toInt() ?? 0,
      serverStatus: json['serverStatus']?.toString() ?? 'Unknown',
      activeScope: json['activeScope'],
      gateway: json['gateway']?.toString() ?? '',
      poolSize: poolSize,
    );
  }
}
