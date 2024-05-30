import 'dart:convert';

import 'package:admin/api_calls.dart';
import 'package:admin/models/memo_list_view.dart';
import 'package:admin/screens/memo/component/memo_lists.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../../responsive.dart';

class MemoScreen extends StatefulWidget {
  final navigatorKey;
  final int userId;
  const MemoScreen({Key? key, required this.navigatorKey, this.userId = 0}) : super(key: key);

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  MemoListView? memoListView;
  bool allChecked = false;
  bool isLoaded = false;

  @override
  void initState(){
    super.initState();
    widget.userId == 1 ? viewMemoAPI() : viewUserMemoAPI(widget.userId);
    // print('userId: ${widget.userId}');
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
            MemoLists(
              callBack: (submitted){
                setState(() {
                  // allChecked = checked;
                  isLoaded = false;
                  if (submitted){
                    viewUserMemoAPI(widget.userId);
                  }
                });
              },
              memoListView: memoListView,
              userId: widget.userId,
            ),
            SizedBox(height: 5,),
            // Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            //   TextButton(onPressed: (){}, child: Text('Cancel', style: TextStyle(color: Colors.red),)),
            //   TextButton(onPressed: (){
            //     viewMemoAPI();
            //   }, style: TextButton.styleFrom(backgroundColor: Colors.white), child: Text(allChecked ? 'Submit All' : 'Submit', style: TextStyle(color: Colors.green),))
            // ],)
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
  
  Future<String> viewMemoAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    Uri url = ApiCalls().viewMemoList();//Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/view_memo_list/');
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      setState(() {
        memoListView = MemoListView.fromJson(jsonDecode(response.body));
        isLoaded = true;
      });
    }else {
      Future.error("cannot retrieve data");
    }
    return response.body;
  }

  Future<String> viewUserMemoAPI(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    Uri url = ApiCalls().viewUserMemoList(userId);//Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/view_memo_list/');
    var response = await http.get(url, headers: headers);
    print('userId: $userId');
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        memoListView = MemoListView.fromJson(jsonDecode(response.body));
        isLoaded = true;
      });
    }else {
      Future.error("cannot retrieve data");
    }
    return response.body;
  }
}
