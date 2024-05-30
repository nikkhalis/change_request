import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import '../../../constants.dart';
import '../../../models/ssp_dialog_models.dart';
import '../../../responsive.dart';

// Define invoiceTypes here or import it from wherever it's defined
final List<String> invoiceTypes = ["Type1", "Type2", "Type3"]; // Example list

class InvoiceReceivedSSP extends StatefulWidget {
  final Function callback;
  final InvoiceReceivedDialogSSP? dialogData;
  final String parkingType;
  final bool updateMemo;

  InvoiceReceivedSSP({
    Key? key,
    required this.callback,
    this.dialogData,
    this.parkingType = '',
    this.updateMemo = false,
  }) : super(key: key);

  @override
  State<InvoiceReceivedSSP> createState() => _InvoiceReceivedSSPState();
}

class _InvoiceReceivedSSPState extends State<InvoiceReceivedSSP> {
  late TextEditingController invoiceItem;
  late TextEditingController totalAmount;
  late String invoiceTypeValue;

  final _formKey = GlobalKey<FormState>();
  bool isEditing = false;

  @override
  void initState() {
    invoiceItem = TextEditingController(text: widget.dialogData?.invoiceItem ?? '');
    totalAmount = TextEditingController(text: widget.dialogData?.totalAmount ?? '');
    invoiceTypeValue = widget.dialogData?.invoiceTypeValue ?? widget.parkingType;
    super.initState();
  }

  @override
  void dispose() {
    invoiceItem.dispose();
    totalAmount.dispose();
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
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isDesktop(context) ? 30 : 10,
              vertical: Responsive.isDesktop(context) ? 15 : 10,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Invoice Received',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                        tooltip: 'Close',
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  invoiceType(widget.parkingType),
                  Text(
                    'Item',
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    style: TextStyle(color: textColor),
                    minLines: 5,
                    maxLines: null,
                    controller: invoiceItem,
                    decoration: InputDecoration(
                      fillColor: Colors.blueGrey.shade100.withOpacity(0.2),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Total Amount (RM)',
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    style: TextStyle(color: textColor),
                    controller: totalAmount,
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
                      } else if (!isEditing && !RegExp(r"[0-9]").hasMatch(value)) {
                        return 'Please enter numbers only';
                      }
                      return null;
                    },
                    onChanged: (value) {
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
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.callback(
                invoiceItem.text,
                totalAmount.text.replaceAll(RegExp(r"[RM ,]+"), ''),
                invoiceTypeValue,
              );
              Navigator.pop(context);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Save',
                style: TextStyle(color: textButtonColor),
              ),
            ],
          ),
          style: TextButton.styleFrom(
            backgroundColor: buttonColor,
            fixedSize: Size(double.infinity, 40),
          ),
        ),
      ),
    );
  }

  Widget invoiceType(String parkingType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Invoice Received Type',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.blueGrey.shade100.withOpacity(0.2),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: invoiceTypeValue,
            icon: const Icon(Icons.arrow_downward, color: textColor, size: 18),
            elevation: 16,
            style: const TextStyle(color: Colors.white),
            underline: SizedBox(),
            onChanged: widget.updateMemo
                ? null
                : (String? value) {
              // This is called when the user selects an item.
              if (value != null) {
                setState(() {
                  invoiceTypeValue = value;
                });
              }
            },
            items: invoiceTypes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    Text(
                      value,
                      style: TextStyle(color: textColor),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
