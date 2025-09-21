import 'package:demo_dhcp_windows/apiServices/apiConfig.dart';
import 'package:demo_dhcp_windows/apiServices/apiServices.dart';
import 'package:demo_dhcp_windows/models/relayAgent.dart';
import 'package:demo_dhcp_windows/models/dashBoard.dart';
import 'package:demo_dhcp_windows/models/lease.dart';
import 'package:demo_dhcp_windows/models/scopeInfo.dart';
import 'package:demo_dhcp_windows/screens/dashBoard.dart';
import 'package:demo_dhcp_windows/screens/doraFlowScreen.dart';
import 'package:demo_dhcp_windows/screens/leaseListScreen.dart';
import 'package:demo_dhcp_windows/screens/scopeInfoScreen.dart';
import 'package:demo_dhcp_windows/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Future<DashBoard> _dashBoardFuture;
  late Future<ScopeInfo> _scopeInfoFuture;
  late Future<List<Lease>> _leaseListFuture;
  final TextEditingController ipAddressController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final ipFocus = FocusNode();
  final portFocus = FocusNode();
  // late Future<RelayAgent> _relayAgent;

  @override
  void initState() {
    super.initState();
    // Initialize futures with ApiService from Provider
    final apiService = Provider.of<ApiService>(context, listen: false);
    _dashBoardFuture = fetchDashBoardData(apiService);
    _scopeInfoFuture = fetchScopeInfo(apiService);
    _leaseListFuture = fetchLeaseList(apiService);
    // _relayAgent = fetchRelayAgent(apiService);
  }

  void restart() {
    final apiService = Provider.of<ApiService>(context, listen: false);
    _dashBoardFuture = fetchDashBoardData(apiService);
    _scopeInfoFuture = fetchScopeInfo(apiService);
    _leaseListFuture = fetchLeaseList(apiService);
    // _relayAgent = fetchRelayAgent(apiService);
  }

  @override
  void dispose() {
    ipAddressController.dispose();
    portController.dispose();
    ipFocus.dispose();
    portFocus.dispose();
    super.dispose();
  }

  Future<DashBoard> fetchDashBoardData(ApiService apiService) async {
    try {
      final data = await apiService.fetchDashBoard();
      print(data);
      return data;
    } catch (e) {
      print('Error with fetching dashboard data: $e');
      rethrow;
    }
  }

  Future<ScopeInfo> fetchScopeInfo(ApiService apiService) async {
    try {
      final data = await apiService.fetchScopeInfo();
      print(data);
      return data;
    } catch (e) {
      print('Error with fetching scope info: $e');
      rethrow;
    }
  }

  Future<List<Lease>> fetchLeaseList(ApiService apiService) async {
    try {
      final data = await apiService.fetchLeases();
      print(data);
      return data;
    } catch (e) {
      print('Error with fetching lease list: $e');
      rethrow;
    }
  }

  // Future<RelayAgent> fetchRelayAgent(ApiService apiService) async {
  //   try {
  //     final data = await apiService.fetchRelayAgent();
  //     print(data);
  //     return data;
  //   } catch (e) {
  //     print('Error with fetching dashboard data: $e');
  //     rethrow;
  //   }
  // }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget contentSection() {
    if (_selectedIndex == 0) {
      return DashBoardScreen(dashBoardData: _dashBoardFuture);
    } else if (_selectedIndex == 1) {
      return DoraFlowScreen();
    }
    // else if (_selectedIndex == 2) {
    //   return RelayAgentScreen(
    //     relayAgentData: _relayAgent
    //   );
    // }
    else if (_selectedIndex == 2) {
      return LeaseListScreen(leaseData: _leaseListFuture);
    } else {
      return ScopeInfoScreen(
        scopeInfoData: _scopeInfoFuture,
        dashBoardData: _dashBoardFuture,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9fafb),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showConfigureModal(context);
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.black,
      ),
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
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 16.0.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // same as your Container color
                  foregroundColor: Colors.black, // icon + text color
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                  elevation: 2, // small shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    restart();
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh, size: 24.sp),
                    SizedBox(width: 8.0.w),
                    Text(
                      "Restart",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 16.h),
              navigationTab(
                titles: ['Dashboard', 'Dora Flow', 'Lease List', 'Scope Info'],
              ),
              SizedBox(height: 8.0.h),
              Expanded(child: contentSection()),
            ],
          ),
        ),
      ),
    );
  }

  Widget navigationTab({required List<String> titles}) {
    int middleOfList = (titles.length / 2).toInt();
    return Column(
      children: [
        navigationRow(
          titles: titles.sublist(0, middleOfList),
          selectedIndex: _selectedIndex < middleOfList ? _selectedIndex : -1,
          onTap: (index) {
            _onItemTapped(index);
          },
        ),
        SizedBox(height: 8.h),
        navigationRow(
          titles: titles.sublist(middleOfList, titles.length),
          selectedIndex:
          _selectedIndex >= middleOfList ? _selectedIndex - middleOfList : -1,
          onTap: (index) {
            _onItemTapped(index + middleOfList);
          },
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

  void _showConfigureModal(BuildContext outerContext) {
    showDialog(
      context: outerContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'IP Configuration',
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      icon: Icon(Icons.cancel),
                    )
                  ],
                ),
                SizedBox(height: 32.0.h,),
                textFieldSection(
                  controller: ipAddressController,
                  hintText: 'e.g: 192.168.1.1',
                  labelText: 'Wifi\'s ip address of windows server',
                  focusNode: ipFocus,
                  nextFocusNode: portFocus,
                  autofocus: true,
                ),
                SizedBox(height: 16.0.h,),
                textFieldSection(
                  controller: portController,
                  hintText: 'e.g: 5000',
                  labelText: 'Port of windows server',
                  focusNode: portFocus,
                ),
                SizedBox(height: 32.0.h,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      handleDialogCancel(dialogContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff0B0B0B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Configure',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void handleDialogCancel(BuildContext context) {
    bool ipAddressValid = Helper.ipAddressRegex.hasMatch(ipAddressController.text);
    bool portValid = Helper.portRegex.hasMatch(portController.text);
    if (!ipAddressValid) {
      Helper.showWarningSnackBar(context, "Ip address is invalid");
    } else if (!portValid) {
      Helper.showWarningSnackBar(context, "Port is invalid");
    } else if (ipAddressController.text.isEmpty || portController.text.isEmpty) {
      Helper.showWarningSnackBar(context, "Ip address or port is empty");
    } else if (ipAddressValid && portValid) {
      print("ip address: ${ApiConfig.ipAddress}, port: ${ApiConfig.port}");
      Helper.showSuccessSnackBar(context, "Configurated successfully");
      ApiConfig.setIpAddress(ipAddressController.text);
      ApiConfig.setPort(portController.text);
      ApiConfig.setBaseUrl();
      print("base url: ${ApiConfig.baseUrl}");
      restart();
      Navigator.pop(context);
    }
  }

  Widget textFieldSection({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    bool autofocus = false,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: true,

      textInputAction: nextFocusNode != null
        ? TextInputAction.next
        : TextInputAction.done,

      onSubmitted: (_) {
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },

      keyboardType: TextInputType.number,

      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(color: Color(0xff7c7c7c)),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      style: TextStyle(
        color: Colors.black
      ),
    );
  }
}