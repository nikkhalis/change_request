import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

class ProfileDisplay extends StatefulWidget {
  final Function callback;
  const ProfileDisplay({Key? key, required this.callback}) : super(key: key);

  @override
  State<ProfileDisplay> createState() => _ProfileDisplayState();
}

class _ProfileDisplayState extends State<ProfileDisplay> {
  String? email, name, phoneNum, role, designation;

  @override
  void initState(){
    super.initState();
    getData();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: secondaryColor/*secondaryColorLight*/,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('\n Name: $name'),
          Text('\n Email: $email', style: TextStyle(color: textColor),),
          Text('\n Phone Number: $phoneNum'),
          Text('\n Role: $role'),
          Text('\n Designation: $designation \n'),
        ],
      ),
    );
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getKeys());

    setState(() {
      name = prefs.getString('name');
      email = '${prefs.getString('email')}';
      phoneNum = prefs.getString('phoneNum');
      role = prefs.getString('role');
      designation = prefs.getString('designation');
    });
  }
}
