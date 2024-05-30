import 'package:admin/api_calls.dart';
import 'package:admin/models/memo_list_approver_model.dart';
import 'package:admin/screens/approve_memo/component/attachment_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';

class MemoApprovalItem extends StatelessWidget {
  final MemoList memoListItem;
  final Function callback;
  final int nextApprover;
  final int userId;
  const MemoApprovalItem({Key? key, required this.userId, required this.nextApprover, required this.memoListItem, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Memo List Attachment Item: ${memoListItem.attachment.split(',').length} ${memoListItem.attachment}');
    return InkWell(
      onTap: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: ListView(
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(memoListItem.title, style: TextStyle(color: textColor,fontWeight: FontWeight.bold, fontSize: 16),),
                    Text(memoListItem.dateCreated, style: TextStyle(color: textColor,),),
                    SizedBox(height: 7,),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.blueAccent.shade100.withOpacity(0.1),
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(7)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Proposed By: ', style: TextStyle(color: textColor,fontWeight: FontWeight.bold, fontSize: 14),),
                          Text(memoListItem.creator.name, style: TextStyle(color: textColor,),),
                          Text(memoListItem.creator.designation, style: TextStyle(color: textColor,),),
                        ],
                      ),
                    ),
                    // Text('Prepared By: ', style: TextStyle(color: textColor,fontWeight: FontWeight.bold, fontSize: 14),),
                    // Text(memoListItem.creator.name, style: TextStyle(color: textColor,),),
                    // Text(memoListItem.creator.designation, style: TextStyle(color: textColor,),),
                    SizedBox(height: 7,),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.tealAccent.shade100.withOpacity(0.1),
                          border: Border.all(color: Colors.tealAccent),
                          borderRadius: BorderRadius.circular(7)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Memo Type: ', style: TextStyle(color: textColor,fontWeight: FontWeight.bold, fontSize: 14),),
                          Text(memoListItem.memoType.name, style: TextStyle(color: textColor,),),
                        ],
                      ),
                    ),
                    // Text('Memo Type: ', style: TextStyle(color: textColor,fontWeight: FontWeight.bold, fontSize: 14),),
                    // Text(memoListItem.memoType.name, style: TextStyle(color: textColor,),),
                    SizedBox(height: 7,),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.amber.shade100.withOpacity(0.1),
                          border: Border.all(color: Colors.amberAccent),
                          borderRadius: BorderRadius.circular(7)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status: ', style: TextStyle(color: textColor,fontWeight: FontWeight.bold, fontSize: 14),),
                          Text(memoListItem.memoStatusId == 1 ? 'Pending Finance Review' : memoListItem.memoStatus, style: TextStyle(color: textColor,),),
                        ],
                      ),
                    ),
                    // Text('Status: ', style: TextStyle(color: textColor,fontWeight: FontWeight.bold, fontSize: 14),),
                    // Text(memoListItem.memoStatus, style: TextStyle(color: textColor,),),
                    Divider(),
                    Text('Approver: ', style: TextStyle(color: textColor,fontWeight: FontWeight.bold, fontSize: 14),),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: memoListItem.approverList.length,
                      itemBuilder: (context, index){
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.lightBlue.shade100.withOpacity(0.1),
                              border: Border.all(color: Colors.lightBlueAccent),
                              borderRadius: BorderRadius.circular(7)
                          ),
                          child: Row(children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(memoListItem.approverList[index].approverName, style: TextStyle(color: textColor,),),
                                Text(memoListItem.approverList[index].approverDesignation, style: TextStyle(color: textColor,),),
                              ],),
                            ),
                            Text(memoListItem.approverList[index].approved == 0 ? 'Pending \nApproval' : 'Approved', style: TextStyle(color: textColor,),)
                          ],),
                        );
                        //   Row(children: [
                        //   Expanded(
                        //     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        //       Text(memoListItem.approverList[index].approverName, style: TextStyle(color: textColor,),),
                        //       Text(memoListItem.approverList[index].approverDesignation, style: TextStyle(color: textColor,),),
                        //     ],),
                        //   ),
                        //   Text(memoListItem.approverList[index].approved == 0 ? 'Pending \nApproval' : 'Approved', style: TextStyle(color: textColor,),)
                        // ],);
                      }
                    ),
                    Divider(),
                    Text('Attachment', style: TextStyle(color: textColor,fontWeight: FontWeight.bold),),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: memoListItem.attachment.split(',').length,
                        itemBuilder: (context, index){
                        if (memoListItem.attachment.length == 0) {
                          return Center(child: Text('No attachment included'),);
                        } else {
                          return attachmentItem(memoListItem.attachment.split(',')[index]);
                        }
                        }
                    ),
                  ],),
                  Divider(),
                  TextButton(onPressed: (){memoListItem.memoType.name == 'SSP memo' ? openPdfSSP(memoListItem.approvalsRef) : openPdf(memoListItem.id.toString());}, child: Text("Generate Memo", style: TextStyle(color: Colors.white),), style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), backgroundColor: Colors.blueAccent),),
                  Divider(),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    TextButton(onPressed: ()=> Navigator.pop(context), child: Text('Close')),
                    TextButton(onPressed: memoListItem.pendingApproval != userId || memoListItem.pendingApproval == 0 || memoListItem.memoStatusId == 1 ? null : (){
                      approveMemo(memoListItem.approverList[0].id, memoListItem.approvalsRef, nextApprover, memoListItem.id, context).then((value) => print(value));
                    }, child: Text('Approve'))//Text('Approve ${nextApprover}'))
                  ],)
                ],
              )
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor/*secondaryColorLight*/,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(memoListItem!.title, style: TextStyle(color: textColor,fontWeight: FontWeight.bold),),
          Text(memoListItem.memoType.name, style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey, fontSize: 12),),
          Text(memoListItem.dateCreated, style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey, fontSize: 12),)
        ],),
      ),
    );
  }

  Future<void> openPdf(String id) async {
    if (!await launchUrl(
        ApiCalls().openPdf(id)//Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/get_pdf?memo_id=$id')
    )) {
      throw Exception('Could not launch');
    }
  }

  Future<void> openPdfSSP(String memo_ref) async {
    if (!await launchUrl(
        ApiCalls().openPdfSSP(memo_ref)//Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/get_pdf_ssp?memo_ref=$memo_ref')
    )) {
      throw Exception('Could not launch');
    }
  }

  Future<String> approveMemo(int approver, String refNum, int nextApprover, int memoId, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    final body = {
      'approver': approver.toString(),
      'ref_num': refNum.toString(),
      'next_approver': nextApprover.toString(),
      'memo_id': memoId.toString(),
    };
    Uri url = ApiCalls().approveMemo(); //Uri.parse('$urlProd/approve_memo?approver=$approver&ref_num=${Uri.encodeComponent(refNum)}&next_approver=$nextApprover&memo_id=${memoListItem.id}');
    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      nextApprover.toString() == "0" ? await sendMailComplete(refNum) : await sendMail(nextApprover.toString()); /// need to add implemnentation to send back to creator once complete all approve
      Navigator.pop(context);
      callback();
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/approved.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
                Text('Memo approved'),
                TextButton(onPressed: (){
                  Navigator.pop(context);
                  // widget.navigatorKey.currentState!.pushNamed(routeCreateMemo);
                }, child: Text('Close'))
              ],
            ),
          ),
        ),
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Approved')),
      // );
    }else {
      return Future.error("cannot retrieve data");
    }
    return response.body;
  }

  Future<String> sendMail(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    Uri url = ApiCalls().sendMailById(userId);//Uri.parse('$urlProd/sendMail?userId=$userId');
    print(url);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    }else {
      return Future.error("cannot send email");
    }
    return response.body;
  }

  Future<String> sendMailComplete(String memoRef) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    Uri url = ApiCalls().sendMailCompleteApproval(memoRef);//Uri.parse('$urlProd/sendMail?userId=$userId');
    print(url);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    }else {
      return Future.error("cannot send email");
    }
    return response.body;
  }
}


