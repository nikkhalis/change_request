import 'package:admin/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin/screens/login/login_screen.dart';
import 'package:admin/screens/register_user/register_user_screen.dart';
void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Change Request System',
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: bgColor/*bgColorLight*/,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: textColor),
          canvasColor: secondaryColor/*secondaryColorLight*/,
        ),
        home: LoginScreen()
    );
  }
}
