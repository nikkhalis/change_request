import 'package:admin/constants.dart';
import 'package:admin/routes.dart';
import 'package:admin/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenu extends StatelessWidget {
  final navigatorKey;
  final Function callback;
  final int dashboardIndex;
  final int usersId;
  final int userRole;
  const SideMenu({
    Key? key, required this.navigatorKey, required this.callback, required this.dashboardIndex, required this.usersId, required this.userRole
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: secondaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          DrawerListTile(
            title: Text(
              "Dashboard",
              style: TextStyle(color:dashboardIndex == 1 ? textColor/*Colors.white*/ : textColor.withOpacity(0.4)/*Colors.white54*/,
                  fontWeight: dashboardIndex == 1 ? FontWeight.bold : FontWeight.normal),
            ),
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {
              // Navigator.pop(context);
              context.findRootAncestorStateOfType<ScaffoldState>()?.closeDrawer();
              navigatorKey.currentState!.pushNamed(routeDashboard);
              callback(1);
            },
          ),
          DrawerListTile(
            title: Text(
              "View User",
              style: TextStyle(color:dashboardIndex == 2 ? textColor/*Colors.white*/ : textColor.withOpacity(0.4)/*Colors.white54*/,
                  fontWeight: dashboardIndex == 2 ? FontWeight.bold : FontWeight.normal),
            ),
            svgSrc: "assets/icons/user.svg",
            press: () {
              // Navigator.pop(context);
              context.findRootAncestorStateOfType<ScaffoldState>()?.closeDrawer();
              navigatorKey.currentState!.pushNamed(routeUser);
              callback(2);
            },
          ),
          DrawerListTile(
            title: Text(
              "Change Request Form",
              style: TextStyle(color:dashboardIndex == 3 ? textColor/*Colors.white*/ : textColor.withOpacity(0.4)/*Colors.white54*/,
                  fontWeight: dashboardIndex == 3 ? FontWeight.bold : FontWeight.normal),
            ),
            svgSrc: "assets/icons/form.svg",
            press: () {
              // Navigator.pop(context);
              context.findRootAncestorStateOfType<ScaffoldState>()?.closeDrawer();
              navigatorKey.currentState!.pushNamed(routeChangeRequest);
              callback(3);
            },
          ),
          DrawerListTile(
            title: Text(
              "Change Request List",
              style: TextStyle(color:dashboardIndex == 4 ? textColor/*Colors.white*/ : textColor.withOpacity(0.4)/*Colors.white54*/,
                  fontWeight: dashboardIndex == 4 ? FontWeight.bold : FontWeight.normal),
            ),
            svgSrc: "assets/icons/req_list.svg",
            press: () {
              // Navigator.pop(context);
              context.findRootAncestorStateOfType<ScaffoldState>()?.closeDrawer();
              navigatorKey.currentState!.pushNamed(routeChangeRequestList);
              callback(4);
            },
          ),
          // DrawerListTile(
          //   title: Text(
          //     "Create Memo",
          //     style: TextStyle(color:dashboardIndex == 4 ? textColor/*Colors.white*/ : textColor.withOpacity(0.4)/*Colors.white54*/,
          //         fontWeight: dashboardIndex == 4 ? FontWeight.bold : FontWeight.normal),
          //   ),
          //   svgSrc: "assets/icons/user.svg",
          //   press: () {
          //     // Navigator.pop(context);
          //     context.findRootAncestorStateOfType<ScaffoldState>()?.closeDrawer();
          //     navigatorKey.currentState!.pushNamed(routeCreateMemo);
          //     callback(4);
          //   },
          // ),
          // userRole == 1 || userRole == 2 ? DrawerListTile(
          //   title: Text(
          //     "Change Request",
          //     style: TextStyle(color:dashboardIndex == 3 ? textColor/*Colors.white*/ : textColor.withOpacity(0.4)/*Colors.white54*/,
          //         fontWeight: dashboardIndex == 3 ? FontWeight.bold : FontWeight.normal),
          //   ),
          //   svgSrc: "assets/icons/switch.svg",
          //   press: () {
          //     // Navigator.pop(context);
          //     context.findRootAncestorStateOfType<ScaffoldState>()?.closeDrawer();
          //     navigatorKey.currentState!.pushNamed(routeChangeRequest);
          //     callback(3);
          //   },
          // ) : SizedBox(),
          // DrawerListTile(
          //   title: Text(
          //     "Memo List",
          //     style: TextStyle(color:dashboardIndex == 3 ? textColor/*Colors.white*/ : textColor.withOpacity(0.4)/*Colors.white54*/,
          //         fontWeight: dashboardIndex == 3 ? FontWeight.bold : FontWeight.normal),
          //   ),
          //   svgSrc: "assets/icons/menu_tran.svg",
          //   press: () {
          //     // Navigator.pop(context);
          //     context.findRootAncestorStateOfType<ScaffoldState>()?.closeDrawer();
          //     navigatorKey.currentState!.pushNamed(routeMemo);
          //     callback(3);
          //   },
          // ),
          // DrawerListTile(
          //   title: Text(
          //     "Approve Memo",
          //     style: TextStyle(color:dashboardIndex == 5 ? textColor/*Colors.white*/ : textColor.withOpacity(0.4)/*Colors.white54*/,
          //         fontWeight: dashboardIndex == 5 ? FontWeight.bold : FontWeight.normal),
          //   ),
          //   svgSrc: "assets/icons/approve.svg",
          //   press: () {
          //     // Navigator.pop(context);
          //     context.findRootAncestorStateOfType<ScaffoldState>()?.closeDrawer();
          //     navigatorKey.currentState!.pushNamed(routeApproveMemo);
          //     callback(5);
          //   },
          // ),
          SizedBox(),
          // userTypeId == 1 || userTypeId == 2 ? DrawerListTile(
          //   title: Text(
          //     "Register User",
          //     style: TextStyle(color:dashboardIndex == 5 ? textColor/*Colors.white*/ : textColor.withOpacity(0.4)/*Colors.white54*/,
          //         fontWeight: dashboardIndex == 5 ? FontWeight.bold : FontWeight.normal),
          //   ),
          //   svgSrc: "assets/icons/register.svg",
          //   press: () {
          //     // Navigator.pop(context);
          //     context.findRootAncestorStateOfType<ScaffoldState>()?.closeDrawer();
          //     navigatorKey.currentState!.pushNamed(routeRegisterUser);
          //     callback(5);
          //   },
          // ) : SizedBox(),
          // DrawerListTile(
          //   title: Text(
          //     "Settings",
          //     style: TextStyle(color:dashboardIndex == 6 ? textColor/*Colors.white*/ : textColor.withOpacity(0.4)/*Colors.white54*/,
          //         fontWeight: dashboardIndex == 6 ? FontWeight.bold : FontWeight.normal),
          //   ),
          //   svgSrc: "assets/icons/setting.svg",
          //   press: () {
          //     // Navigator.pop(context);
          //     context.findRootAncestorStateOfType<ScaffoldState>()?.closeDrawer();
          //     navigatorKey.currentState!.pushNamed(routeSettings);
          //     callback(6);
          //   },
          // ),
          // DrawerListTile(
          //   title: Text(
          //     "Change Request",
          //     style: TextStyle(color:dashboardIndex == 5 ? textColor/*Colors.white*/ : textColor.withOpacity(0.4)/*Colors.white54*/,
          //         fontWeight: dashboardIndex == 5 ? FontWeight.bold : FontWeight.normal),
          //   ),
          //   svgSrc: "assets/icons/switch.svg",
          //   press: () {
          //     // Navigator.pop(context);
          //     context.findRootAncestorStateOfType<ScaffoldState>()?.closeDrawer();
          //     navigatorKey.currentState!.pushNamed(routeChangeRequest);
          //     callback(5);
          //   },
          // ),
          // DrawerListTile(
          //   title: Text(
          //     "Change Request List",
          //     style: TextStyle(color:dashboardIndex == 6 ? textColor/*Colors.white*/ : textColor.withOpacity(0.4)/*Colors.white54*/,
          //         fontWeight: dashboardIndex == 6 ? FontWeight.bold : FontWeight.normal),
          //   ),
          //   svgSrc: "assets/icons/req_list.svg",
          //   press: () {
          //     // Navigator.pop(context);
          //     context.findRootAncestorStateOfType<ScaffoldState>()?.closeDrawer();
          //     navigatorKey.currentState!.pushNamed(routeChangeRequestList);
          //     callback(6);
          //   },
          // ),
          DrawerListTile(
            title: Text(
              "Profile",
              style: TextStyle(color:dashboardIndex == 5 ? textColor/*Colors.white*/ : textColor.withOpacity(0.4)/*Colors.white54*/,
                  fontWeight: dashboardIndex == 5 ? FontWeight.bold : FontWeight.normal),
            ),
            svgSrc: "assets/icons/setting.svg",
            press: () {
              // Navigator.pop(context);
              context.findRootAncestorStateOfType<ScaffoldState>()?.closeDrawer();
              navigatorKey.currentState!.pushNamed(routeProfile);
              callback(5);
            },
          ),
          // DrawerListTile(
          //   title: Text(
          //     "Manage User",
          //     style: TextStyle(color:dashboardIndex == 8 ? textColor/*Colors.white*/ : textColor.withOpacity(0.4)/*Colors.white54*/,
          //         fontWeight: dashboardIndex == 8 ? FontWeight.bold : FontWeight.normal),
          //   ),
          //   svgSrc: "assets/icons/manage_users.svg",
          //   press: () {
          //     // Navigator.pop(context);
          //     context.findRootAncestorStateOfType<ScaffoldState>()?.closeDrawer();
          //     navigatorKey.currentState!.pushNamed(routeManageUser);
          //     callback(8);
          //   },
          // ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: DrawerListTile(
                title: Text(
                  "Logout",
                  style: TextStyle(color: textColor),
                ),
                svgSrc: "assets/icons/exit.svg",
                press: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  // print(prefs.getKeys());
                  // await prefs.clear();
                  // print(prefs.getKeys());
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: Text('Confirm to logout'),
                      actions: [
                        TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel')),
                        TextButton(onPressed: ()async{
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);
                          // Navigator.pop(context);
                          await prefs.clear();
                        }, child: Text('Confirm'))
                      ],
                    ),
                  );
                  // Navigator.pop(context);
                  // navigatorKey.currentState!.pushNamed(routeSettings);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String svgSrc;
  final VoidCallback press;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: primaryColor,//Colors.white54,
        height: 16,
      ),
      title: title,
    );
  }
}