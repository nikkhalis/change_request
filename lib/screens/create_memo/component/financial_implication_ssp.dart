import 'package:admin/models/payment_type_model.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../models/ssp_dialog_models.dart';
import '../../../responsive.dart';

class FinancialImplicationSSP extends StatefulWidget {

  Function callback;
  String pbtName;
  FinancialImplicationDialogSSP? dialogData;
  FinancialImplicationSSP({Key? key, required this.callback, required this.pbtName, this.dialogData}) : super(key: key);

  @override
  State<FinancialImplicationSSP> createState() => _FinancialImplicationSSPState();
}

class _FinancialImplicationSSPState extends State<FinancialImplicationSSP> {
  TextEditingController creditSold = TextEditingController();
  TextEditingController creditSoldNr = TextEditingController();
  TextEditingController cashSpent = TextEditingController();
  TextEditingController cashSpentNr = TextEditingController();
  TextEditingController supportMaintenanceAll = TextEditingController();
  TextEditingController supportMaintenanceAnnual = TextEditingController();
  TextEditingController creditTo = TextEditingController();
  TextEditingController billNumber = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isEditing = false;

  DateTime lastDayLastMonth = DateTime.utc(DateTime.now().year, DateTime.now().month, 1).subtract(Duration(days: 1));
  DateTime parkCreSoldReceivedDate = DateTime.utc(DateTime.now().year, DateTime.now().month, 1).subtract(Duration(days: 1));

  DateTime strToDt(String creditSoldDate){
    try {
      DateFormat("yyyy-MM-dd").parse(creditSoldDate);
    } catch (e, s) {
      print(s);
    }
    return DateFormat("yyyy-MM-dd").parse(creditSoldDate);
  }

  @override
  void initState(){
    creditSold.text = widget.dialogData != null ? widget.dialogData!.creditSold : '';
    creditSoldNr.text = widget.dialogData != null ? widget.dialogData!.creditSoldNr : '';
    cashSpent.text = widget.dialogData != null ? widget.dialogData!.cashSpent : '';
    cashSpentNr.text = widget.dialogData != null ? widget.dialogData!.cashSpentNr : '';
    supportMaintenanceAll.text = widget.dialogData != null ? widget.dialogData!.supportMaintenanceAll : '';
    supportMaintenanceAnnual.text = widget.dialogData != null ? widget.dialogData!.supportMaintenanceAnnual : '';
    creditTo.text = widget.dialogData != null ? widget.dialogData!.creditTo : '';
    billNumber.text = widget.dialogData != null ? widget.dialogData!.billNumber : '';
    parkCreSoldReceivedDate = widget.dialogData != null ? strToDt(widget.dialogData!.creditSoldDate) : DateTime.utc(DateTime.now().year, DateTime.now().month, 1).subtract(Duration(days: 1));
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.isDesktop(context) ? 30 : 10, vertical: Responsive.isDesktop(context) ? 15 : 10),
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Financial Implication', style: TextStyle(color: textColor,fontWeight: FontWeight.bold, fontSize: 16),),
                  IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close), tooltip: 'Close',)
                ],),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: Responsive.isDesktop(context) ? 30 : 10, horizontal: Responsive.isDesktop(context) ? 15 : 7),
                  decoration: BoxDecoration(
                  color: Colors.lightGreenAccent.shade100.withOpacity(0.2)
                ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('IN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),)],),
                    Row(children: [
                      Expanded(child: Text('Parking Credit Sold and Received (with reconciliation) as ', style: TextStyle(color: textColor,),maxLines: 5, softWrap: true,)),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.utc(DateTime.now().year, DateTime.now().month, 1),
                                lastDate: DateTime(DateTime.now().year, DateTime.now().month+1, 0)
                            ).then((value) {
                              setState(() {
                                parkCreSoldReceivedDate = value!;
                              });
                            });
                          },

                          child: Text('${parkCreSoldReceivedDate.day.toString().padLeft(2, '0')}/${parkCreSoldReceivedDate.month.toString().padLeft(2, '0')}/${parkCreSoldReceivedDate.year.toString().padLeft(2, '0')}', style: TextStyle(color: textColor,),),
                        ),
                      ),
                    ],),
                    TextFormField(
                        style: TextStyle(color: textColor),
                        controller: creditSold,
                        inputFormatters: <TextInputFormatter>[
                          CurrencyTextInputFormatter(
                            locale: 'en-MY',
                            decimalDigits: 2,
                            symbol: 'RM ',
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else if (!isEditing && !RegExp(r"[0-9]").hasMatch(value)){
                            return 'Please enter numbers only';
                          }
                          return null;
                        },
                        onChanged: (value){
                          isEditing = true;
                          if (_formKey.currentState!.validate()) {}
                        },
                        onEditingComplete: () {
                          if (_formKey.currentState!.validate()) {}
                          isEditing = false;
                        },
                        keyboardType: TextInputType.number,
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
                    SizedBox(height: 10,),
                    Text('Parking Credit Sold and Received on ${DateFormat.MMM().format(DateTime.now())} ${DateTime.now().year} (not yet reconcile)',style: TextStyle(color: textColor,),),
                    TextFormField(
                        style: TextStyle(color: textColor),
                        controller: creditSoldNr,
                        inputFormatters: <TextInputFormatter>[
                          CurrencyTextInputFormatter(
                            locale: 'en-MY',
                            decimalDigits: 2,
                            symbol: 'RM ',
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else if (!isEditing && !RegExp(r"[0-9]").hasMatch(value)){
                            return 'Please enter numbers only';
                          }
                          return null;
                        },
                        onChanged: (value){
                          isEditing = true;
                          if (_formKey.currentState!.validate()) {}
                        },
                        onEditingComplete: () {
                          if (_formKey.currentState!.validate()) {}
                          isEditing = false;
                        },
                        keyboardType: TextInputType.number,
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
                  ],),),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: Responsive.isDesktop(context) ? 30 : 10, horizontal: Responsive.isDesktop(context) ? 15 : 7),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent.shade100.withOpacity(0.2),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('OUT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),)],),
                    Text('Cash Spent to Buy SSP Prepaid Credits as of ${lastDayLastMonth.day.toString().padLeft(2, '0')}/${lastDayLastMonth.month.toString().padLeft(2, '0')}/${lastDayLastMonth.year.toString().padLeft(2, '0')}',style: TextStyle(color: textColor,),),
                    TextFormField(
                        style: TextStyle(color: textColor),
                        controller: cashSpent,
                        inputFormatters: <TextInputFormatter>[
                          CurrencyTextInputFormatter(
                            locale: 'en-MY',
                            decimalDigits: 2,
                            symbol: 'RM ',
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else if (!isEditing && !RegExp(r"[0-9]").hasMatch(value)){
                            return 'Please enter numbers only';
                          }
                          return null;
                        },
                        onChanged: (value){
                          isEditing = true;
                          if (_formKey.currentState!.validate()) {}
                        },
                        onEditingComplete: () {
                          if (_formKey.currentState!.validate()) {}
                          isEditing = false;
                        },
                        keyboardType: TextInputType.number,
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
                    SizedBox(height: 10,),
                    Text('Cash Spent to Buy SSP Prepaid Credits on ${DateFormat.MMM().format(DateTime.now())} ${DateTime.now().year} (not yet reconcile) ',style: TextStyle(color: textColor,),),
                    TextFormField(
                        style: TextStyle(color: textColor),
                        controller: cashSpentNr,
                        inputFormatters: <TextInputFormatter>[
                          CurrencyTextInputFormatter(
                            locale: 'en-MY',
                            decimalDigits: 2,
                            symbol: 'RM ',
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else if (!isEditing && !RegExp(r"[0-9]").hasMatch(value)){
                            return 'Please enter numbers only';
                          }
                          return null;
                        },
                        onChanged: (value){
                          isEditing = true;
                          if (_formKey.currentState!.validate()) {}
                        },
                        onEditingComplete: () {
                          if (_formKey.currentState!.validate()) {}
                          isEditing = false;
                        },
                        keyboardType: TextInputType.number,
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
                    SizedBox(height: 10,),
                    Text('Support Services and System Maintenance Payment to vendor (2018 - ${DateTime.now().year-1})',style: TextStyle(color: textColor,),),
                    TextFormField(
                        style: TextStyle(color: textColor),
                        controller: supportMaintenanceAll,
                        inputFormatters: <TextInputFormatter>[
                          CurrencyTextInputFormatter(
                            locale: 'en-MY',
                            decimalDigits: 2,
                            symbol: 'RM ',
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else if (!isEditing && !RegExp(r"[0-9]").hasMatch(value)){
                            return 'Please enter numbers only';
                          }
                          return null;
                        },
                        onChanged: (value){
                          isEditing = true;
                          if (_formKey.currentState!.validate()) {}
                        },
                        onEditingComplete: () {
                          if (_formKey.currentState!.validate()) {}
                          isEditing = false;
                        },
                        keyboardType: TextInputType.number,
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
                    SizedBox(height: 10,),
                    Text('Support Services and System Maintenance Payment to vendor (${DateTime.now().year})',style: TextStyle(color: textColor,),),
                    TextFormField(
                        style: TextStyle(color: textColor),
                        controller: supportMaintenanceAnnual,
                        inputFormatters: <TextInputFormatter>[
                          CurrencyTextInputFormatter(
                            locale: 'en-MY',
                            decimalDigits: 2,
                            symbol: 'RM ',
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else if (!isEditing && !RegExp(r"[0-9]").hasMatch(value)){
                            return 'Please enter numbers only';
                          }
                          return null;
                        },
                        onChanged: (value){
                          isEditing = true;
                          if (_formKey.currentState!.validate()) {}
                        },
                        onEditingComplete: () {
                          if (_formKey.currentState!.validate()) {}
                          isEditing = false;
                        },
                        keyboardType: TextInputType.number,
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
                    SizedBox(height: 10,),
                    Text('SSP Credit to: ${widget.pbtName}',style: TextStyle(color: textColor,),),
                    TextFormField(
                        style: TextStyle(color: textColor),
                        controller: creditTo,
                        inputFormatters: <TextInputFormatter>[
                          CurrencyTextInputFormatter(
                            locale: 'en-MY',
                            decimalDigits: 2,
                            symbol: 'RM ',
                          ),
                        ],
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else if (!isEditing && !RegExp(r"\D").hasMatch(value)){
                            return 'Please enter numbers only';
                          }
                          return null;
                        },
                        onChanged: (value){
                          isEditing = true;
                          if (_formKey.currentState!.validate()) {}
                        },
                        onEditingComplete: () {
                          if (_formKey.currentState!.validate()) {}
                          isEditing = false;
                        },
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
                    SizedBox(height: 10,),
                    Text('Bill Number:', style: TextStyle(color: textColor,),),
                    TextFormField(
                        style: TextStyle(color: textColor),
                        controller: billNumber,
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
                  ],),),
              ],),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: TextButton(
          onPressed: (){
            if (_formKey.currentState!.validate()) {
              widget.callback(creditSold.text.replaceAll(RegExp(r"[RM ,]+"), ''),'${parkCreSoldReceivedDate.year.toString()}-${parkCreSoldReceivedDate.month.toString().padLeft(2, '0')}-${parkCreSoldReceivedDate.day.toString().padLeft(2, '0')}',creditSoldNr.text.replaceAll(RegExp(r"[RM ,]+"), ''),cashSpent.text.replaceAll(RegExp(r"[RM ,]+"), ''),cashSpentNr.text.replaceAll(RegExp(r"[RM ,]+"), ''),supportMaintenanceAll.text.replaceAll(RegExp(r"[RM ,]+"), ''),supportMaintenanceAnnual.text.replaceAll(RegExp(r"[RM ,]+"), ''),creditTo.text.replaceAll(RegExp(r"[RM ,]+"), ''),billNumber.text.replaceAll(RegExp(r"[RM ,]+"), ''));
              Navigator.pop(context);
            }
          },
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Save', style: TextStyle(color: textButtonColor),),
          ],),
          style: TextButton.styleFrom(backgroundColor: buttonColor/*primaryColorLight*/, fixedSize: Size(double.infinity, 40)),
        ),
      ),
    );
  }
}
