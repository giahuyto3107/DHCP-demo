import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9fafb),
      body: SafeArea(
        child: Column(
          children: [
            Text(
              "DHCP Server Manager",
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10.0.h),
            Text(
              "Network Administration",
              style: TextStyle(
                fontSize: 20.sp,
                color: Color(0xff757c8a),
                fontWeight: FontWeight.w400
              ),
            ),
            SizedBox(height: 16.0.h),
            navigationTab(
              titles: [
                'Dashboard', 'Dora Flow', 'Lease List', 'Scope Info'
              ]
            ),
            SizedBox(height: 8.0.h),
            serverStatusSection(),
            SizedBox(height: 12.0.h),
            connectedClientsSection(),
            SizedBox(height: 12.0.h),
            bottomNavigationTab()
          ],
        ),
      ),
    );
  }

  Widget navigationTab({required List<String> titles}) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: List.generate(titles.length, (index) {
          return Expanded(
            child: Card(
              child: Text(
                titles[index],
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          );
        }).toList()
      ),
    );
  }

  Widget serverStatusSection() {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.signal_wifi_statusbar_null_sharp),
              Text(
                "Server Status",
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                ),
              ),
            ],
          ),

          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xff16a249)
                ),
              ),
              Text("DHCP Server Online")
            ],
          ),

          Text("Active Scope: 192.168.1.0/24"),
          Text("Gateway: 192.168.1.1")
        ],
      ),
    );
  }

  Widget connectedClientsSection() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Icon(Icons.wifi),
                Text("Connected Clients")
              ],
            ),
          ),

          Text("12"),
          Text("Active Leases"),
          Card(
            child: Text("12/100 IPs Used"),
          )
        ],
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
}

Widget bottomNavigationCell({
  required String title,
  required IconData icon
}) {
  return Expanded(
    child: Card(
      child: Center(
        child: Column(
          children: [
            Icon(icon),
            Text(title)
          ],
        )
      ),
    ),
  );
}