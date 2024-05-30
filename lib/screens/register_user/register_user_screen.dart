import 'package:admin/constants.dart';
import 'package:admin/screens/register_user/component/register_user_form.dart';
import 'package:flutter/material.dart';


class RegisterUserScreen extends StatelessWidget {
  final navigatorKey;
  const RegisterUserScreen({Key? key, required this.navigatorKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Register User", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            SizedBox(height: 8,),
            RegisterUserForm(navigatorKey: navigatorKey,)
          ],
        ),
      ),
    );
  }
}
