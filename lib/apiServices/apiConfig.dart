// --- Cấu hình API Base URL ---
class ApiConfig {
  static String _ipAddress = "";
  static String _port = "";
  static String _baseUrl = 'http://';

  static String get baseUrl => _baseUrl;
  static String get ipAddress => _ipAddress;
  static String get port => _port;

  static void setIpAddress(String ipAddress) {
    _ipAddress = ipAddress;
  }

  static void setPort(String port) {
    _port = port;
  }

  static void setBaseUrl() {
    _baseUrl = 'http://$_ipAddress:$_port';
  }
}