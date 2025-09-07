import 'package:demo_dhcp_windows/screens/dashBoardScreen.dart';
import 'package:demo_dhcp_windows/screens/doraFlowScreen.dart';
import 'package:demo_dhcp_windows/screens/leaseListScreen.dart';
import 'package:demo_dhcp_windows/screens/scopeInfoScreen.dart';
import 'package:go_router/go_router.dart';

const doraFlow = '/dora_flow';
const leaseList = '/lease_list';
const scopeInfo = '/scope_info';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path:'/',
      name: 'dash-board',
      builder: (context, state) => DashBoardScreen()
    ),

    GoRoute(
      path: doraFlow,
      name: 'dora-flow',
      builder: (context, state) => DoraFlowScreen()
    ),

    GoRoute(
      path: leaseList,
      name: 'lease-list',
      builder: (context, state) => LeaseListScreen()
    ),

    GoRoute(
      path: scopeInfo,
      name: 'scope-info',
      builder: (context, state) => ScopeInfoScreen()
    ),
  ]
);