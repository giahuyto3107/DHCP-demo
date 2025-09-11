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
    DateTime? leaseExpiryTime;
    if (json['LeaseExpiryTime'] != null) {
      final match = RegExp(r'\/Date\((\d+)\)\/').firstMatch(json['LeaseExpiryTime']);
      if (match != null) {
        final milliseconds = int.parse(match.group(1)!);
        leaseExpiryTime = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true).toLocal();
      }
    }
    print(leaseExpiryTime);

    return Lease(
      addressState: json['AddressState'] ?? "",
      macAddress: json['ClientId'] ?? "",
      hostName: json['HostName'] ?? "", // keep null if missing
      ipAddress: json['IPAddress']?['IPAddressToString'] ?? "",
      leaseExpiryTime: leaseExpiryTime,
    );
  }
}