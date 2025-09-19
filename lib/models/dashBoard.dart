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
    print('Dashboard JSON input: $json'); // Debug input

    // Parse poolRange string (e.g., "192.168.1.11 - 192.168.1.99")
    int poolSize = json['poolSize']?.toInt() ?? 0; // Use API-provided poolSize
    final poolRangeStr = json['poolRange']?.toString() ?? '';
    String? poolStartStr;
    String? poolEndStr;
    if (poolRangeStr.isNotEmpty) {
      final parts = poolRangeStr.split(' - ');
      if (parts.length == 2) {
        poolStartStr = parts[0]; // e.g., "192.168.1.11"
        poolEndStr = parts[1];   // e.g., "192.168.1.99"
      }
    }

    return DashBoard(
      activeLeases: (json['numberOfLeases'] as num?)?.toInt() ?? 0,
      serverStatus: json['serverStatus']?.toString() ?? 'Unknown',
      activeScope: json['activeScope']?.toString() ?? '',
      gateway: json['gateway']?.toString() ?? '',
      poolSize: poolSize,
    );
  }
}