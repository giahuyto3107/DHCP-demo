import 'package:demo_dhcp_windows/apiServices/apiServices.dart';
import 'package:demo_dhcp_windows/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            theme: ThemeData(
              useMaterial3: false,
              cardColor: Colors.white,
            ),
            debugShowCheckedModeBanner: false,
            title: 'DHCP demo',
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}