import 'package:admin/screens/create_memo/component/create_memo_form.dart';
import 'package:flutter/material.dart';

import 'package:admin/constants.dart';

class CreateMemoScreen extends StatelessWidget {
  final navigatorKey;
  const CreateMemoScreen({Key? key, required this.navigatorKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            CreateMemoForm(navigatorKey: navigatorKey,)
          ],
        ),
      ),
    );
  }
}
