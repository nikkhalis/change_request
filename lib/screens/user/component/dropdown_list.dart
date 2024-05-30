import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'user_lists.dart';

class DropdownList extends StatefulWidget {
  final Function(String, String)? callback;
  DropdownList({
    this.callback,
    Key? key,
  }) : super(key: key);

  @override
  State<DropdownList> createState() => _DropdownList();
}

class _DropdownList extends State<DropdownList> {

  String dropdownRoleValue = roleType.first;
  String dropdownDesignationValue = designationType.first;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Role: ', style: TextStyle(fontWeight: FontWeight.bold),),
        DropdownButton<String>(
          value: dropdownRoleValue,
          icon: const Icon(Icons.arrow_downward, color: textColor, size: 18,),
          elevation: 16,
          underline: Container(
            height: 2,
            color: Colors.blue,
          ),
          onChanged: (String? value) {
            setState(() {
              dropdownRoleValue = value!;
              widget.callback!(dropdownRoleValue, dropdownDesignationValue);
              print ('Role Selected: $dropdownRoleValue');
            });
          },
          items: roleType.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        SizedBox(width: 10,),
        Text('Designation: ', style: TextStyle(fontWeight: FontWeight.bold),),
        DropdownButton<String>(
          value: dropdownDesignationValue,
          icon: const Icon(Icons.arrow_downward, color: textColor, size: 18,),
          elevation: 16,
          underline: Container(
            height: 2,
            color: Colors.blue,
          ),
          onChanged: (String? value) {
            setState(() {
              dropdownDesignationValue = value!;
              widget.callback!(dropdownRoleValue, dropdownDesignationValue);
              print ('Designation Selected: $dropdownDesignationValue');
            });
          },
          items: designationType.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
