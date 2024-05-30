import 'package:admin/api_calls.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';

Widget attachmentItem(String attachment) {
  return ElevatedButton(
      onPressed: (){
        openFile(attachment);
      },
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(height: 5,),
        Icon(Icons.file_present),
        Text(attachment, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(),),
        SizedBox(height: 5,),
      ],)
  );
  // Card(
  //   color: Colors.grey,
  //   child: Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
  //     child: InkWell(
  //       onTap: (){
  //         openFile(attachment);
  //       },
  //       child: Column(children: [
  //         Icon(Icons.file_present),
  //         Text(attachment, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(),)
  //       ],),
  //     ),
  //   ),
  // );

  //   DottedBorder(
  //   borderType: BorderType.RRect,
  //   borderPadding: EdgeInsets.symmetric(vertical: 3),
  //   radius: Radius.circular(10),
  //   dashPattern: const [10, 4],
  //   strokeCap: StrokeCap.round,
  //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
  //   color: Colors.blue.shade400,
  //     child: Column(children: [
  //       Icon(Icons.picture_as_pdf_sharp),
  //       Text(attachment, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(),)
  //     ],)
  // );
}

Future<void> openFile(String filename) async {
  if (!await launchUrl(
      // Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/download?file_name=$filename')
    ApiCalls().downloadFile(filename)
  )
  ) {
    throw Exception('Could not launch');
  }
}