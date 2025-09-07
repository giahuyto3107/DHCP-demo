import 'package:demo_dhcp_windows/screens/dashBoard.dart';
import 'package:demo_dhcp_windows/screens/doraFlowScreen.dart';
import 'package:demo_dhcp_windows/screens/leaseListScreen.dart';
import 'package:demo_dhcp_windows/screens/scopeInfoScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9fafb),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
          child: Column(
            children: [
              Text(
                "DHCP Server Manager",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.0.h),
              Text(
                "Network Administration",
                style: TextStyle(
                  fontSize: 16.sp,
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
              contentSection(),

            ],
          ),
        ),
      ),
    );
  }

  Widget contentSection() {
    if (_selectedIndex == 0) {
      return DashBoardScreen();
    }
    else if (_selectedIndex == 1) {
      return DoraFlowScreen();
    }

    else if (_selectedIndex == 2) {
      return LeaseListScreen();
    }

    else {
      return ScopeInfoScreen();
    }
  }

  Widget navigationTab({required List<String> titles}) {
    int middleOfList = (titles.length/2).toInt();
    return Column(
      children: [
        navigationRow(
          titles: titles.sublist(0, middleOfList),
          selectedIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        SizedBox(height: 8.h),
        navigationRow(
            titles: titles.sublist(middleOfList, titles.length),
            selectedIndex: _selectedIndex - middleOfList,
            onTap: (index) {
              setState(() {
                _selectedIndex = index + middleOfList;
              });
            }
        ),
      ],
    );
  }

  Widget navigationRow({
    required List<String> titles,
    required int selectedIndex,
    required Function(int) onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xfff3f4f6),
      ),
      child: Row(
        children: List.generate(titles.length, (index) {
          final bool isSelected = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap.call(index),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 8.0.h),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    titles[index],
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isSelected ? Colors.black : const Color(0xff757c8a),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

