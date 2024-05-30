import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/responsive.dart';
import 'package:admin/routes.dart';
import 'package:admin/screens/user/view_user_screen.dart';
import 'package:admin/screens/profile/profile_screen.dart';




import 'package:admin/screens/change_request/change_request_screen.dart';
import 'package:admin/screens/approve_memo/approve_memo_screen.dart';
import 'package:admin/screens/create_memo/create_memo_screen.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
// import 'package:admin/screens/memo/memo_screen.dart';
// import 'package:admin/screens/manage_user/manage_user_screen.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../change_request_list/change_request_list_screen.dart';
import '../dashboard/components/header.dart';
import '../memo/memo_screen.dart';
import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // final GlobalKey _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  String pageName = 'Dashboard';
  int dashboardIndex = 1;
  int userRole = 0;
  int usersId = 0;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(
        usersId: usersId,
        userRole: userRole,
        dashboardIndex: dashboardIndex,
        navigatorKey: _navigatorKey,
        callback: (index) {
          print(index);
          setState(() {
            dashboardIndex = index;
          });
        },
      ),
      body: isLoaded
          ? SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(
                  usersId: usersId,
                  userRole: userRole,
                  dashboardIndex: dashboardIndex,
                  navigatorKey: _navigatorKey,
                  callback: (index) {
                    print(index);
                    setState(() {
                      dashboardIndex = index;
                    });
                  },
                ),
              ),
            Expanded(
              flex: 5,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Column(
                    children: [
                      Header(pageName: pageName),
                      SizedBox(height: 10),
                      Expanded(
                        child: Navigator(
                          key: _navigatorKey,
                          initialRoute: routeDashboard,
                          onGenerateRoute: _onGenerateRoute,
                          transitionDelegate:
                          NoAnimationTransitionDelegate(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          : Center(
        child: CircularProgressIndicator(), // Placeholder for loading
      ),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    late Widget page;
    switch (settings.name) {
      case routeDashboard:
        page = DashboardScreen();
        if (pageName != 'Dashboard') {
          setState(() {
            pageName = "Dashboard";
          });
        }
        break;
      case routeUser:
        page = ViewUserScreen(navigatorKey: _navigatorKey);
        if (pageName != 'User') {
          setState(() {
            pageName = "User";
          });
        }
        break;
      case routeChangeRequest:
        page = ChangeRequestScreen(navigatorKey: GlobalKey<NavigatorState>());
        setState(() {
          pageName = "Change Request";
        });
        break;
      case routeMemo:
      page = MemoScreen(navigatorKey: _navigatorKey,);
      setState(() {
        pageName = "Memo Display";
      });
      break;
      // case routeChangeRequestList:
      //   page = ChangeRequestListScreen(
      //     navigatorKey: GlobalKey<NavigatorState>(),
      //     projectNames: [],
      //   );
        break;
      case routeChangeRequestList:
        page = ChangeRequestListScreen(navigatorKey: _navigatorKey,);
        setState(() {
          pageName = "Change Request List";
        });
        break;
      case routeApproveMemo:
        page = ApproveMemoScreen(navigatorKey: _navigatorKey,);
        setState(() {
          pageName = "Memo Display";
        });
        break;
      // case routeChangeRequestList:
      //   page = ChangeRequestListScreen(navigatorKey: GlobalKey<NavigatorState>());
      //   setState(() {
      //     pageName = "Change Request";
      //   });
      //   setState(() {
      //     pageName = "Change Request List";
      //   });
      //   break;

    // case routeChangeRequestList:
    //     page = RequestListScreen(navigatorKey: _navigatorKey,);
    //     setState(() {
    //       pageName = "Change Request List";
    //     });
    //     break;
      case routeProfile:
        page = ProfileScreen();
        setState(() {
          pageName = "Profile";
        });
        break;
    }
    //   case routeManageUser:
    //     // page = ManageUserScreen(navigatorKey: _navigatorKey,);
    //     setState(() {
    //       pageName = "Manage User";
    //     });
    //     break;

    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }

  Future<void> loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? tempId = prefs.getInt('users_id');
      int? tempRole = prefs.getInt('role');
      setState(() {
        if (tempId != null && tempRole != null) {
          isLoaded = true;
          usersId = tempId;
          userRole = tempRole;
        } else {
          print('No data');
        }
      });
    } catch (error) {
      print('Error loading user data: $error');
      setState(() {
        isLoaded = true;
      });
    }
  }
}

class NoAnimationTransitionDelegate extends TransitionDelegate<void> {
  @override
  Iterable<RouteTransitionRecord> resolve({
    required List<RouteTransitionRecord> newPageRouteHistory,
    required Map<RouteTransitionRecord?, RouteTransitionRecord>
    locationToExitingPageRoute,
    required Map<RouteTransitionRecord?, List<RouteTransitionRecord>>
    pageRouteToPagelessRoutes,
  }) {
    final results = <RouteTransitionRecord>[];

    for (final pageRoute in newPageRouteHistory) {
      if (pageRoute.isWaitingForEnteringDecision) {
        pageRoute.markForAdd();
      }
      results.add(pageRoute);
    }

    for (final exitingPageRoute in locationToExitingPageRoute.values) {
      if (exitingPageRoute.isWaitingForExitingDecision) {
        exitingPageRoute.markForRemove();
        final pagelessRoutes = pageRouteToPagelessRoutes[exitingPageRoute];
        if (pagelessRoutes != null) {
          for (final pagelessRoute in pagelessRoutes) {
            pagelessRoute.markForRemove();
          }
        }
      }
      results.add(exitingPageRoute);
    }

    return results;
  }
}
