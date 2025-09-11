class Lease {
  final String addressState;
  final String macAddress; // ClientId mapped here
  final String hostName;  // nullable
  final String ipAddress;

  Lease({
    required this.addressState,
    required this.macAddress,
    required this.hostName,
    required this.ipAddress,
  });

  factory Lease.fromJson(Map<String, dynamic> json) {
    return Lease(
      addressState: json['AddressState'] ?? "",
      macAddress: json['ClientId'] ?? "",
      hostName: json['HostName'] ?? "", // keep null if missing
      ipAddress: json['IPAddress']?['IPAddressToString'] ?? "",
    );
  }
}