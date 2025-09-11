import 'package:demo_dhcp_windows/models/lease.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaseListScreen extends StatefulWidget {
  final Future<List<Lease>> leaseData;
  const LeaseListScreen({super.key, required this.leaseData});

  @override
  State<LeaseListScreen> createState() => _LeaseListScreenState();
}

class _LeaseListScreenState extends State<LeaseListScreen> {
  String formatDuration(Duration? duration) {
    if (duration == null) return 'Unknown';
    if (duration.isNegative) return 'Expired';
    final days = duration.inDays;
    final hours = duration.inHours % 24 + (days*24);
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 16.0.w),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.devices),
                SizedBox(width: 8.0.h),
                Text(
                  "Active Leases",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0.h),
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: widget.leaseData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      // Use snapshot.data instead of dashBoardData
                      final leaseData = snapshot.data!;
                      return Column(
                        children: List.generate(leaseData.length, (index) {
                          return deviceDetailCard(leaseData: leaseData[index]);
                        }).toList(),
                      );
                    } else {
                      return Center(child: Text("No data"));
                    }
                  }
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget deviceDetailCard({required Lease leaseData}) {
    final timeLeft = leaseData.leaseExpiryTime != null
      ? leaseData.leaseExpiryTime!.difference(DateTime.now())
      : null;

    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 12.0.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      getHostDevice(hostName: leaseData.hostName ?? 'Unknown') == "laptop"
                        ? Icons.laptop
                        : getHostDevice(hostName: leaseData.hostName ?? 'Unknown')  == "mobile"
                          ? Icons.phone_android
                          : getHostDevice(hostName: leaseData.hostName ?? 'Unknown')  == "tv"
                            ? Icons.tv
                            : getHostDevice(hostName: leaseData.hostName ?? 'Unknown') == "pc"
                              ? Icons.important_devices
                              : Icons.device_unknown
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      leaseData.ipAddress,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500
                      )
                    )
                  ],
                ),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(30),
                    side: BorderSide(width: 0.75, color: Color(0xff757c8a))
                  ),
                  color: timeLeft != null && timeLeft.isNegative ? Colors.red.shade100 : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 8.0.w),
                    child: Row(
                      children: [
                        Icon(Icons.access_time),
                        SizedBox(width: 4.w),
                        Text(
                          formatDuration(timeLeft),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 16.0.h),
            Row(
              children: [
                Text(
                  "MAC: ",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xff757c8a),
                    fontWeight: FontWeight.w400
                  ),
                ),
                Text(
                  leaseData.macAddress,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xff757c8a),
                    fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0.h),
            Row(
              children: [
                Text(
                  "Host: ",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xff757c8a),
                    fontWeight: FontWeight.w400
                  ),
                ),
                Text(
                  leaseData.hostName == "" ? "Unknown" : leaseData.hostName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xff757c8a),
                    fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }

  String getHostDevice({required String hostName}) {
    hostName = hostName.toLowerCase();
    if (hostName.contains('tv')) {
      return "tv";
    } else if (hostName.contains('laptop')) {
      return "laptop";
    } else if (hostName.contains('mobile')) {
      return "mobile";
    } else if (hostName.contains("pc")) {
      return "pc";
    } else {
      return "Unknown";
    }
  }
}