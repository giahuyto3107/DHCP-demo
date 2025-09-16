class RelayAgent {
  final String? macOfClient; // nullable because the list may be empty
  final String relayAgentIp;
  final String remoteDhcpServerIp;

  RelayAgent({
    required this.macOfClient,
    required this.relayAgentIp,
    required this.remoteDhcpServerIp,
  });

  factory RelayAgent.fromJson(Map<String, dynamic> json) {
    final macs = json['macOfClients'] as List<dynamic>;
    return RelayAgent(
      macOfClient: macs.isNotEmpty ? macs.first as String : null,
      relayAgentIp: json['relayAgentIp'],
      remoteDhcpServerIp: json['remoteDhcpServerIp'],
    );
  }
}
