import 'package:demo_dhcp_windows/apiServices/apiServices.dart';
import 'package:demo_dhcp_windows/models/dashBoard.dart';
import 'package:demo_dhcp_windows/models/scopeInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ScopeInfoScreen extends StatefulWidget {
  final Future<ScopeInfo> scopeInfoData;
  final Future<DashBoard> dashBoardData;

  const ScopeInfoScreen({
    super.key,
    required this.scopeInfoData,
    required this.dashBoardData
  });

  @override
  State<ScopeInfoScreen> createState() => _ScopeInfoScreenState();
}

class _ScopeInfoScreenState extends State<ScopeInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
        child: FutureBuilder(
          future: Future.wait([widget.scopeInfoData, widget.dashBoardData]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final scopeInfoData = snapshot.data![0] as ScopeInfo;
              final dashboardData = snapshot.data![1] as DashBoard;
              final progress = dashboardData.activeLeases / scopeInfoData.poolSize;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
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
                        scopeInfoData.network,
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
                        scopeInfoData.subnetMask?.ipAddressToString ?? '',
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
                        scopeInfoData.gateway,
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
                        scopeInfoData.dnsServer,
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
                        "${scopeInfoData.poolStart} - ${scopeInfoData.poolEnd}",
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
                        "${dashboardData.activeLeases}/${scopeInfoData.poolSize} (${(progress*100).round().toInt()}%)",
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
                      value: progress,
                      backgroundColor: Color(0xfff3f4f6),
                      color: Color(0xff2e89f9),
                      borderRadius: BorderRadius.circular(30),
                      minHeight: 8.h,
                    ),
                  )
                ],
              );
            } else {
              return Center(child: Text('No data'));
            }
          }
        ),
      ),
    );
  }
}