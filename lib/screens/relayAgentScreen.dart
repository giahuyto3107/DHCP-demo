import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RelayAgent extends StatefulWidget {
  @override
  State<RelayAgent> createState() => _RelayAgentState();
}

class _RelayAgentState extends State<RelayAgent> {
  final int itemCount = 7;
  final String macClient = "abc:def";
  final dhcpServerIp = "abc";
  List<bool> isActiveList = [];
  final List<String> colorList = ["0xff558dd2", "0xfff1ad37", "0xff4494f6", "0xff7dc198", "0xff000000"];

  @override
  void initState() {
    super.initState();
    isActiveList = List.generate(itemCount, (_) => false);
  }

  void startAnimation() async {
    for (int i = 0; i < itemCount; i++) {
      setState(() {
        isActiveList[i] = true;
      });
      await Future.delayed(Duration(seconds: 1));
    }

    if (isActiveList.every((active) => active)) {
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        isActiveList = List.generate(itemCount, (_) => false);
      });
    }
  }

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
                Text(
                  "DHCP Relay Agent",
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
                onPressed: startAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow_outlined),
                      SizedBox(width: 8.0.w),
                      Text(
                        "Simulate Relay",
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
            Expanded(
              child: Card(
                color: Color(0xfffafcff),
                elevation: 0,
                child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 16.0.w),
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
                              fontSize: 12.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          SizedBox(height: 4.0.h),
                          Text(
                            "MAC: $macClient",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Color(0xff969ca7),
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(height: 16.0.h),

                          // Animation section
                          animationSection(),

                          SizedBox(height: 16.0.h),

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
                              fontSize: 12.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500
                            ),
                          ),

                          SizedBox(height: 4.0.h),
                          Text(
                            dhcpServerIp,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Color(0xff969ca7),
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget animationSection() {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            singleAnimationRow(
              title: "Discover",
              description: "Client broadcasts DHCP Discover",
              index: 0
            ),
            SizedBox(height: 8.0.h),
            singleAnimationRow(
              title: "Forward ",
              description: "Client broadcasts DHCP Discover",
              index: 1
            ),
            SizedBox(height: 8.0.h),
            singleAnimationRow(
              title: "Offer ",
              description: "Server responds with IP offer",
              index: 2
            ),
            SizedBox(height: 8.0.h),
            singleAnimationRow(
              title: "Forward Offer",
              description: "Client broadcasts DHCP Discover",
              index: 3
            ),
            SizedBox(height: 8.0.h),
            singleAnimationRow(
              title: "Request",
              description: "Client broadcasts DHCP Discover",
              index: 4
            ),
            SizedBox(height: 8.0.h),
            singleAnimationRow(
              title: "Forward Request",
              description: "Client requests the offered IP",
              index: 5
            ),
        
            SizedBox(height: 8.0.h),
            singleAnimationRow(
              title: "Acknowledge",
              description: "Server confirms IP assignment",
              index: 6
            ),
          ],
        ),
      ),
    );
  }

  Widget singleAnimationRow({
    required String title,
    required String description,
    required int index,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isActiveList[index]
                    ? Color(int.parse(colorList[index % colorList.length]))
                    : Color(0xffb1b2b8)
                ),
              ),
              Text(
                isActiveList[index] ? description : "",
                style: TextStyle(
                    fontSize: 8.0.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffc3c6cc)
                ),
              )
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isActiveList[index] ? Color(0xff2382f7) : Color(0xffe5e7eb),
            borderRadius: BorderRadius.circular(15),
          ),
          height: 30.h,
          width: 5.w,
        ),
      ],
    );
  }
}