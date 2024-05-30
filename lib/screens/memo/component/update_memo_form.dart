import 'dart:convert';
import 'dart:io'; //not work for web

import 'package:admin/api_calls.dart';
import 'package:admin/models/approver_list_model.dart';
import 'package:admin/models/financial_implication_ssp_model.dart';
import 'package:admin/models/invoice_received_ssp_model.dart';
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
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../../models/memo_list_view.dart';
import '../../../models/memo_type_model.dart';
import '../../../responsive.dart';
import '../../create_memo/component/financial_implication_ssp.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class UpdateMemoForm extends StatefulWidget {
  // final navigatorKey;
  final MemoList memoItem;
  final Function(bool)? callback;
  const UpdateMemoForm({Key? key, required this.memoItem, this.callback}) : super(key: key);

  @override
  State<UpdateMemoForm> createState() => _UpdateMemoFormState();
}

class _UpdateMemoFormState extends State<UpdateMemoForm> {
  bool isLoaded = false;
  late Data memoDropdownValue;
  late String paymentApprovalToValue;
  late Approver approverDropdownValue;
  late Approver approver2DropdownValue;
  late Approver approver3DropdownValue;
  List<Approver> approverDropdownValueList = [];
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
  String? refNumErrorText;
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
    return isLoaded ? Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor/*secondaryColorLight*/,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('Memo Type', style: TextStyle(fontWeight: FontWeight.bold),),
              // Container(
              //   width: double.infinity,
              //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10.0),
              //     color: Colors.blueGrey.shade100.withOpacity(0.2),
              //   ),
              //   child: DropdownButton<Data>(
              //       isExpanded: true,
              //       value: memoDropdownValue,
              //       icon: const Icon(Icons.arrow_downward, color: textColor, size: 18,),
              //       elevation: 16,
              //       style: const TextStyle(color: Colors.white),
              //       underline: SizedBox(),
              //       // Container(
              //       //   height: 2,
              //       //   color: primaryColor/*primaryColorLight*/,
              //       // ),
              //       onChanged: (Data? value) {
              //         print(value?.typeName);
              //         // This is called when the user selects an item.
              //         if (value != null) {
              //           setState(() {
              //             isLoaded = false;
              //             approverListList = [];
              //             approverDropdownValueList = [];
              //             approverCounter = value.approverList.split(',').length;
              //           });
              //         }
              //       },
              //       items: memoType.data.map<DropdownMenuItem<Data>>((Data value) {
              //         return DropdownMenuItem<Data>(
              //             value: value,
              //             child: Row(children: [
              //               Text(value.typeName, style: TextStyle(color: textColor),)
              //             ],)
              //         );
              //       }).toList()
              //     // list.map<DropdownMenuItem<String>>((String value) {
              //     //   return DropdownMenuItem<String>(
              //     //     value: value,
              //     //     child: Row(children: [
              //     //       Text(value)
              //     //     ],),
              //     //   );
              //     // }).toList(),
              //   ),
              // ),
              // SizedBox(height: 5,),
              // memoDropdownValue.typeName == "SSP memo" ? paymentAppr() : SizedBox(),
              // SizedBox(height: 5,),
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
                  )
              ),
              SizedBox(height: 5,),
              Text('Reference Number', style: TextStyle(fontWeight: FontWeight.bold),),
              TextFormField(
                  style: TextStyle(color: textColor),
                  controller: refNumController,
                  enabled: widget.memoItem.refNum == "" ? true : false,
                  decoration: InputDecoration(
                      fillColor: Colors.blueGrey.shade100.withOpacity(0.2),
                      filled: true,
                      errorText: widget.memoItem.refNum == "" ? 'Ref num can only be updated once, please make sure to only put the confirmed ref num' : null,
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
                invoiceReceived(),
                financialImplicationSSP(),
              ],),
              // memoDropdownValue.typeName == "SSP memo" ? invoiceReceived() : SizedBox(),
              // Text('Supporting Document', style: TextStyle(fontWeight: FontWeight.bold),),
              // ListView.builder(
              //     physics: NeverScrollableScrollPhysics(),
              //     shrinkWrap: true,
              //     itemCount: fileNames.length,//attachmentFiles.length,
              //     itemBuilder: (context, index){
              //       return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              //         Text(fileNames[index]/*attachmentFiles[index].path.split("/").last*/, overflow: TextOverflow.ellipsis,),
              //       ],);
              //     }
              // ),
              SizedBox(height: 10,),
              // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              //   Text('Approvals List', style: TextStyle(fontWeight: FontWeight.bold),),
              //   IconButton(onPressed: (){
              //     setState(() {
              //       approverCounter = approverCounter + 1;
              //     });
              //   }, icon: Icon(Icons.add))
              // ],),
              // Text('Approvals List', style: TextStyle(fontWeight: FontWeight.bold),),
              // SizedBox(height: 10,),
              // ListView.builder(
              //     physics: NeverScrollableScrollPhysics(),
              //     shrinkWrap: true,
              //     itemCount: approverCounter,
              //     itemBuilder: (context, index){
              //       return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //         Text('${memoApproverTypeTitle(approverListList[index].approver[0].userType.toString(), memoDropdownValue.typeName)}', style: TextStyle(fontWeight: FontWeight.bold),),
              //         Container(
              //           width: double.infinity,
              //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10.0),
              //             color: Colors.blueGrey.shade100.withOpacity(0.2),
              //           ),
              //           child: DropdownButton<Approver>(
              //             isExpanded: true,
              //             value: approverDropdownValueList[index],
              //             icon: const Icon(Icons.arrow_downward, color: textColor, size: 18,),
              //             elevation: 16,
              //             style: const TextStyle(color: textColor),
              //             underline: SizedBox(),
              //             onChanged: null,
              //             items: approverListList[index].approver.map<DropdownMenuItem<Approver>>((Approver value) {
              //               return DropdownMenuItem<Approver>(
              //                 value: value,
              //                 child: Row(children: [
              //                   Text(value.name)
              //                 ],),
              //               );
              //             }).toList(),
              //           ),
              //         ),
              //       ],);
              //     }
              // ),
              SizedBox(height: 15,),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(backgroundColor: buttonColor/*primaryColorLight*/, fixedSize: Size(double.infinity, 40)),
            child: Text('Close', style: TextStyle(color: textButtonColor),),
          ),
          TextButton(
            onPressed: (){
              if (widget.memoItem.refNum == '') {
                if (refNumController.text == '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill the missing field', style: TextStyle(color: Colors.white),), backgroundColor: Colors.red,),
                  );
                }
                else {
                  checkMemoRef(refNumController.text).then((value) {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200,
                          color: secondaryColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text('Confirm To Submit?'),
                              SizedBox(height: 10,),
                              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: TextButton.styleFrom(backgroundColor: secondaryColor, fixedSize: Size(double.infinity, 40), shape: RoundedRectangleBorder(side: BorderSide(color: buttonColor), borderRadius: BorderRadius.circular(7))),
                                  child: Text('Cancel', style: TextStyle(color: primaryColor),),
                                ),
                                SizedBox(width: 10,),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    updateSSP(
                                      invReiRef: refNumController.text,
                                      invItem: invoiceReceivedDialogSSP!.invoiceItem,
                                      totalAmt: invoiceReceivedDialogSSP!.totalAmount,
                                      finImpRef: refNumController.text,
                                      creditSold: financialImplicationDialogSSP!.creditSold,
                                      creditSoldNr: financialImplicationDialogSSP!.creditSoldNr,
                                      creditSoldDate: financialImplicationDialogSSP!.creditSoldDate,
                                      cashSpent: financialImplicationDialogSSP!.cashSpent,
                                      cashSpentNr: financialImplicationDialogSSP!.cashSpentNr,
                                      supportMaintenanceAll: financialImplicationDialogSSP!.supportMaintenanceAll,
                                      supportMaintenanceAnnual: financialImplicationDialogSSP!.supportMaintenanceAnnual,
                                      creditTo: financialImplicationDialogSSP!.creditTo,
                                      billNumber: financialImplicationDialogSSP!.billNumber,
                                      memoId: widget.memoItem.id.toString(),
                                      memoTitle: memoTitleController.text,
                                      memoRefNum: refNumController.text,
                                    );
                                  },
                                  style: TextButton.styleFrom(backgroundColor: buttonColor, fixedSize: Size(double.infinity, 40)),
                                  child: Text('Confirm', style: TextStyle(color: textButtonColor),),
                                ),
                              ],),
                            ],
                          ),
                        );
                      },
                    );
                  }).onError((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Duplicate Ref Num', style: TextStyle(color: Colors.white),), backgroundColor: Colors.red,),
                    );
                  });
                }
              }
              else {
                updateSSP(
                  invReiRef: refNumController.text,
                  invItem: invoiceReceivedDialogSSP!.invoiceItem,
                  totalAmt: invoiceReceivedDialogSSP!.totalAmount,
                  finImpRef: refNumController.text,
                  creditSold: financialImplicationDialogSSP!.creditSold,
                  creditSoldNr: financialImplicationDialogSSP!.creditSoldNr,
                  creditSoldDate: financialImplicationDialogSSP!.creditSoldDate,
                  cashSpent: financialImplicationDialogSSP!.cashSpent,
                  cashSpentNr: financialImplicationDialogSSP!.cashSpentNr,
                  supportMaintenanceAll: financialImplicationDialogSSP!.supportMaintenanceAll,
                  supportMaintenanceAnnual: financialImplicationDialogSSP!.supportMaintenanceAnnual,
                  creditTo: financialImplicationDialogSSP!.creditTo,
                  billNumber: financialImplicationDialogSSP!.billNumber,
                  memoId: widget.memoItem.id.toString(),
                  memoTitle: memoTitleController.text,
                  memoRefNum: refNumController.text,
                );
              }
            },
            style: TextButton.styleFrom(backgroundColor: buttonColor/*primaryColorLight*/, fixedSize: Size(double.infinity, 40)),
            child: Text('Update', style: TextStyle(color: textButtonColor),),
          ),
        ],),
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
            child: Center(child: TextButton(onPressed: ()=> _finImpDialogSSP(context), child: Text('Edit details'),),)),
        SizedBox(height: 5,),
      ],),
    );
  }

  // Widget paymentAppr() {
  //   return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //     Text('Payment Approval To', style: TextStyle(fontWeight: FontWeight.bold),),
  //     Container(
  //       width: double.infinity,
  //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10.0),
  //         color: Colors.blueGrey.shade100.withOpacity(0.2),
  //       ),
  //       child: DropdownButton<String>(
  //           isExpanded: true,
  //           value: paymentApprovalToValue,
  //           icon: const Icon(Icons.arrow_downward, color: Colors.black87, size: 18,),
  //           elevation: 16,
  //           style: const TextStyle(color: Colors.white),
  //           underline: SizedBox(),
  //           onChanged: (String? value) {
  //             // This is called when the user selects an item.
  //             if (value != null){
  //               setState(() {
  //                 paymentApprovalToValue = value;
  //                 _streetSelection(context, value);
  //                 // memoTitleController.text = sspMemoTitleGen(value);
  //               });
  //             }
  //           },
  //           items: paymentApprovalTo.map<DropdownMenuItem<String>>((String value) {
  //             return DropdownMenuItem<String>(
  //                 value: value,
  //                 child: Row(children: [
  //                   Text(value, style: TextStyle(color: textColor))
  //                 ],)
  //             );
  //           }).toList()
  //       ),
  //     ),
  //     SizedBox(height: 5,),
  //   ],);
  // }

  void getData() {
    // print('data get');
    getFinancialImplicationData(widget.memoItem.approvalsRef).then((finImpData) {
      getInvoiceReceivedData(widget.memoItem.approvalsRef)
          .then((invReceivedData) {
            setState(() {
              String formattedDate = DateFormat('yyyy-MM-dd').format(DateFormat('E, d MMM yyyy HH:mm:ss').parse(finImpData.financialImpSsp[0].creditSoldDate));
              financialImplicationDialogSSP = FinancialImplicationDialogSSP(creditSold: finImpData.financialImpSsp[0].creditSold.toString(), creditSoldDate: formattedDate, creditSoldNr: finImpData.financialImpSsp[0].creditSoldNr.toString(), cashSpent: finImpData.financialImpSsp[0].cashSpent.toString(), cashSpentNr: finImpData.financialImpSsp[0].cashSpentNr.toString(), supportMaintenanceAll: finImpData.financialImpSsp[0].supportMaintenanceAll.toString(), supportMaintenanceAnnual: finImpData.financialImpSsp[0].supportMaintenanceAnnual.toString(), creditTo: finImpData.financialImpSsp[0].creditTo.toString(), billNumber: finImpData.financialImpSsp[0].billNumber.toString());
              invoiceReceivedDialogSSP = InvoiceReceivedDialogSSP(invoiceItem: invReceivedData.invoiceRecieved[0].item, totalAmount: invReceivedData.invoiceRecieved[0].totalAmount.toString(), invoiceTypeValue: invReceivedData.invoiceRecieved[0].type, );
              paymentApprovalToValue = invReceivedData.invoiceRecieved[0].paymentTo;
              memoTitleController.text = widget.memoItem.title;
              refNumController.text = widget.memoItem.refNum;
              isLoaded = true;
            });
      })
          .onError((error, stackTrace) {print(error);});
    }).onError((error, stackTrace) {print(error);});
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

  Future<FinancialImplicationSSPModel> getFinancialImplicationData(String memoRef) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    // print('memo ref fin imp: $memoRef');
    Uri url = ApiCalls().viewFinancialImplicationSSP(memoRef); //Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/memo_type/');
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      FinancialImplicationSSPModel data = FinancialImplicationSSPModel.fromJson(json.decode(response.body.toString()));
      return data;
    } else {
      return Future.error('Cannot read data');
    }
  }

  Future<InvoiceReceivedSSPModel> getInvoiceReceivedData(String memoRef) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    // print('memo ref inv received: $memoRef');
    Uri url = ApiCalls().viewInvoiceReceivedSSP(memoRef);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      InvoiceReceivedSSPModel data = InvoiceReceivedSSPModel.fromJson(json.decode(response.body.toString()));
      return data;
    } else {
      return Future.error('Cannot read data');
    }
  }

  Future<String> sendMail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    Uri url = ApiCalls().sendMail(email);//Uri.parse('$urlProd/sendMail?email=$email');
    // print(url);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    }else {
      return Future.error("cannot send email");
    }
    return response.body;
  }

  Future<String> checkMemoRef(String memoRefNum) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    final body = {
      'ref_num' : memoRefNum
    };
    Uri url = ApiCalls().checkRefNum();
    // print(url);
    var response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == "Duplicate ref num") {
        return Future.error('Duplicate Ref Num');
      } else {
        response.body;
      }

    }else {
      return Future.error("cannot update memo");
    }
    return response.body;
  }

  Future<String> updateMemoDetails(String memoId, String memoTitle, String memoRefNum) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    print("memoId: ${memoId}");
    final body = {
      'memo_id' : memoId,
      'memo_title' : memoTitle,
      'memo_ref_num' : memoRefNum
    };
    Uri url = ApiCalls().updateMemoDetails();
    // print(url);
    var response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    }else {
      return Future.error("cannot update memo");
    }
    return response.body;
  }

  Future<String> updateFinImpSsp(String finImpRef, String creditSold, String creditSoldNr, String creditSoldDate, String cashSpent, String cashSpentNr, String supportMaintenanceAll, String supportMaintenanceAnnual, String creditTo, String billNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    final body = {
      'fin_imp_ref' : finImpRef,
      'credit_sold' : creditSold,
      'credit_sold_nr' : creditSoldNr,
      'credit_sold_date' : creditSoldDate,
      'cash_spent' : cashSpent,
      'cash_spent_nr' : cashSpentNr,
      'support_maintenance_all' : supportMaintenanceAll,
      'support_maintenance_annual' : supportMaintenanceAnnual,
      'credit_to' : creditTo,
      'bill_number' : billNumber
    };
    Uri url = ApiCalls().updateFinImpSSP();
    // print(url);
    var response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    }else {
      return Future.error("cannot update fin imp");
    }
  }

  Future<String> updateInvReceivedSsp(String invReiRef, String invItem, String totalAmt) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization' : '${prefs.getString('token')}'
    };
    final body = {
      'inv_received_ref' : invReiRef,
      'invoice_item' : invItem,
      'total_amount' : totalAmt
    };
    Uri url = ApiCalls().updateInvReceivedSSP();
    // print(url);
    var response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    }else {
      return Future.error("cannot update fin imp");
    }
  }

  Future<void> _streetSelection(BuildContext context, String pbt) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Responsive.isDesktop(context) ? Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
            sspMemoType(context, 'On Street Parking', 'assets/images/on_street.png', pbt),
            sspMemoType(context, 'Off Street Parking', 'assets/images/off_street.png', pbt),
            sspMemoType(context, 'Parking Compound', 'assets/images/compound.png', pbt),
          ],) :
          SingleChildScrollView(
            child: Column(children: [
              sspMemoType(context, 'On Street Parking', 'assets/images/on_street.png', pbt),
              sspMemoType(context, 'Off Street Parking', 'assets/images/off_street.png', pbt),
              sspMemoType(context, 'Parking Compound', 'assets/images/compound.png', pbt),
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
            updateMemo: true,
            parkingType: parkingType,
            dialogData: invoiceReceivedDialogSSP,
            callback: (invoiceItem, totalAmount, invoiceTypeValue){
              invoiceReceivedDialogSSP = InvoiceReceivedDialogSSP(invoiceItem: invoiceItem, totalAmount: totalAmount, invoiceTypeValue: invoiceTypeValue);
            },),
        ),
      ),
    );
  }

  void updateSSP(
      {
        String invReiRef = '',
        String invItem = '',
        String totalAmt = '',
        String finImpRef = '',
        String creditSold = '',
        String creditSoldNr = '',
        String creditSoldDate = '',
        String cashSpent = '',
        String cashSpentNr = '',
        String supportMaintenanceAll = '',
        String supportMaintenanceAnnual = '',
        String creditTo = '',
        String billNumber = '',
        String memoId = '',
        String memoTitle = '',
        String memoRefNum = ''
      })
  {
    setState(() {
      isLoaded = false;
    });
    updateInvReceivedSsp(invReiRef, invItem, totalAmt)
        .then((value) {
          updateFinImpSsp(finImpRef, creditSold, creditSoldNr, creditSoldDate, cashSpent, cashSpentNr, supportMaintenanceAll, supportMaintenanceAnnual, creditTo, billNumber)
              .then((value) {
                updateMemoDetails(memoId, memoTitle, memoRefNum)
                    .then((value) {
                      setState(() {
                        isLoaded = true;
                        Navigator.pop(context);
                        // print('submitted');
                        widget.callback!(true);
                      });
                })
                    .onError((error, stackTrace) => null);
          })
              .onError((error, stackTrace) => null);
    })
        .onError((error, stackTrace) => null);
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

