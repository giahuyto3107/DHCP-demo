import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoraFlowScreen extends StatefulWidget {
  const DoraFlowScreen({super.key});

  @override
  State<DoraFlowScreen> createState() => _DoraFlowScreenState();
}

class _DoraFlowScreenState extends State<DoraFlowScreen> {
  final int itemCount = 4;
  List<bool> isActiveList = [];

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
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        isActiveList[i] = false;
      });
    }

    if (isActiveList.every((active) => active)) {
      await Future.delayed(Duration(seconds: 0));
      setState(() {
        isActiveList = List.generate(itemCount, (_) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
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
                  onPressed: startAnimation,
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
                                fontSize: 10.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w500
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
                                  fontSize: 10.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500
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
      ),
    );
  }

  Widget animationSection() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          singleAnimationRow(
            title: "Discover",
            description: "Client broadcasts DHCP Discover",
            index: 0
          ),
          SizedBox(height: 8.0.h),
          singleAnimationRow(
            title: "Offer ",
            description: "Server responds with IP offer",
            index: 1
          ),
          SizedBox(height: 8.0.h),
          singleAnimationRow(
            title: "Request",
            description: "Client requests the offered IP",
              index: 2
          ),
          SizedBox(height: 8.0.h),
          singleAnimationRow(
            title: "Acknowledge",
            description: "Server confirms IP assignment",
              index: 3
          ),
        ],
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
                    ? index == 0
                      ? Color(0xff558dd2)
                      : index == 1
                        ? Color(0xfff1ad37)
                        : index == 2
                          ? Color(0xff4494f6)
                          : index == 3
                            ? Color(0xff7dc198)
                            : Color(0xffb1b2b8)
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