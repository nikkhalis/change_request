import 'dart:convert';
import 'dart:io'; //not work for web

import 'package:admin/api_calls.dart';
import 'package:admin/models/approver_list_model.dart';
import 'package:admin/models/ssp_dialog_models.dart';
import 'package:admin/models/payment_type_model.dart';
import 'package:admin/routes.dart';
import 'package:admin/screens/create_memo/component/create_memo_title_generator.dart';
import 'package:admin/screens/create_memo/component/financial_implication_cepat.dart';
import 'package:admin/screens/create_memo/component/invoice_received.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../../models/memo_type_model.dart';
import '../../../responsive.dart';
import 'financial_implication_ssp.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class CreateMemoForm extends StatefulWidget {
  final navigatorKey;
  const CreateMemoForm({Key? key, required this.navigatorKey}) : super(key: key);

  @override
  State<CreateMemoForm> createState() => _CreateMemoFormState();
}

class _CreateMemoFormState extends State<CreateMemoForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLoaded = false;
  late Data memoDropdownValue;
  late String paymentApprovalToValue;
  late Approver approverDropdownValue;
  late Approver approver2DropdownValue;
  late Approver approver3DropdownValue;
  List<Approver> approverDropdownValueList = [];
  late MemoType memoType;
  late ApproverList approverList;
  late ApproverList approverList2;
  late ApproverList approverList3;
  List<ApproverList> approverListList = [];
  List<File> attachmentFiles = [];
  List<PlatformFile> attachmentFilesWeb = [];
  List<String> fileNames = [];
  List<bool> runtimeCheck = [];
  List<bool> uploadStatus = [];
  TextEditingController memoTitleController = TextEditingController();
  TextEditingController refNumController = TextEditingController();
  int approverCounter = 0;
  int userId = 0;
  Map<String,List<Map<String,List<TextEditingController>>>> financialImp = <String,List<Map<String,List<TextEditingController>>>>{};
  PaymentTypeList? paymentTypeList;
  FinancialImplicationDialogSSP? financialImplicationDialogSSP;
  InvoiceReceivedDialogSSP? invoiceReceivedDialogSSP;
  late BuildContext dialogContext;
  String parkingType = '';

  get paymentApprovalTo => null;
  // List<File> att

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
    return isLoaded ? Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor/*secondaryColorLight*/,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Memo Type', style: TextStyle(fontWeight: FontWeight.bold),),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.blueGrey.shade100.withOpacity(0.2),
              ),
              child: DropdownButton<Data>(
                  isExpanded: true,
                  value: memoDropdownValue,
                  icon: const Icon(Icons.arrow_downward, color: textColor, size: 18,),
                  elevation: 16,
                  style: const TextStyle(color: Colors.white),
                  underline: SizedBox(),
                  // Container(
                  //   height: 2,
                  //   color: primaryColor/*primaryColorLight*/,
                  // ),
                  onChanged: (Data? value) {
                    print(value?.typeName);
                    // This is called when the user selects an item.
                    if (value != null) {
                      setState(() {
                        isLoaded = false;
                        approverListList = [];
                        approverDropdownValueList = [];
                        approverCounter = value.approverList.split(',').length;
                      });
                      List<Future> approvalsListList = [];
                      for (int i = 0; i < approverCounter; i++){
                        approvalsListList.add(approverListAPI(value.approverList.split(',')[i]));
                        // approvalsListList.add(approverListAPI("${3+i}"));
                      }
                      Future.wait(approvalsListList).then((futurevalue){
                        futurevalue.forEach((approverList) {
                          ApproverList tempList = ApproverList.fromJson(jsonDecode(approverList));
                          if (tempList.approver.isNotEmpty) {
                            approverListList.add(tempList);
                            approverDropdownValueList.add(tempList.approver.first);
                          } else {
                            approverListList = [];
                          }
                        });
                        paymentTypeApi().then((paymentTypeData) {
                          setState(() {
                            isLoaded = true;
                            paymentTypeList = paymentTypeData;
                            memoDropdownValue = value;
                          });
                        }).onError((error, stackTrace){
                          print(error);
                          setState(() {
                            isLoaded = false;
                          });
                        });
                      });
                    }
                    // setState(() {
                    //   memoDropdownValue = value!;
                    //   approverCounter = value.approverList.split(',').length;
                    //   print('approver counter: $approverCounter');
                    //   // approverCounter = value.approverNumber;
                    // });
                  },
                  items: memoType.data.map<DropdownMenuItem<Data>>((Data value) {
                    return DropdownMenuItem<Data>(
                        value: value,
                        child: Row(children: [
                          Text(value.typeName, style: TextStyle(color: textColor),)
                        ],)
                    );
                  }).toList()
                // list.map<DropdownMenuItem<String>>((String value) {
                //   return DropdownMenuItem<String>(
                //     value: value,
                //     child: Row(children: [
                //       Text(value)
                //     ],),
                //   );
                // }).toList(),
              ),
            ),
            SizedBox(height: 5,),
            memoDropdownValue.typeName == "SSP memo" ? paymentAppr() : SizedBox(),
            SizedBox(height: 5,),
            Text('Memo Title', style: TextStyle(fontWeight: FontWeight.bold),),
            TextFormField(
              style: TextStyle(color: textColor),
              maxLength: 500,
              controller: memoTitleController,
              minLines: 1,
              maxLines: null,
              decoration: InputDecoration(
                  fillColor: Colors.blueGrey.shade100.withOpacity(0.2),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          width: 2, color: Colors.blueGrey
                      )
                  )
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cannot leave this empty';
                }
                return null;
              },
            ),
            SizedBox(height: 5,),
            Text('Reference Number', style: TextStyle(fontWeight: FontWeight.bold),),
            TextFormField(
              style: TextStyle(color: textColor),
              controller: refNumController,
                decoration: InputDecoration(
                    fillColor: Colors.blueGrey.shade100.withOpacity(0.2),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            width: 2, color: Colors.blueGrey
                        )
                    )
                )
            ),
            SizedBox(height: 5,),
            Row(children: [
              memoDropdownValue.typeName == "SSP memo" ? invoiceReceived() : SizedBox(),
              financialImplicationSSP(),
            ],),
            // memoDropdownValue.typeName == "SSP memo" ? invoiceReceived() : SizedBox(),
            Text('Supporting Document', style: TextStyle(fontWeight: FontWeight.bold),),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
                itemCount: fileNames.length,//attachmentFiles.length,
                itemBuilder: (context, index){
                  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(fileNames[index]/*attachmentFiles[index].path.split("/").last*/, overflow: TextOverflow.ellipsis,),
                    uploadStatus[index] ? IconButton(onPressed: (){
                      deleteFile(fileNames[index]/*attachmentFiles[index].path.split("/").last*/)
                          .then((value){
                          setState(() {
                            if (value == 'success') {
                              if (kIsWeb){
                                attachmentFilesWeb.removeAt(index);
                              } else {
                                attachmentFiles.removeAt(index);
                              }
                              fileNames.removeAt(index);
                            }
                          });
                      })
                          .onError((error, stackTrace) {});
                    }, icon: Icon(Icons.delete)) : Container(padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), height: 25, width: 25, child: CircularProgressIndicator(strokeWidth: 2,))
                  ],);
                }
            ),
            InkWell(
              onTap: () async {
                pickFile();
                // FilePickerResult? result = await FilePicker.platform.pickFiles(
                //   type: FileType.custom,
                //   allowMultiple: false,
                //   allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
                // );
                // if (result != null) {
                //   File file = File(result.files[0].path!);
                //   // controller.attachmentList[index] = file.path;
                // } else {
                //   // controller.attachmentList[index] = "";
                //   // User canceled the picker
                // }
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                dashPattern: const [10, 4],
                strokeCap: StrokeCap.round,
                color: Colors.blue.shade400,
                child: Container(
                  // width: 120,
                  // width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(5),
                  height: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.folder, color: Colors.blue, size: 40,),
                      const SizedBox(height: 15,),
                      Text(
                        'Add supporting document',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // SizedBox(height: 5,),
            // Text('Financial Implication', style: TextStyle(fontWeight: FontWeight.bold),),
            // Container(
            //     decoration: BoxDecoration(
            //       color: Colors.blueGrey.shade100.withOpacity(0.2),
            //       borderRadius: BorderRadius.circular(7)
            //     ),
            //     child: Center(child: TextButton(onPressed: ()=> memoDropdownValue.typeName == 'SSP memo' ? _finImpDialogSSP(context) : _showMyDialog(context), child: Text('Edit details'),),)),
            SizedBox(height: 10,),
            // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            //   Text('Approvals List', style: TextStyle(fontWeight: FontWeight.bold),),
            //   IconButton(onPressed: (){
            //     setState(() {
            //       approverCounter = approverCounter + 1;
            //     });
            //   }, icon: Icon(Icons.add))
            // ],),
            Text('Approvals List', style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: approverCounter,
                itemBuilder: (context, index){
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${memoApproverTypeTitle(approverListList[index].approver[0].userType.toString(), memoDropdownValue.typeName)}', style: TextStyle(fontWeight: FontWeight.bold),),
                    // Text('Approver ${index+1}', style: TextStyle(fontWeight: FontWeight.bold),),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.blueGrey.shade100.withOpacity(0.2),
                      ),
                      child: DropdownButton<Approver>(
                        isExpanded: true,
                        value: approverDropdownValueList[index],
                        icon: const Icon(Icons.arrow_downward, color: textColor, size: 18,),
                        elevation: 16,
                        style: const TextStyle(color: textColor),
                        underline: SizedBox(),
                        // Container(
                        //   height: 2,
                        //   color: primaryColor/*primaryColorLight*/,
                        // ),
                        onChanged: (Approver? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            approverDropdownValueList[index] = value!;
                          });
                        },
                        items: approverListList[index].approver.map<DropdownMenuItem<Approver>>((Approver value) {
                          return DropdownMenuItem<Approver>(
                            value: value,
                            child: Row(children: [
                              Text(value.name)
                            ],),
                          );
                        }).toList(),
                      ),
                    ),
                  ],);
                }
            ),
            // Text('Approver 1', style: TextStyle(fontWeight: FontWeight.bold),),
            // DropdownButton<Approver>(
            //   value: approverDropdownValue,
            //   icon: const Icon(Icons.arrow_downward),
            //   elevation: 16,
            //   style: const TextStyle(color: Colors.white),
            //   underline: Container(
            //     height: 2,
            //     color: /*primaryColor*/primaryColorLight,
            //   ),
            //   onChanged: (Approver? value) {
            //     // This is called when the user selects an item.
            //     setState(() {
            //       approverDropdownValue = value!;
            //     });
            //   },
            //   items: approverList.approver.map<DropdownMenuItem<Approver>>((Approver value) {
            //     return DropdownMenuItem<Approver>(
            //       value: value,
            //       child: Row(children: [
            //         Text(value.name)
            //       ],),
            //     );
            //   }).toList(),
            // ),
            // SizedBox(height: 5,),
            // Text('Approver 2', style: TextStyle(fontWeight: FontWeight.bold),),
            // DropdownButton<Approver>(
            //   value: approver2DropdownValue,
            //   icon: const Icon(Icons.arrow_downward),
            //   elevation: 16,
            //   style: const TextStyle(color: Colors.white),
            //   underline: Container(
            //     height: 2,
            //     color: /*primaryColor*/primaryColorLight,
            //   ),
            //   onChanged: (Approver? value) {
            //     // This is called when the user selects an item.
            //     setState(() {
            //       approver2DropdownValue = value!;
            //     });
            //   },
            //   items: approverList2.approver.map<DropdownMenuItem<Approver>>((Approver value) {
            //     return DropdownMenuItem<Approver>(
            //       value: value,
            //       child: Row(children: [
            //         Text(value.name)
            //       ],),
            //     );
            //   }).toList(),
            // ),
            // SizedBox(height: 5,),
            // Text('Approver 3', style: TextStyle(fontWeight: FontWeight.bold),),
            // DropdownButton<Approver>(
            //   value: approver3DropdownValue,
            //   icon: const Icon(Icons.arrow_downward),
            //   elevation: 16,
            //   style: const TextStyle(color: Colors.white),
            //   underline: Container(
            //     height: 2,
            //     color: /*primaryColor*/primaryColorLight,
            //   ),
            //   onChanged: (Approver? value) {
            //     // This is called when the user selects an item.
            //     setState(() {
            //       approver3DropdownValue = value!;
            //     });
            //   },
            //   items: approverList3.approver.map<DropdownMenuItem<Approver>>((Approver value) {
            //     return DropdownMenuItem<Approver>(
            //       value: value,
            //       child: Row(children: [
            //         Text(value.name)
            //       ],),
            //     );
            //   }).toList(),
            // ),
            SizedBox(height: 15,),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                onPressed: (){
                  if (_formKey.currentState!.validate() && invoiceReceivedDialogSSP != null && financialImplicationDialogSSP != null){
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        dialogContext = context;
                        return Dialog(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Lottie.asset(
                              'assets/lottie/loading.json',
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      },
                    );
                    memoDropdownValue.typeName == "SSP memo" ? saveDraftSSP() : submitCEPat();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please complete the invoice received and financial implication field', style: TextStyle(
                            color: Colors.white),),
                        backgroundColor: Colors.redAccent,),
                    );
                  }
                },
                style: TextButton.styleFrom(backgroundColor: secondaryColor, fixedSize: Size(double.infinity, 40), shape: RoundedRectangleBorder(side: BorderSide(color: buttonColor), borderRadius: BorderRadius.circular(7))),
                child: Text('Save Draft', style: TextStyle(color: buttonColor),),
              ),
              SizedBox(width: 10,),
              TextButton(
                onPressed: (){
                  if (_formKey.currentState!.validate()){
                    if(refNumController.text != ''){
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          dialogContext = context;
                          return Dialog(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Lottie.asset(
                                'assets/lottie/loading.json',
                                width: 200,
                                height: 200,
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        },
                      );
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in empty field before submit', style: TextStyle(
                              color: Colors.white),),
                          backgroundColor: Colors.redAccent,),
                      );
                    }
                    memoDropdownValue.typeName == "SSP memo" ? submitSSP() : submitCEPat();
                  } else {

                  }
                  // Future.wait(_processFinImp(financialImp)).then((value) {
                  //   // Navigator.pop(context);
                  // }).onError((error, stackTrace) {
                  //   print(error);
                  //   Navigator.pop(context);
                  // });
                },
                style: TextButton.styleFrom(backgroundColor: buttonColor/*primaryColorLight*/, fixedSize: Size(double.infinity, 40)),
                child: Text('Submit', style: TextStyle(color: textButtonColor),),
              ),
            ],),
          ],
        ),
      ),
    ) : Lottie.asset(
      'assets/lottie/loading.json',
      width: 200,
      height: 200,
      fit: BoxFit.fill,
    );
  }

  Widget invoiceReceived(){
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Invoice Received', style: TextStyle(fontWeight: FontWeight.bold),),
        Container(
            height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.blueGrey.shade100.withOpacity(0.2),
            ),
            child: Center(child: TextButton(onPressed: ()=> _invoiceReceivedDialogSSP(context), child: Text('Edit details'),),)),
        SizedBox(height: 5,),
      ],),
    );
  }

  Widget financialImplicationSSP(){
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Financial Implication', style: TextStyle(fontWeight: FontWeight.bold),),
        Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.blueGrey.shade100.withOpacity(0.2),
            ),
            child: Center(child: TextButton(onPressed: ()=> memoDropdownValue.typeName == 'SSP memo' ? _finImpDialogSSP(context) : _showMyDialog(context), child: Text('Edit details'),),)),
        SizedBox(height: 5,),
      ],),
    );
  }

  Widget paymentAppr() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Payment Approval To', style: TextStyle(fontWeight: FontWeight.bold),),
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.blueGrey.shade100.withOpacity(0.2),
        ),
        child: DropdownButton<String>(
            isExpanded: true,
            value: paymentApprovalToValue,
            icon: const Icon(Icons.arrow_downward, color: Colors.black87, size: 18,),
            elevation: 16,
            style: const TextStyle(color: Colors.white),
            underline: SizedBox(),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              if (value != null){
                setState(() {
                  paymentApprovalToValue = value;
                  _streetSelection(context, value);
                  // memoTitleController.text = sspMemoTitleGen(value);
                });
              }
            },
            items: paymentApprovalTo.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                  value: value,
                  child: Row(children: [
                    Text(value, style: TextStyle(color: textColor))
                  ],)
              );
            }).toList()
        ),
      ),
      SizedBox(height: 5,),
    ],);
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getKeys());

    setState(() {
      userId = prefs.getInt('user_id') ?? 0;
      // userType = prefs.getInt('user_type_id') ?? 0;
    });
    List<Future> approvalsListList = [];
    memoTypeAPI().then((value) {
      memoType = MemoType.fromJson(jsonDecode(value));
      memoDropdownValue = memoType.data.first;
      paymentApprovalToValue = paymentApprovalTo.first;
      approverCounter = memoType.data.first.approverList.split(',').length;
      for (int i = 0; i < approverCounter; i++){
        approvalsListList.add(approverListAPI(memoType.data.first.approverList.split(',')[i]));
        // approvalsListList.add(approverListAPI("${3+i}"));
      }
      Future.wait(approvalsListList).then((value){
        print('approver list: $value');
          value.forEach((approverList) {
            print(approverList);
            ApproverList tempList = ApproverList.fromJson(jsonDecode(approverList));
            if (tempList.approver.isNotEmpty) {
              approverListList.add(tempList);
              approverDropdownValueList.add(tempList.approver.first);
            } else {
              approverListList = [];
            }
          });
          paymentTypeApi().then((paymentTypeData) {
            setState(() {
              isLoaded = true;
              paymentTypeList = paymentTypeData;
            });
          }).onError((error, stackTrace){
            print(error);
            setState(() {
              isLoaded = false;
            });
          });
      });
      // approverListAPI("3").then((value){
      //   approverList = ApproverList.fromJson(jsonDecode(value));
      //   approverDropdownValue = approverList.approver.first;
      //   approverListAPI("4").then((value){
      //     approverList2 = ApproverList.fromJson(jsonDecode(value));
      //     approver2DropdownValue = approverList2.approver.first;
      //     approverListAPI("5").then((value){
      //       approverList3 = ApproverList.fromJson(jsonDecode(value));
      //       approver3DropdownValue = approverList3.approver.first;
      //       setState(() {
      //         isLoaded = true;
      //       });
      //     });
      //   });
      // });
    });
  }

  getFullname(String name) {
    if (name == 'MBSA') {
      return 'Majlis Bandaraya Shah Alam';
    }
    else if (name == 'MBPJ') {
      return 'Majlis Bandaraya Petaling Jaya';
    }
    else if (name == 'MBSJ') {
      return 'Majlis Bandaraya Subang Jaya';
    }
    else if (name == 'MPKj') {
      return 'Majlis Perbandaran Kajang';
    }
    else if (name == 'MPS') {
      return 'Majlis Perbandaran Selayang';
    }
    else if (name == 'MPK') {
      return 'Majlis Perbandaran Klang';
    }
    else if (name == 'MPAJ') {
      return 'Majlis Perbandaran Ampang Jaya';
    }
    else if (name == 'MPSp') {
      return 'Majlis Perbandaran Sepang';
    }
    else if (name == 'MPKL') {
      return 'Majlis Perbandaran Kuala Langat';
    }
    else if (name == 'MPKS') {
      return 'Majlis Perbandaran Kuala Selangor';
    }
    else if (name == 'MPHS') {
      return 'Majlis Perbandaran Hulu Selangor';
    }
    else if (name == 'MDSB') {
      return 'Majlis Daerah Sabak Bernam';
    }
    else if (name == 'SEMSB') {
      return 'Suasa Efektif (M) Sdn Bhd';
    }
    else {
      return '';
    }
  }

  Future<String> memoTypeAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    Uri url = ApiCalls().memoType(); //Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/memo_type/');
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {

    }
    return response.body;
  }

  Future<String> approverListAPI(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };

    Uri url = ApiCalls().approverList(type); //Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/approver_list/?type=$type');
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
    }
    return response.body;
  }

  Future<PaymentTypeList> paymentTypeApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    Uri url = ApiCalls().paymentType(); //Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/payment_type/');
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var result = PaymentTypeList.fromJson(jsonDecode(response.body));
      return result;
    } else {
      return Future.error('error');
    }
  }

  Future<String> createNewMemo() async {
    List joinedApprovals = [];
    approverDropdownValueList.forEach((approver) {
      joinedApprovals.add(approver.id);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    Uri url = ApiCalls().createNewMemo();
    final body = {
      'title' : memoTitleController.text,
      'refNumber' : refNumController.text,
      'memoType' : memoDropdownValue.id.toString(),
      'approvals_list' : joinedApprovals.join(',').toString(),
      'attachment' : fileNames.join(','),
      'creator' : userId.toString()
    };
    print(body);
    var response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      print (response.body);
      final data = jsonDecode(response.body);
      if (data['status'] == "success"){
        return 'success';
      } else {
        return Future.error('cannot submit');
      }

    } else {
      return Future.error('Error');
    }
    // var request = new http.MultipartRequest('POST', testUrl);
    // final httpImage = http.MultipartFile.fromBytes('file',await attachmentFiles[0].readAsBytes(), filename: attachmentFiles[0].path.split("/").last);
    // request.files.add(httpImage);
    // final response = await request.send();
    // // final response = await http.post(
    // //     testUrl,
    // //     headers: {"Content-Type":"multipart/form-data"},
    // //     body: {"file": await attachmentFiles[0].readAsBytes()},
    // //     encoding: Encoding.getByName("utf-8")
    // // );
    // if (response.statusCode == 200){
    //   response.stream.transform(utf8.decoder).listen((value) {
    //   });
    //   return "success";
    // } else {
    //   // Navigator.pop(context);
    //   return Future.error("failed");
    // }
  }

  Future<String> saveDraftMemo(String approvalRef) async {
    List joinedApprovals = [];
    approverDropdownValueList.forEach((approver) {
      joinedApprovals.add(approver.id);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    Uri url = ApiCalls().saveDraftMemo();
    final body = {
      'title' : memoTitleController.text,
      'refNumber' : refNumController.text,
      'memoType' : memoDropdownValue.id.toString(),
      'approvals_list' : joinedApprovals.join(',').toString(),
      'attachment' : fileNames.join(','),
      'creator' : userId.toString(),
      'approvals_ref' : approvalRef
    };
    print(body);
    var response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      print (response.body);
      final data = jsonDecode(response.body);
      if (data['status'] == "success"){
        return 'success';
      } else {
        return Future.error('cannot save');
      }

    } else {
      return Future.error('Error');
    }
  }

  Future<String> uploadFile(File attachment) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs = await SharedPreferences.getInstance();
    // Map<String, String> headers = {
    //   'Content-Type': 'application/json;charset=UTF-8',
    //   'Charset': 'utf-8',
    //   "Access-Control-Allow-Origin": "*",
    //   'Authorization' : '${prefs.getString('token')}'
    // };
    Uri url = ApiCalls().upload(); //Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/upload');
    var request = new http.MultipartRequest('POST', url);
    final httpImage = http.MultipartFile.fromBytes('file',await attachment.readAsBytes(), filename: attachment.path.split("/").last);
    request.files.add(httpImage);
    final response = await request.send();
    String fileName = '';
    if (response.statusCode == 200){
      // response.stream.transform(utf8.decoder).listen((value) {
      //   final temp = jsonDecode(value);
      // });
      final temp = await response.stream.transform(utf8.decoder).first.whenComplete(() => null);
      fileName = jsonDecode(temp)['fileName'];
      return fileName;
    } else {
      // Navigator.pop(context);
      return Future.error("failed");
    }
  }

  Future<String> uploadFileWeb(PlatformFile attachment, String filename) async {
    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*"
    };
    // final body = {
    //   'file': attachment.readStream!
    // };
    Uri url = ApiCalls().upload();//Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/upload');

    // var response = await http.post(url, body: body);
    // if (response.statusCode == 200) {
    //   return 'success';
    // } else {
    //   return Future.error('Error');
    // }

    var request = new http.MultipartRequest('POST', url,);
    final httpImage = http.MultipartFile('file', attachment.readStream!, attachment.size, filename: attachment.name,);
    request.files.add(httpImage);
    request.headers.addAll(headers);
    final response = await request.send();
    String fileName = '';
    String result = await response.stream.bytesToString();
    final jsonData = jsonDecode(result);

    if (response.statusCode == 200){
      // response.stream.transform(utf8.decoder).listen((value) {
      //   final temp = jsonDecode(value);
      // });
      // final temp = await response.stream.transform(utf8.decoder).first.whenComplete(() => null);
      fileName = jsonData['fileName'];
      return fileName;
    } else {
      // Navigator.pop(context);
      return Future.error("failed");
    }
  }

  Future<String> deleteFile(String filename) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    Uri url = ApiCalls().deleteFile(filename);//Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/delete?file_name=$filename');
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return 'success';
    } else {
      return Future.error('Error');
    }
  }

  Future<String> saveFinImp({
    required String clt_amt,
    required String commision,
    required String total_pmt,
    required String settlement_id,
    required String bank,
    required String memo_ref,
    required String pbt,
    required String payment_opt,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    final body = {
      'clt_amt': clt_amt,
      'commission': commision,
      'total_pmt': total_pmt,
      'settlement_id': settlement_id,
      'bank': bank,
      'memo_ref': memo_ref,
      'pbt': pbt,
      'payment_opt': payment_opt
    };
    Uri url = ApiCalls().insertFinImp();//Uri.parse('$urlProd/insert_financial_imp');
    var response = await http.post(url, body: body,headers: headers);
    if (response.statusCode == 200) {
      return 'success';
    } else {
      return Future.error('Error');
    }
  }

  Future<String> insertFinImpSSP({
    required String creditSold,
    required String creditSoldDate,
    required String creditSoldNr,
    required String cashSpent,
    required String cashSpentNr,
    required String supportMaintenanceAll,
    required String supportMaintenanceAnnual,
    required String creditTo,
    required String billNumber,
    required String memoRef
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    final body = {
      'credit_sold': creditSold,
      'credit_sold_date': creditSoldDate,
      'credit_sold_nr': creditSoldNr,
      'cash_spent': cashSpent,
      'cash_spent_nr': cashSpentNr,
      'support_maintenance_all': supportMaintenanceAll,
      'support_maintenance_annual': supportMaintenanceAnnual,
      'credit_to': creditTo,
      'bill_number': billNumber,
      'memo_ref': memoRef,//refNumController.text,
    };
    Uri url = ApiCalls().insertFinImpSSP();//Uri.parse('$urlProd/insert_financial_imp_ssp');
    print(body);
    var response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      return 'success';
    } else {
      return Future.error('Error');
    }
  }

  Future<String> insertInvReceivedSSP({
    required  String invoiceItem,
    required String totalAmount,
    required String invoiceTypeValue,
    required String memoRef,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    final body = {
      'item': invoiceItem,
      'total_amount': totalAmount,
      'type': invoiceTypeValue,
      'payment_to' : paymentApprovalToValue,
      'memo_ref': memoRef,//refNumController.text,
    };
    Uri url = ApiCalls().insertInvoiceReceivedSSP();//Uri.parse('$urlProd/insert_invoice_received_ssp');
    var response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      return 'success';
    } else {
      return Future.error('Error');
    }
  }

  Future<String> sendMail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    Uri url = ApiCalls().sendMail(email);//Uri.parse('$urlProd/sendMail?email=$email');
    print(url);
    var response = await http.get(url,headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    }else {
      return Future.error("cannot send email");
    }
    return response.body;
  }

  Future<void> _streetSelection(BuildContext context, String pbt) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Responsive.isDesktop(context) ? Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
            pbt == 'SEMSB' ? sspMemoType(context, 'All Street Parking', 'assets/images/all_street.png', pbt) : sspMemoType(context, 'On Street Parking', 'assets/images/on_street.png', pbt),
            pbt == 'SEMSB' ? SizedBox() : sspMemoType(context, 'Off Street Parking', 'assets/images/off_street.png', pbt),
            pbt == 'SEMSB' ? SizedBox() : sspMemoType(context, 'Parking Compound', 'assets/images/compound.png', pbt),
          ],) :
          SingleChildScrollView(
            child: Column(children: [
              pbt == 'SEMSB' ? sspMemoType(context, 'All Street Parking', 'assets/images/all_street.png', pbt) : sspMemoType(context, 'On Street Parking', 'assets/images/on_street.png', pbt),
              pbt == 'SEMSB' ? SizedBox() : sspMemoType(context, 'Off Street Parking', 'assets/images/off_street.png', pbt),
              pbt == 'SEMSB' ? SizedBox() : sspMemoType(context, 'Parking Compound', 'assets/images/compound.png', pbt),
            ],),
          ),
        ),
      ),
    );
  }

  Widget sspMemoType(BuildContext dialogContext, String typeName, String assetAddress, String pbt) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: (){
          memoTitleController.text = sspMemoTitleGen(pbt, typeName);
          parkingType = typeName;
          Navigator.pop(dialogContext);
        },
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(10),
          dashPattern: const [10, 4],
          strokeCap: StrokeCap.round,
          color: Colors.blue.shade400,
          child: Container(
            // width: 120,
            // width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(5),
            height: 170,
            width: 240,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(assetAddress, height: 120,),
                // Icon(Iconsax.folder, color: Colors.blue, size: 40,),
                const SizedBox(height: 15,),
                Text(
                  typeName,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickFile () async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(withReadStream: true, );

      if (result != null) {
        if (kIsWeb){
          setState(() {
            // attachmentFiles.add(File(result.files.single.path!));
            fileNames.add(result.files.single.name);
            uploadStatus.add(false);
            uploadFileWeb(result.files.single, result.files.single.name)
                .then((value) {
              setState(() {
                if (value != '') {
                  attachmentFilesWeb.add(result.files.single);
                  uploadStatus[uploadStatus.length - 1] = true;
                  fileNames[fileNames.length - 1] = value;
                } else {
                  // uploadStatus[uploadStatus.length-1] = false;
                  // attachmentFiles.removeLast();
                  fileNames.removeLast();
                  uploadStatus.removeLast();
                }
              });
            })
                .onError((error, stackTrace) {
              print(error);
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('File failed to upload', style: TextStyle(
                        color: Colors.white),),
                    backgroundColor: Colors.redAccent,),
                );
                // uploadStatus[uploadStatus.length-1] = false;
                // attachmentFiles.removeLast();
                fileNames.removeLast();
                uploadStatus.removeLast();
              });
            });
          });
        } else {
          setState(() {
            // attachmentFiles.add(File(result.files.single.path!));
            fileNames.add(result.files.single.name);
            uploadStatus.add(false);
            uploadFile(File(result.files.single.path!))
                .then((value) {
              setState(() {
                if (value != '') {
                  attachmentFiles.add(File(result.files.single.path!));
                  uploadStatus[uploadStatus.length - 1] = true;
                  fileNames[fileNames.length - 1] = value;
                } else {
                  // uploadStatus[uploadStatus.length-1] = false;
                  // attachmentFiles.removeLast();
                  fileNames.removeLast();
                  uploadStatus.removeLast();
                }
              });
            })
                .onError((error, stackTrace) {
              print(error);
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('File failed to upload', style: TextStyle(
                        color: Colors.white),),
                    backgroundColor: Colors.redAccent,),
                );
                // uploadStatus[uploadStatus.length-1] = false;
                // attachmentFiles.removeLast();
                fileNames.removeLast();
                // print(fileNames);
                uploadStatus.removeLast();
              });
            });
          });
        }
        // File file = File(result.files.single.path);
      } else {
        // User canceled the picker
      }
    } catch (e){
      print(e);
    }
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return paymentTypeList == null ? null :
      showDialog<void>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: FinancialImplication(callback: (dataReturn){
            setState(() {
              // print(dataReturn);
              financialImp.addAll(dataReturn);
            });
          },finData: financialImp, paymentTypeList: paymentTypeList,),
        ),
      ),
    );
  }

  Future<void> _finImpDialogSSP(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: FinancialImplicationSSP(
            pbtName: getFullname(paymentApprovalToValue),
            dialogData: financialImplicationDialogSSP,
            callback: (creditSold,creditSoldDate,creditSoldNr,cashSpent,cashSpentNr,supportMaintenanceAll,supportMaintenanceAnnual,creditTo,billNumber){
              financialImplicationDialogSSP = FinancialImplicationDialogSSP(creditSold: creditSold, creditSoldDate: creditSoldDate.toString(), creditSoldNr: creditSoldNr, cashSpent: cashSpent, cashSpentNr: cashSpentNr, supportMaintenanceAll: supportMaintenanceAll, supportMaintenanceAnnual: supportMaintenanceAnnual, creditTo: creditTo, billNumber: billNumber);
            },),
        ),
      ),
    );
  }

  Future<void> _invoiceReceivedDialogSSP(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: InvoiceReceivedSSP(
            parkingType: parkingType,
            dialogData: invoiceReceivedDialogSSP,
            callback: (invoiceItem, totalAmount, invoiceTypeValue){
              invoiceReceivedDialogSSP = InvoiceReceivedDialogSSP(invoiceItem: invoiceItem, totalAmount: totalAmount, invoiceTypeValue: invoiceTypeValue);
            },),
        ),
      ),
    );
  }

  Future<void> _invReceivedDialogSSP(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: FinancialImplicationSSP(callback: (){}, pbtName: 'MBSJ',),
        ),
      ),
    );
  }
  
  List<Future> _processFinImp(Map<String,List<Map<String,List<TextEditingController>>>> finImp) {
    List<Map<String,List<String>>> listPBTDataBoost = [];
    List<Map<String,List<String>>> listPBTDataFPX = [];
    List<Map<String,List<String>>> listPBTDataGrab = [];
    List<Map<String,List<String>>> listPBTDataJom = [];
    List<Map<String,List<String>>> listPBTDataKiple = [];
    
    List<Future> financialDataTemp = [];
    
    finImp.forEach((payment, value) {
      if (payment == 'Boost'){
        value.asMap().forEach((index, pbtData) {
          Map<String, List<String>> data = <String, List<String>>{};
          pbtData.forEach((key, value) {
            List<String> dataString = <String>[];
            value.forEach((element) {
              dataString.add(element.text);
            });
            data = {key:dataString};
            financialDataTemp.add(saveFinImp(clt_amt: dataString[0], commision: dataString[1], total_pmt: dataString[2], settlement_id: dataString[3], bank: dataString[4], memo_ref: refNumController.text, pbt: key, payment_opt: "1"));
          });
          listPBTDataBoost.add(data);
        });
      } else if (payment == 'FPX') {
        value.asMap().forEach((index, pbtData) {
          Map<String, List<String>> data = <String, List<String>>{};
          pbtData.forEach((key, value) {
            List<String> dataString = <String>[];
            value.forEach((element) {
              dataString.add(element.text);
            });
            data = {key:dataString};
          });
          listPBTDataFPX.add(data);
        });
      } else if (payment == 'GrabPay') {
        value.asMap().forEach((index, pbtData) {
          Map<String, List<String>> data = <String, List<String>>{};
          pbtData.forEach((key, value) {
            List<String> dataString = <String>[];
            value.forEach((element) {
              dataString.add(element.text);
            });
            data = {key:dataString};
          });
          listPBTDataGrab.add(data);
        });
      } else if (payment == 'JomPAY') {
        value.asMap().forEach((index, pbtData) {
          Map<String, List<String>> data = <String, List<String>>{};
          pbtData.forEach((key, value) {
            List<String> dataString = <String>[];
            value.forEach((element) {
              dataString.add(element.text);
            });
            data = {key:dataString};
          });
          listPBTDataJom.add(data);
        });
      } else if (payment == 'Kiple') {
        value.asMap().forEach((index, pbtData) {
          Map<String, List<String>> data = <String, List<String>>{};
          pbtData.forEach((key, value) {
            List<String> dataString = <String>[];
            value.forEach((element) {
              dataString.add(element.text);
            });
            data = {key:dataString};
          });
          listPBTDataKiple.add(data);
        });
      }
    });

    return financialDataTemp;
  }

  void submitCEPat() {
    createNewMemo().then((value) {
      if (value == "success"){
        // Navigator.pop(context);
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
                    'assets/lottie/success.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.fill,
                  ),
                  Text('Memo submitted'),
                  TextButton(onPressed: (){Navigator.pop(context);widget.navigatorKey.currentState!.pushNamed(routeCreateMemo);}, child: Text('Close'))
                ],
              ),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error to submit', style: TextStyle(
                color: Colors.white),),
            backgroundColor: Colors.redAccent,),
        );
      }
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error to submit', style: TextStyle(
              color: Colors.white),),
          backgroundColor: Colors.redAccent,),
      );
    });
  }

  void submitSSP(){
    createNewMemo().then((value) {
      if (value == "success" && financialImplicationDialogSSP != null){
        // print("Credit SOld Date: ${financialImplicationDialogSSP!.creditSoldDate}");
        insertFinImpSSP(
            creditSold: financialImplicationDialogSSP!.creditSold,
            creditSoldDate: financialImplicationDialogSSP!.creditSoldDate,
            creditSoldNr: financialImplicationDialogSSP!.creditSoldNr,
            cashSpent: financialImplicationDialogSSP!.cashSpent,
            cashSpentNr: financialImplicationDialogSSP!.cashSpentNr,
            supportMaintenanceAll: financialImplicationDialogSSP!.supportMaintenanceAll,
            supportMaintenanceAnnual: financialImplicationDialogSSP!.supportMaintenanceAnnual,
            creditTo: financialImplicationDialogSSP!.creditTo,
            billNumber: financialImplicationDialogSSP!.billNumber,
            memoRef: refNumController.text
        ).then((value) {
          if (value == "success" && invoiceReceivedDialogSSP != null){
            insertInvReceivedSSP(
                invoiceItem: invoiceReceivedDialogSSP!.invoiceItem,
                totalAmount: invoiceReceivedDialogSSP!.totalAmount,
                invoiceTypeValue: invoiceReceivedDialogSSP!.invoiceTypeValue,
                memoRef: refNumController.text
            ).then((value) {
              if (value == "success"){
                // Navigator.pop(context);
                sendMail(approverDropdownValueList[0].email)
                    .then((value) => showDialog<void>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/lottie/success.json',
                            width: 200,
                            height: 200,
                            fit: BoxFit.fill,
                          ),
                          Text('Memo submitted'),
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                            Navigator.pop(dialogContext);
                            widget.navigatorKey.currentState!.pushNamed(routeCreateMemo);
                            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> DashboardScreen()), (route) => false);
                            }, child: Text('Close'))
                        ],
                      ),
                    ),
                  ),
                ))
                    .onError((error, stackTrace) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error: Code SE', style: TextStyle(
                        color: Colors.white),),
                    backgroundColor: Colors.redAccent,),
                ));
                // showDialog<void>(
                //   context: context,
                //   builder: (BuildContext context) => Dialog(
                //     child: Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           Lottie.asset(
                //             'assets/lottie/success.json',
                //             width: 200,
                //             height: 200,
                //             fit: BoxFit.fill,
                //           ),
                //           Text('Memo submitted'),
                //           TextButton(onPressed: (){Navigator.pop(context);Navigator.pop(context);}, child: Text('Close'))
                //         ],
                //       ),
                //     ),
                //   ),
                // );
              }
            }).onError((error, stackTrace) {print('Error in invoice received');}); // on error for invoice received
          } else {

          }
        }).onError((error, stackTrace) {print('Error in financial implication');}); // on error for financial implication
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error to submit FI', style: TextStyle(
                color: Colors.white),),
            backgroundColor: Colors.redAccent,),
        );
      }
    }).onError((error, stackTrace) {
      // Navigator.pop(context);
      print(error);
      print(stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error to submit CM', style: TextStyle(
              color: Colors.white),),
          backgroundColor: Colors.redAccent,),
      );
    });
  }

  void saveDraftSSP(){
    String refNumSave = "ref${DateTime.now()}";
    saveDraftMemo(refNumSave).then((value) {
      if (value == "success" && financialImplicationDialogSSP != null){
        insertFinImpSSP(
            creditSold: financialImplicationDialogSSP!.creditSold,
            creditSoldDate: financialImplicationDialogSSP!.creditSoldDate,
            creditSoldNr: financialImplicationDialogSSP!.creditSoldNr,
            cashSpent: financialImplicationDialogSSP!.cashSpent,
            cashSpentNr: financialImplicationDialogSSP!.cashSpentNr,
            supportMaintenanceAll: financialImplicationDialogSSP!.supportMaintenanceAll,
            supportMaintenanceAnnual: financialImplicationDialogSSP!.supportMaintenanceAnnual,
            creditTo: financialImplicationDialogSSP!.creditTo,
            billNumber: financialImplicationDialogSSP!.billNumber,
            memoRef: refNumSave
        ).then((value) {
          if (value == "success" && invoiceReceivedDialogSSP != null){
            insertInvReceivedSSP(
                invoiceItem: invoiceReceivedDialogSSP!.invoiceItem,
                totalAmount: invoiceReceivedDialogSSP!.totalAmount,
                invoiceTypeValue: invoiceReceivedDialogSSP!.invoiceTypeValue,
                memoRef: refNumSave
            ).then((value) {
              if (value == "success"){
                // Navigator.pop(context);
                sendMail(approverDropdownValueList[0].email)
                    .then((value) => showDialog<void>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/lottie/success.json',
                            width: 200,
                            height: 200,
                            fit: BoxFit.fill,
                          ),
                          Text('Memo submitted'),
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                            Navigator.pop(dialogContext);
                            widget.navigatorKey.currentState!.pushNamed(routeCreateMemo);
                            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> DashboardScreen()), (route) => false);
                          }, child: Text('Close'))
                        ],
                      ),
                    ),
                  ),
                ))
                    .onError((error, stackTrace) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error: Code SE', style: TextStyle(
                        color: Colors.white),),
                    backgroundColor: Colors.redAccent,),
                ));
              }
            }).onError((error, stackTrace) {print('Error in invoice received');}); // on error for invoice received
          } else {

          }
        }).onError((error, stackTrace) {print('Error in financial implication');}); // on error for financial implication
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error to submit FI', style: TextStyle(
                color: Colors.white),),
            backgroundColor: Colors.redAccent,),
        );
      }
    }).onError((error, stackTrace) {

      print(error);
      print(stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error to submit SM', style: TextStyle(
              color: Colors.white),),
          backgroundColor: Colors.redAccent,),
      );
    });
  }

  String memoApproverTypeTitle(String approverType, String memoType) {
    if (memoType == "SSP memo") {
      if (approverType == '3'){
        return 'Joinly Verified By';
      } else if (approverType == "4"){
        return 'Recomended By';
      } else if (approverType == "5") {
        return 'Approved By';
      } else {
        return 'Approver';
      }
    } else if (memoType == "CEPat memo") {
      return "Approver";
    } else {
      return "Approver";
    }
  }
}

