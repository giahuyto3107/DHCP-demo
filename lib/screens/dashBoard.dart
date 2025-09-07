import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        serverStatusSection(),
        SizedBox(height: 12.0.h),
        connectedClientsSection(),
        SizedBox(height: 12.0.h),
        bottomNavigationTab()
      ],
    );
  }

  Widget serverStatusSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.signal_wifi_statusbar_null_sharp),
                SizedBox(width: 8.w),
                Text(
                  "Server Status",
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
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xff16a249)
                  ),
                  height: 20.h,
                  width: 20.w,
                ),

                SizedBox(width: 8.w),

                Text(
                  "DHCP Server Online",
                  style: TextStyle(
                      fontSize: 16.sp,
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
                    "Active Scope: ",
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xff757c8a),
                        fontWeight: FontWeight.w500
                    )
                ),
                Text(
                  "192.168.1.0/24",
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
                  "192.168.1.1",
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600
                  ),
                )
              ],
            )

          ],
        ),
      ),
    );
  }

  Widget connectedClientsSection() {
    return Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Icon(Icons.wifi),
                    SizedBox(width: 8.w),
                    Text(
                      "Connected Clients",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 16.0.h),

              Text(
                "12",
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Color(0xff1f74f7),
                    fontWeight: FontWeight.w900
                ),
              ),
              SizedBox(height: 8.0.h),
              Text(
                "Active Leases",
                style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xff757c8a),
                    fontWeight: FontWeight.w600
                ),
              ),
              SizedBox(height: 8.0.h),
              Card(
                color: Color(0xfff6f6f8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(15)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
                  child: Text(
                    "12/100 IPs Used",
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  Widget bottomNavigationTab() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          bottomNavigationCell(title: "View Leases", icon: Icons.details),
          bottomNavigationCell(title: "DHCP Process", icon: Icons.play_arrow)
        ],
      ),
    );
  }

  Widget bottomNavigationCell({
    required String title,
    required IconData icon
  }) {
    return Expanded(
      child: Card(
        child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h),
              child: Column(
                children: [
                  Icon(icon),
                  SizedBox(height: 4.0.h),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500
                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}