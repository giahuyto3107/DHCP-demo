class Lease {
  String addressState;
  String macAddress; // Use a clear name
  String? hostName;
  String ipAddress;

  Lease({
    required this.addressState,
    required this.macAddress,
    this.hostName,
    required this.ipAddress,
  });

  factory Lease.fromJson(Map<String, dynamic> json) {
    return Lease(
      addressState: json['AddressState'],
      macAddress: json['ClientId'], // Map ClientId to macAddress
      hostName: json['HostName'],
      ipAddress: json['IPAddress']['IPAddressToString'],
    );
  }
}