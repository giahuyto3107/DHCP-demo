import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScopeInfoScreen extends StatelessWidget {
  final double connectedClient = 12;
  final int maximumCapacity = 100;
  final String network = "192.168.1.0/24";
  final String subnetMask = "255.255.255.0";
  final String gateway = "192.168.1.1";
  final String dnsServer = "8.8.8.8";
  final String dhcpPoolStart = "192.168.1.100";
  final String dhcpPoolEnd = "192.168.1.199";

  const ScopeInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double progress = connectedClient/maximumCapacity;
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon(Icons.signal_wifi_statusbar_null_sharp),
                // SizedBox(width: 8.w),
                Text(
                  "IP Range Configuration",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.0.h),
            Row(
              children: [
                Text(
                  "Network: ",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xff757c8a),
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  network,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.0.h),

            Row(
              children: [
                Text(
                  "Subnet Mask: ",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xff757c8a),
                    fontWeight: FontWeight.w500
                  )
                ),
                Text(
                  subnetMask,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),

            SizedBox(height: 12.0.h),

            Row(
              children: [
                Text(
                  "Gateway: ",
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0xff757c8a),
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  gateway,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),

            SizedBox(height: 12.0.h),

            Row(
              children: [
                Text(
                  "DNS Server: ",
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0xff757c8a),
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  dnsServer,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  ),
                )
              ],
            ),

            SizedBox(height: 12.0.h),

            Row(
              children: [
                Text(
                  "DHCP Pool Range: ",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  "$dhcpPoolStart - $dhcpPoolEnd",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xff757c8a),
                    fontWeight: FontWeight.w500
                  ),
                )
              ],
            ),

            SizedBox(height: 12.0.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "IP Address Utilization: ",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400
                  ),
                ),
                Text(
                  "${(progress*100).toInt()}/100 (${(progress*100).toInt()}%)",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  )
                )
              ],
            ),
            SizedBox(height: 8.0.h),
            SizedBox(
              width: double.infinity,
              child: LinearProgressIndicator(
                value: 0.12,
                backgroundColor: Color(0xfff3f4f6),
                color: Color(0xff2e89f9),
                borderRadius: BorderRadius.circular(30),
                minHeight: 8.h,
              ),
            )
          ],
        ),
      ),
    );
  }
}