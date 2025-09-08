import 'package:demo_dhcp_windows/models/connectedDeviceDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaseListScreen extends StatelessWidget {
  final List<ConnectedDeviceDetail> connectedDeviceDetails = [];
  ConnectedDeviceDetail device1 = ConnectedDeviceDetail(
    deviceType: "Laptop",
    host: "laptop-john",
    ip: "192.168.1.101",
    mac: "AA:BB:CC:DD:EE:01"
  );
  ConnectedDeviceDetail device2 = ConnectedDeviceDetail(
      deviceType: "tv",
      host: "laptop-john",
      ip: "192.168.1.101",
      mac: "AA:BB:CC:DD:EE:01"
  );
  ConnectedDeviceDetail device3 = ConnectedDeviceDetail(
      deviceType: "mobile",
      host: "laptop-john",
      ip: "192.168.1.101",
      mac: "AA:BB:CC:DD:EE:01"
  );
  LeaseListScreen({super.key});

  void addConnectedDeviceDetail(ConnectedDeviceDetail connectedDeviceDetail) {
    connectedDeviceDetails.add(connectedDeviceDetail);
  }

  @override
  Widget build(BuildContext context) {
    addConnectedDeviceDetail(device1);
    addConnectedDeviceDetail(device2);
    addConnectedDeviceDetail(device3);
    addConnectedDeviceDetail(device1);
    addConnectedDeviceDetail(device2);
    return Expanded(
      child: Card(
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
                  child: Column(
                    children: List.generate(connectedDeviceDetails.length, (index) {
                    return deviceDetailCard(connectedDeviceDetails[index]);
                  }).toList(),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget deviceDetailCard(ConnectedDeviceDetail connectedDeviceDetail) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 12.0.w),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  connectedDeviceDetail.deviceType == "laptop"
                    ? Icons.laptop
                    : connectedDeviceDetail.deviceType == "mobile"
                      ? Icons.phone_android
                      : connectedDeviceDetail.deviceType == "tv"
                        ? Icons.tv : Icons.device_unknown
                ),
                SizedBox(width: 6.w),
                Text(
                  connectedDeviceDetail.ip,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  )
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
                  connectedDeviceDetail.mac,
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
                  connectedDeviceDetail.host,
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
}