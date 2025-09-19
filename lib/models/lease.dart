class Lease {
  final String addressState;
  final String macAddress; // ClientId mapped here
  final String hostName;  // nullable
  final String ipAddress;
  final DateTime? leaseExpiryTime;

  Lease({
    required this.addressState,
    required this.macAddress,
    required this.hostName,
    required this.ipAddress,
    required this.leaseExpiryTime
  });

  factory Lease.fromJson(Map<String, dynamic> json) {
    print('Lease JSON input: $json'); // Debug input
    DateTime? leaseExpiryTime;
    if (json['LeaseExpiryTime'] != null) {
      final leaseExpiryStr = json['LeaseExpiryTime'].toString();
      try {
        // Try Microsoft JSON date format (e.g., "/Date(1758972413276)/")
        final match = RegExp(r'\/Date\((\d+)\)\/').firstMatch(leaseExpiryStr);
        if (match != null) {
          final milliseconds = int.parse(match.group(1)!);
          leaseExpiryTime = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true).toLocal();
        } else {
          // Try ISO 8601 format (e.g., "2025-09-26T20:26:53")
          leaseExpiryTime = DateTime.parse(leaseExpiryStr).toLocal();
        }
      } catch (e) {
        print('Error parsing LeaseExpiryTime: $e');
      }
    }
    print('Parsed leaseExpiryTime: $leaseExpiryTime');

    return Lease(
      addressState: json['AddressState']?.toString() ?? "",
      macAddress: json['ClientId']?.toString() ?? "",
      hostName: json['HostName']?.toString() ?? "",
      ipAddress: json['IPAddress']?.toString() ?? "", // Fix: Use string directly
      leaseExpiryTime: leaseExpiryTime,
    );
  }
}