import 'dart:convert';
import 'package:demo_dhcp_windows/apiServices/apiConfig.dart';
import 'package:demo_dhcp_windows/models/dashBoard.dart';
import 'package:demo_dhcp_windows/models/relayAgent.dart';
import 'package:demo_dhcp_windows/models/scopeInfo.dart';
import 'package:http/http.dart' as http;

import 'package:demo_dhcp_windows/models/lease.dart';

class ApiService {
  Future<DashBoard> fetchDashBoard() async{
    final url = Uri.parse('${ApiConfig.baseUrl}/api/dashboard');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final dynamic data = json.decode(response.body);
        return DashBoard.fromJson(data);
      } catch (e) {
        print("Error parsing JSON: $e");
        throw AppErrorException(
          "fetchDashBoard",
          "500:Mobile_DP",
          "Lỗi dữ liệu khi tải danh sách dashboard.",
        );
      }
    } else {
      throw AppErrorException(
        "fetchDashBoard",
        "404:Mobile_DP",
        "Địa chỉ truy cập không tồn tại.",
      );
    }
  }

  Future<List<Lease>> fetchLeases() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/leases');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Lease.fromJson(item)).toList();
      } catch (e) {
        print("Error parsing JSON: $e");
        throw AppErrorException(
          "fetchLeases",
          "500:Mobile_DP",
          "Lỗi dữ liệu khi tải danh sách leases.",
        );
      }

    } else {
      throw AppErrorException(
        "fetchLeases",
        "404:Mobile_DP",
        "Địa chỉ truy cập không tồn tại.",
      );
    }
  }

  Future <ScopeInfo> fetchScopeInfo() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/scopeinfo');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final dynamic data = json.decode(response.body);
        return ScopeInfo.fromJson(data);
      } catch (e) {
        print("Error parsing JSON: $e");
        throw AppErrorException(
          "fetchScopeInfo",
          "500:Mobile_DP",
          "Lỗi dữ liệu khi tải danh sách scopeInfo.",
        );
      }
    } else {
      throw AppErrorException(
        "fetchScopeInfo",
        "404:Mobile_DP",
        "Địa chỉ truy cập không tồn tại.",
      );
    }
  }

  Future <RelayAgent> fetchRelayAgent() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/relay');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      try {
        final dynamic data = json.decode(response.body);
        return RelayAgent.fromJson(data);
      } catch (e) {
        print("Error parsing JSON: $e");
        throw AppErrorException(
          "fetchRelayAgent",
          "500:Mobile_DP",
          "Lỗi dữ liệu khi tải danh sách scopeInfo.",
        );
      }
    } else {
      throw AppErrorException(
        "fetchRelayAgent",
        "404:Mobile_DP",
        "Địa chỉ truy cập không tồn tại.",
      );
    }
  }
}

class AppErrorException implements Exception {
  late final String methodName;
  late final String statusCode;
  late final String message;

  // AppErrorException2(this.methodName, this.statusCode, this.message );
  AppErrorException(method, code, mess) {
    methodName = method;
    statusCode = code;
    message = "$mess (Lỗi: $code)";
  }

  String toString() {
    return "MethodName: $methodName - StatusCode: $statusCode -  Message: $message";
  }
}