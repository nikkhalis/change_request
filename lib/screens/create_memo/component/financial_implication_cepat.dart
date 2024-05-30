import 'package:admin/models/payment_type_model.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';

class FinancialImplication extends StatefulWidget {

  PaymentTypeList? paymentTypeList;
  Function callback;
  Map<String,List<Map<String,List<TextEditingController>>>> finData;
  FinancialImplication({Key? key, required this.callback, this.finData = const{}, this.paymentTypeList}) : super(key: key);

  @override
  State<FinancialImplication> createState() => _FinancialImplicationState();
}

class _FinancialImplicationState extends State<FinancialImplication> {
  // Map<String, Map<String, List<TextEditingController>>> financialImplication = <String, Map<String, List<TextEditingController>>>{};
  Map<String,List<Map<String,List<TextEditingController>>>> financialImp = <String,List<Map<String,List<TextEditingController>>>>{};
  // List financialImplicationData = [];
  // List<String> detailsData = <String>[];
  // List<String> detailsDataTemp = <String>[];
  // Map<String,List<String>> tableData = <String,List<String>>{};
  // Map<String,List<String>> boostData = <String,List<String>>{};
  // Map<String,List<String>> FPXData = <String,List<String>>{};
  // Map<String,List<String>> grabData = <String,List<String>>{};
  // Map<String,List<String>> jomData = <String,List<String>>{};
  // Map<String,List<String>> kipleData = <String,List<String>>{};

  List<Map<String,List<String>>> listPBTDataBoost = [];
  List<Map<String,List<String>>> listPBTDataFPX = [];
  List<Map<String,List<String>>> listPBTDataGrab = [];
  List<Map<String,List<String>>> listPBTDataJom = [];
  List<Map<String,List<String>>> listPBTDataKiple = [];

  get localAuthorities => null;


  @override
  void initState(){
    super.initState();
    prepareInput(widget.finData);
    // print(widget.finData);
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.paymentTypeList!.paymentType.length,//paymentMethod.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: (){
                // for pmtMtd in financialImplication:
                // print(financialImplication);

                financialImp.forEach((payment, value) {
                  if (payment == 'Boost'){
                    value.asMap().forEach((index, pbtData) {
                      Map<String, List<String>> data = <String, List<String>>{};
                      // print("$payment : $value");
                      pbtData.forEach((key, value) {
                        List<String> dataString = <String>[];
                        value.forEach((element) {
                          dataString.add(element.text);
                        });
                        data = {key:dataString};
                      });
                      listPBTDataBoost.add(data);
                    });
                  } else if (payment == 'FPX') {
                    value.asMap().forEach((index, pbtData) {
                      Map<String, List<String>> data = <String, List<String>>{};
                      // print("$payment : $value");
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
                      // print("$payment : $value");
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
                      // print("$payment : $value");
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
                      // print("$payment : $value");
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

                // print({"Boost":listPBTDataBoost});
                // print({"FPX":listPBTDataFPX});
                // print({"Grab":listPBTDataGrab});
                // print({"Jom":listPBTDataJom});
                // print({"Kiple":listPBTDataKiple});

                // for(var payment in financialImplication.keys){
                  // financialImplication[payment]!.values.toList().asMap().forEach((index, value) {
                  //   // print("$index : ${value.first.text}");
                  //   // print(listPBTDataBoost[index]);
                  //   if (payment == 'Boost'){
                  //     value.asMap().forEach((index2, value) {
                  //       print("$index : $index2");
                  //       // listPBTDataBoost[index][index2] = value.text;
                  //     });
                  //   } else if (payment == 'FPX') {
                  //     value.asMap().forEach((index2, value) {
                  //       listPBTDataFPX[index][index2] = value.text;
                  //     });
                  //   } else if (payment == 'GrabPay') {
                  //     value.asMap().forEach((index2, value) {
                  //       listPBTDataGrab[index][index2] = value.text;
                  //     });
                  //   } else if (payment == 'JomPAY') {
                  //     value.asMap().forEach((index2, value) {
                  //       listPBTDataJom[index][index2] = value.text;
                  //     });
                  //   } else if (payment == 'Kiple') {
                  //     value.asMap().forEach((index2, value) {
                  //       listPBTDataKiple[index][index2] = value.text;
                  //     });
                  //   }
                  // });
                  // print(listPBTDataBoost);
                  // financialImplication[payment]!.forEach((key, value) {
                  //   List<String> pbtData = [];
                  //   print("$key: $value");
                  //   value.asMap().forEach((index, value) {
                  //     pbtData.add(value.text);
                  //   });
                  // });
                  // for(var table in financialImplication[payment]!.keys){
                  //   // print({payment:table});
                  //   detailsDataTemp = [];
                  //   for(var details in financialImplication[payment]![table]!){
                  //     // print(details.text);
                  //     // print(financialImplication[payment]![table]!.length);
                  //     detailsData.add(details.text);
                  //     detailsDataTemp.add(details.text);
                  //     // print(detailsDataTemp);
                  //   }
                  //   tableData.addAll({table:detailsDataTemp});
                  // }
                  // var dataTemp = {payment:tableData};
                  // if (payment == 'Boost'){
                  //   boostData.addAll(tableData);
                  // } else if (payment == 'FPX') {
                  //   FPXData.addAll(tableData);
                  // } else if (payment == 'GrabPay') {
                  //   grabData.addAll(tableData);
                  // } else if (payment == 'JomPAY') {
                  //   jomData.addAll(tableData);
                  // } else if (payment == 'Kiple') {
                  //   kipleData.addAll(tableData);
                  // }
                  // financialImplicationData.add(dataTemp);
                  // print(dataTemp);
                  // print(financialImplicationData);
                  // financialImplicationData.addAll({payment:tableData});
                // }
                // print(tableData);
                // print({"Boost" :financialImplicationData[0]["Boost"]});
                // print({"FPX" :financialImplicationData[0]["FPX"]});
                // print({"GrabPay" :financialImplicationData[0]["GrabPay"]});
                // print({"JomPAY" :financialImplicationData[0]["JomPAY"]});
                // print({"Kiple" :financialImplicationData[0]["Kiple"]});
                // print(financialImplicationData);
                // print({"Boost":boostData});
                // boostData.forEach((key, value) {
                //   print("$key : $value");
                // });
                // for (var value in boostData.values){
                //   print(value);
                //   value.asMap().forEach((i, value) {
                //     print('index=$i, value=$value');
                //   });
                // }
                // print({"FPX":FPXData});
                // print({"GrabPay":grabData});
                // print({"JomPAY":jomData});
                // print({"Kiple":kipleData});
                // print(detailsData.length);
                // boostData.
                // for (int i = 0; i < paymentMethod.length; i++){
                //   for (int j = 0; j < localAuthorities.length; j++){
                //     finData.add(saveFinImp(
                //         clt_amt: clt_amt,
                //         commision: commision,
                //         total_pmt: total_pmt,
                //         settlement_id: settlement_id,
                //         bank: bank,
                //         memo_ref: memo_ref,
                //         pbt: pbt,
                //         payment_opt: payment_opt
                //     ));
                //   }
                // }
                widget.callback(financialImp);
              }, icon: Icon(Icons.save),
              tooltip: 'Save Details',
            )
          ],
          title: TabBar(
            tabs: [
              ...widget.paymentTypeList!.paymentType.map((e) => Tab(child: Text(e.paymentName))).toList()
              // ...paymentMethod.map((e) => Tab(child: Text(e))).toList()
              // Tab(child: Text('FPX')),
              // Tab(child: Text('Boost')),
              // Tab(child: Text('GrabPay')),
              // Tab(child: Text('JomPay')),
              // Tab(child: Text('KiplePay')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ...widget.paymentTypeList!.paymentType.map((e) => dataTable(e.paymentName)).toList()
            // ...paymentMethod.map((e) => dataTable(e)).toList()
            // Icon(Icons.directions_car),
            // Icon(Icons.directions_transit),
            // Icon(Icons.directions_bike),
            // Icon(Icons.laptop_mac),
            // Icon(Icons.light),
          ],
        ),
      ),
    );

  }

  Widget dataTable(String tabName) {
    return   DataTable2(
      // onSelectAll: (checked) {
      //   setState(() {
      //     checklistBool.fillRange(0, checklistBool.length, checked);
      //     widget.callBack.call(checked!);
      //   });
      // },
      // showCheckboxColumn: true,
      columnSpacing: defaultPadding+2,
      minWidth: 600,
      columns: [
        DataColumn2(
          label: Text("PBT", style: TextStyle(fontWeight: FontWeight.bold),),
          size: ColumnSize.S,
        ),
        DataColumn(
          label: Text("COLLECTION AMOUNT (RM)", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text("COMMISSION", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn2(
            label: Text("TOTAL PAYMENT (RM)", style: TextStyle(fontWeight: FontWeight.bold)),
            size: ColumnSize.L
        ),
        DataColumn2(
            label: Text("SETTLEMENT ID", style: TextStyle(fontWeight: FontWeight.bold)),
            size: ColumnSize.L
        ),
        DataColumn2(
            label: Text("BANK", style: TextStyle(fontWeight: FontWeight.bold)),
            size: ColumnSize.L
        ),
        // DataColumn(label: Checkbox(
        //   onChanged: (bool){},
        //   value: false,
        // ))
      ],
      rows: List.generate(
        localAuthorities.length,// demoRecentFiles.length,
            (index) {
          for(int i = 0; i < localAuthorities.length; i++){
            // checklistBool.add(false);
          }
          return DataRow(
            // selected: checklistBool[index],
            // onSelectChanged: (checked) {
            //   // print('saje test');
            //   setState(() {
            //     if (checked!) {
            //       print('$index selected');
            //     } else {
            //       print('$index deselected');
            //     }
            //     // checklistBool[index] = checked!;
            //   });
            // },
            cells: [
              DataCell(Text(localAuthorities[index].toString(), style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(TextFormField(style: TextStyle(color: textColor),controller: financialImp[tabName]![index][localAuthorities[index].toString()]![0] /*financialImplication[tabName]!['collectionAmtList']![index]*/, decoration: InputDecoration(
                  // hintText: 'Email',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.blueGrey
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.blue
                      )
                  )
              ),)),
              DataCell(TextFormField(style: TextStyle(color: textColor),controller: financialImp[tabName]![index][localAuthorities[index].toString()]![1]/*financialImplication[tabName]!['commissionList']![index]*/, decoration: InputDecoration(
                // hintText: 'Email',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.blueGrey
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.blue
                      )
                  )
              ),)),
              DataCell(TextFormField(style: TextStyle(color: textColor),controller: financialImp[tabName]![index][localAuthorities[index].toString()]![2]/*financialImplication[tabName]!['totalPaymentList']![index]*/, decoration: InputDecoration(
                // hintText: 'Email',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.blueGrey
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.blue
                      )
                  )
              ),)),
              DataCell(TextFormField(style: TextStyle(color: textColor),controller: financialImp[tabName]![index][localAuthorities[index].toString()]![3]/*financialImplication[tabName]!['settlementIdList']![index]*/, decoration: InputDecoration(
                // hintText: 'Email',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.blueGrey
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.blue
                      )
                  )
              ),)),
              DataCell(TextFormField(style: TextStyle(color: textColor),controller: financialImp[tabName]![index][localAuthorities[index].toString()]![4]/*financialImplication[tabName]!['bankList']![index]*/,decoration: InputDecoration(
                // hintText: 'Email',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.blueGrey
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.blue
                      )
                  )
              ),))
              // DataCell(SizedBox()),
            ],
          );
        },
      ),
    );
  }

  prepareInput(Map<String,List<Map<String,List<TextEditingController>>>> finData) {
    if (finData.isNotEmpty){
      financialImp = finData;
    } else {
      //widget.paymentTypeList!.paymentType.forEach((element) {});
      /*paymentMethod*/widget.paymentTypeList!.paymentType.forEach((/*String pmtMtd*/element) {
        // List<TextEditingController> collectionAmtList = [];
        // List<TextEditingController> commissionList = [];
        // List<TextEditingController> totalPaymentList = [];
        // List<TextEditingController> settlementIdList = [];
        // List<TextEditingController> bankList = [];

        List<Map<String, List<TextEditingController>>> pbtDataList = <
            Map<String, List<TextEditingController>>>[];

        // if (finData.isNotEmpty){

        // localAuthorities.asMap().forEach((int index,String item) {
        //   print(finData[pmtMtd]![index]);
        //   pbtDataList.add({
        //     item: [
        //       TextEditingController(text: finData[pmtMtd]![index][item]![0]),
        //       TextEditingController(text: finData[pmtMtd]![index][item]![1]),
        //       TextEditingController(text: finData[pmtMtd]![index][item]![2]),
        //       TextEditingController(text: finData[pmtMtd]![index][item]![3]),
        //       TextEditingController(text: finData[pmtMtd]![index][item]![4])
        //     ]
        //   });
        // });
        // } else {
        localAuthorities.forEach((String item) {
          // listPBTDataBoost.add(['','','','','']);
          // listPBTDataFPX.add(['','','','','']);
          // listPBTDataJom.add(['','','','','']);
          // listPBTDataGrab.add(['','','','','']);
          // listPBTDataKiple.add(['','','','','']);
          pbtDataList.add({
            item: [
              TextEditingController(text: ""),
              TextEditingController(text: ""),
              TextEditingController(text: ""),
              TextEditingController(text: ""),
              TextEditingController(text: "")
            ]
          });


          // collectionAmtList.add(TextEditingController(text: ""));
          // commissionList.add(TextEditingController(text: ""));
          // totalPaymentList.add(TextEditingController(text: ""));
          // settlementIdList.add(TextEditingController(text: ""));
          // bankList.add(TextEditingController(text: ""));
        });
        // }

        financialImp.addAll({
          element.paymentName: pbtDataList
        });

        // print(financialImp);
        // financialImplication.addAll({
        //   pmtMtd: {
        //     'collectionAmtList': collectionAmtList,
        //     'commissionList': commissionList,
        //     'totalPaymentList': totalPaymentList,
        //     'settlementIdList': settlementIdList,
        //     'bankList': bankList
        //   }
        // });
      });
    }
  }
}
