import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoraFlowScreen extends StatelessWidget {
  const DoraFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  "DHCP Process",
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.0.h),

            Center(
              child: ElevatedButton(
                onPressed: (){},
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow_outlined),
                      SizedBox(width: 8.0.w),
                      Text(
                        "Replay DHCP Process",
                        style: TextStyle(
                          fontWeight: FontWeight.w700
                        ),
                      )
                    ],
                  ),
                )
              ),
            ),
            SizedBox(height: 12.0.h),
            Card(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xffe2eefe),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.tv, color: Color(0xff0874f7),),
                      ),
                    ),
                    SizedBox(height: 6.0.h),
                    Text(
                      "Client",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text("Discover"),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xffe5e7eb),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 40.h,
                              width: 5.w,
                            ),
                          )
                        ],
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xffe3f2ec),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.data_usage, color: Color(0xff16a249),),
                      ),
                    ),
                    SizedBox(height: 6.0.h),
                    Text(
                      "DHCP Server",
                      style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}