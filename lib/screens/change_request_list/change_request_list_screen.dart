import 'package:flutter/material.dart';
import 'package:admin/constants.dart';
import 'package:admin/screens/change_request_list/component/change_request_list_table.dart';

class ChangeRequestListScreen extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const ChangeRequestListScreen({Key? key, required this.navigatorKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            SizedBox(height: 20),
            ChangeRequestListTable(callback: () {}),
          ],
        ),
      ),
    );
  }
}


