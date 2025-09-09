import 'package:demo_dhcp_windows/screens/homeScreen.dart';
import 'package:go_router/go_router.dart';

const dashBoard = '/dash_board';
const doraFlow = '/dora_flow';
const leaseList = '/lease_list';
const scopeInfo = '/scope_info';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home-screen',
      builder: (context, state) => HomeScreen()
    ),

    // GoRoute(
    // path: dashBoard,
    // name: 'dash-board',
    // builder: (context, state) => DashBoardScreen()
    // ),
    //
    // GoRoute(
    //   path: doraFlow,
    //   name: 'dora-flow',
    //   builder: (context, state) => DoraFlowScreen()
    // ),
    //
    // GoRoute(
    //   path: leaseList,
    //   name: 'lease-list',
    //   builder: (context, state) => LeaseListScreen()
    // ),
    //
    // GoRoute(
    //   path: scopeInfo,
    //   name: 'scope-info',
    //   builder: (context, state) => ScopeInfoScreen()
    // ),
  ]
);