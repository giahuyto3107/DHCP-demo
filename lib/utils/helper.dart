class Helper {
  int calculateSubnetSuffix(String subnetMask) {
    final parts = subnetMask.split('.').map(int.parse).toList();
    int bitCount = 0;
    for (var part in parts) {
      while (part > 0) {
        bitCount += part & 1;
        part >>= 1;
      }
    }
    return bitCount;
  }
}

