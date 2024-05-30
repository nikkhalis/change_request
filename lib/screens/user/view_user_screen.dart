import 'dart:convert';

import '../../models/user_list_view.dart';
import 'component/add_user.dart';
import 'component/user_lists.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../constants.dart';

class ViewUserScreen extends StatefulWidget {
  final navigatorKey;
  const ViewUserScreen({Key? key, required this.navigatorKey}) : super(key: key);

  @override
  State<ViewUserScreen> createState() => _ViewUserScreen();
}

class _ViewUserScreen extends State<ViewUserScreen> {
  // String pageName = 'View User';
  UserListView? userListView;
  bool allChecked = false;
  bool isLoaded = false;

  @override
  void initState(){
    super.initState();
    viewUserAPI();
    print('view user page');
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: isLoaded ? [
            SizedBox(height: defaultPadding),
            AddUser(),
            SizedBox(height: 15,),
              UserLists(
                callBack: (checked){
                  setState(() {
                    allChecked = checked;
                  });
                },
                userListView: userListView,
              ),
            SizedBox(height: 15,),
          ] : [Lottie.asset(
                'assets/lottie/loading.json',
                width: 200,
                height: 200,
                fit: BoxFit.fill,
          )],
        ),
      ),
    );
  }

  Future<String> viewUserAPI() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      "Access-Control-Allow-Origin": "*"
    };
    Uri testUrl = Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/view_user_list/');
    var response = await http.get(testUrl, headers: headers);
    print("response view user data: ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        userListView = UserListView.fromJson(jsonDecode(response.body));
        isLoaded = true;
      });
    }else {
      Future.error("cannot retrieve data");
    }
    return response.body;
  }
}
