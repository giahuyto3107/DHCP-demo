import 'package:demo_dhcp_windows/models/dashBoard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashBoardScreen extends StatefulWidget {
  final Future<DashBoard> dashBoardData;
  const DashBoardScreen({super.key, required this.dashBoardData});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: widget.dashBoardData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Use snapshot.data instead of dashBoardData
            final dashBoardData = snapshot.data!;
            return Column(
              children: [
                serverStatusSection(dashBoardData: dashBoardData), // Pass data if needed
                SizedBox(height: 12.0.h),
                Expanded(child: connectedClientsSection(dashBoardData: dashBoardData)), // Pass data if needed
              ],
            );
          }
          return Center(child: Text('No data'));
        }
      ),
    );
  }

  Widget serverStatusSection({required DashBoard dashBoardData}) {
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
                    color: dashBoardData.serverStatus.toLowerCase() == "offline"
                      ? Colors.red
                      : Color(0xff16a249)
                  ),
                  height: 20.h,
                  width: 20.w,
                ),

                SizedBox(width: 8.w),

                Text(
                  "DHCP Server ${dashBoardData.serverStatus}",
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
                  dashBoardData.activeScope,
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
                  dashBoardData.gateway,
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

  Widget connectedClientsSection({required DashBoard dashBoardData}) {
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

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dashBoardData.activeLeases.toString(),
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
                            "${dashBoardData.activeLeases}/${dashBoardData.poolSize} IPs Used",
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