import 'dart:convert';

import 'package:admin/api_calls.dart';
import 'package:admin/models/memo_list_approver_model.dart';
import 'package:admin/screens/approve_memo/component/memo_approval_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

class MemoApprovalList extends StatefulWidget {
  const MemoApprovalList({Key? key}) : super(key: key);

  @override
  State<MemoApprovalList> createState() => _MemoApprovalListState();
}

class _MemoApprovalListState extends State<MemoApprovalList> {
  MemoListApproverView? memoListView;
  bool isLoaded = false;

  int userId = 0;
  int userType = 0;
  late int nextApprover;

  @override
  void initState(){
    super.initState();
    getData().then((value) => viewMemoApproverAPI());
    // viewMemoApproverAPI();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: isLoaded ? memoListView!.memoList.length > 0 ? ListView.builder(
          shrinkWrap: true,
          itemCount: memoListView!.memoList.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){

            int tempUserType = userType+1;
            for (ApproverList approver in memoListView!.memoList[index].approverList) {
              // if (approver.userType == tempUserType) {
              print(approver.approverName);
              if (approver.approved == 0 && userId != approver.id) {
                nextApprover = approver.id;
                print(nextApprover);
                print('here');
                break;
              } else {
                nextApprover = 0;
                // print('there');
              }
            }
            return MemoApprovalItem(userId: userId, nextApprover: nextApprover, memoListItem: memoListView!.memoList[index], callback: (){
              setState(() {
                isLoaded = false;
              });
              viewMemoApproverAPI();
            },);
          }
      ) : SizedBox(height: 200, child: Center(child: Text('No memo to approve', style: TextStyle(color: textColor,),),))
        : Lottie.asset(
        'assets/lottie/loading.json',
        width: 200,
        height: 200,
        fit: BoxFit.fill,
      ),
    );
  }

  Future<String> viewMemoApproverAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    Uri url = ApiCalls().viewMemoListApprover(userId);//Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/view_memo_list_approver/?approver_id=$userId');
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      setState(() {
        memoListView = MemoListApproverView.fromJson(jsonDecode(response.body));
        isLoaded = true;
      });
    }else {
      Future.error("cannot retrieve data");
    }
    return response.body;
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getKeys());

    setState(() {
      userId = prefs.getInt('user_id') ?? 0;
      userType = prefs.getInt('user_type_id') ?? 0;
    });
  }
}
