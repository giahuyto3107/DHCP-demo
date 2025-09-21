import 'package:flutter/material.dart';

class Helper {
  static final ipAddressRegex = RegExp(r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$");
  static final portRegex = RegExp(r'^\d+$');

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

  static showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, bgColor: Colors.green);
  }

  static showWarningSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, bgColor: Colors.orange);
  }

  static showSnackBar(
      BuildContext context,
      String message, {
        Color bgColor = Colors.red,
        Duration duration = const Duration(seconds: 2),
      }) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: bgColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    ScaffoldMessenger.of(
      context,
    ).clearSnackBars(); // Xóa các snack cũ (nếu cần)
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

