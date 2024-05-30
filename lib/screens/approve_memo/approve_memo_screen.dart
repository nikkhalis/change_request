import 'package:admin/constants.dart';
import 'package:flutter/material.dart';

import 'component/memo_approval_list.dart';

class ApproveMemoScreen extends StatelessWidget {
  const ApproveMemoScreen({Key? key, required GlobalKey<State<StatefulWidget>> navigatorKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Memo To Approve", textAlign: TextAlign.start, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),),
            SizedBox(height: 8,),
            MemoApprovalList(),
          ],
        ),
      ),
    );
  }
}
