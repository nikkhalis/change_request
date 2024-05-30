import 'package:flutter/material.dart';
import 'package:admin/constants.dart';
import 'package:admin/screens/change_request/component/change_request_form.dart';

class ChangeRequestScreen extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const ChangeRequestScreen({Key? key, required this.navigatorKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Change Request Form",
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            ChangeRequestForm(
              navigatorKey: navigatorKey,
              onProjectNameSelected: (projectName) {
                // Handle the project name selection event here
              },
            ),
          ],
        ),
      ),
    );
  }
}
