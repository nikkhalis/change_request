import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import 'package:admin/models/user_list_view.dart';

import 'package:http/http.dart' as http;
import '../../../models/user_data_model.dart';
import 'dropdown.dart';

class UserLists extends StatefulWidget {
  final Function(bool) callBack;
  final UserListView? userListView;

  const UserLists({
    Key? key,
    required this.callBack,
    required this.userListView
  }) : super(key: key);

  @override
  State<UserLists> createState() => _UserListsState();
}

const List<String> roleType = <String>['-', 'Admin', 'Approver', 'Requestor'];
const List<String> designationType = <String>['-', 'Internship', 'Admin', 'Managing Director', 'Head, Stakeholders and Program Management',
  'Team Lead, Smart Applications', 'Head, Finance'];

class _UserListsState extends State<UserLists>{

  List<bool> checklistBool = [];
  List<UserList>? userListViewNew;
  bool idSortAscending = true;
  bool dateSortAscending = true;
  final _formKey = GlobalKey<FormState>();
  late UserData userData;

  // Create a variable to store the currently selected item.
  String dropdownRoleValue = roleType.first;
  String dropdownDesignationValue = designationType.first;

  @override
  void initState(){
    super.initState();
    userListViewNew = widget.userListView?.userList;
  }

  @override
  void dispose() {
    super.dispose();
    checklistBool.clear();
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor/*secondaryColorLight*/,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text("Memo Lists",
            //   style: Theme.of(context).textTheme.titleMedium,
            // ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: double.infinity,
              child: DataTable2(
                showCheckboxColumn: false,
                columnSpacing: defaultPadding,
                minWidth: 600,
                columns: [
                  DataColumn2(
                      label: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Id",  maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: textColor,),),
                          Icon(idSortAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down)],),
                      size: ColumnSize.S,
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          idSortAscending = !idSortAscending;
                          if (idSortAscending) {
                            userListViewNew?.sort((a,b) => a.usersId.compareTo(b.usersId));
                          } else {
                            dateSortAscending = true;
                            userListViewNew?.sort((a,b) => b.usersId.compareTo(a.usersId));
                          }

                        });
                      }
                  ),
                  DataColumn2(
                      label: Text("Name", maxLines: 2, overflow: TextOverflow.ellipsis,),
                      size: ColumnSize.L
                  ),
                  DataColumn2(
                      label: Text("Email", maxLines: 2, overflow: TextOverflow.ellipsis,),
                      size: ColumnSize.L
                  ),
                  DataColumn2(
                      label: Text("Phone Number(+60)", maxLines: 2, overflow: TextOverflow.ellipsis,),
                      size: ColumnSize.L,
                  ),
                  DataColumn2(
                      label: Text("Role", maxLines: 2, overflow: TextOverflow.ellipsis,),
                      size: ColumnSize.L
                  ),
                  DataColumn2(
                      label: Text("Designation", maxLines: 2, overflow: TextOverflow.ellipsis,),
                      size: ColumnSize.L
                  ),
                  DataColumn2(
                      label: Text("Option", maxLines: 2, overflow: TextOverflow.ellipsis,),
                      size: ColumnSize.L
                  ),
                ],
                rows: List.generate(
                  userListViewNew!.length,// demoRecentFiles.length,
                      (index) {
                    for(int i = 0; i < userListViewNew!.length; i++){
                      checklistBool.add(false);
                    }
                    return DataRow(
                      selected: checklistBool[index],
                      onSelectChanged: (checked) {
                        setState(() {
                          if (checked!) {
                            print('$index selected');
                          } else {
                            print('$index deselected');
                          }
                          checklistBool[index] = checked!;
                        });
                      },
                      cells: [
                        DataCell(
                          Text(
                            userListViewNew![index].usersId.toString(),
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        DataCell(Text(userListViewNew![index].name, maxLines: 2, overflow: TextOverflow.ellipsis,),),
                        DataCell(Text(userListViewNew![index].email, maxLines: 2, overflow: TextOverflow.ellipsis,),),
                        DataCell(Text(userListViewNew![index].phoneNum.toString(), maxLines: 2, overflow: TextOverflow.ellipsis,),),
                        DataCell(Text(userListViewNew![index].role, maxLines: 2, overflow: TextOverflow.ellipsis,),),
                        DataCell(Text(userListViewNew![index].designation, maxLines: 2, overflow: TextOverflow.ellipsis,),),
                        DataCell(
                          Row(
                            children: [
                              TextButton(
                                onPressed: (){
                                  String? selectedId = userListViewNew![index].usersId.toString();
                                  print('Selected Id: $selectedId');

                                  if (selectedId != 0){
                                    _showDeleteDialog(context, userListViewNew![index]);
                                  } else {
                                    print('No data found');
                                  }
                                },
                                child:
                                Icon(Icons.delete, color: redColor, size: 20.0,),

                              ),
                              SizedBox(width: 3,),
                              TextButton(
                                onPressed: (){
                                  // Search for the dropdown value.
                                  String? selectedId = userListViewNew![index].usersId.toString();
                                  print('Selected Id: $selectedId');

                                  if (selectedId != 0){
                                    _showEditUserDialog(context, userListViewNew![index]);
                                  } else {
                                    print('No data found');
                                  }
                                },
                                child:
                                Icon(Icons.edit, color: blueColor, size: 20.0,),

                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
  }

  void _showEditUserDialog(BuildContext context, UserList userData) async{

    try{
      // userData = await getUserDataAPI(selectedId);
      // dropdownRoleValue = userData.role;
      // dropdownDesignationValue = userData.designation;

      String id = userData.usersId.toString();
      String name = userData.name;
      String email = userData.email;
      String phoneNum = userData.phoneNum.toString();
      String role = userData.role;
      String designation = userData.designation;

      TextEditingController nameController = TextEditingController(text: name);
      TextEditingController emailController = TextEditingController(text: email);
      TextEditingController phoneNumController = TextEditingController(text: phoneNum);
      // String dropdownRoleValue = role.toString();
      // String dropdownDesignationValue = designation.toString();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // title: Text('ADD NEW USER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            contentPadding: EdgeInsets.all(20),
            content: SingleChildScrollView(
              child: SizedBox(
                width: 800,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Add input fields for user data here

                      Text('EDIT USER DETAILS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      SizedBox(height: 10,),
                      Text('Name: ', style: TextStyle(fontWeight: FontWeight.bold),),
                      TextFormField(
                        style: TextStyle(color: textColor),
                        maxLength: 50,
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else if (!RegExp(r"^[a-zA-Z]+").hasMatch(value)){
                            return 'Please enter alphabets only';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Name',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.blueGrey
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.blue
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text('Email: ', style: TextStyle(fontWeight: FontWeight.bold),),
                      TextFormField(
                        style: TextStyle(color: textColor),
                        maxLength: 30,
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                            return 'Invalid SSDU email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Email',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.blueGrey
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                width: 2, color: Colors.blue
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text('Phone Number(60+): ', style: TextStyle(fontWeight: FontWeight.bold),),
                      TextFormField(
                        style: TextStyle(color: textColor),
                        maxLength: 12,
                        controller: phoneNumController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Cannot be left empty';
                          } else if (!RegExp(r"^[+\d]+$").hasMatch(value)){
                            return 'Only numbers allowed';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.blueGrey
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.blue
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Dropdown(role, designation),
                    ],),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // Close dialog
                child: Text('Cancel'),
              ),
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle user creation logic here
                      // Navigator.of(context).pop();
                      // Close dialog after creation

                      if (_formKey.currentState!.validate() && role != '-' && designation != '-') {
                        _showDialog(context, id, nameController, emailController, phoneNumController, role, designation);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to update user')),
                        );
                      }
                      },
                    child: Text('Update User'),
                  ),
                ],
              ),
            ],
          );
        },
      );
    } catch (error){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to retrieve user data')),
      );
      print(error);
      return;
    }
  }

  Widget Dropdown(String role, String designation){
    return Row(
      children: [
        Text('Role: ', style: TextStyle(fontWeight: FontWeight.bold),),
        DropdownButton<String>(
          value: role,
          icon: const Icon(Icons.arrow_downward, color: textColor, size: 18,),
          elevation: 16,
          underline: Container(
            height: 2,
            color: Colors.blue,
          ),
          onChanged: (String? value) {
            setState(() {
              role = value!;
              print ('Role Selected: $role');
            });
          },
          items: roleType.map<DropdownMenuItem<String>>((String roleType) {
            return DropdownMenuItem(
              value: roleType,
              child: Text(roleType),
            );
          }).toList(),
        ),
        SizedBox(width: 10,),
        Text('Designation: ', style: TextStyle(fontWeight: FontWeight.bold),),
        DropdownButton<String>(
          value: designation,
          icon: const Icon(Icons.arrow_downward, color: textColor, size: 18,),
          elevation: 16,
          underline: Container(
            height: 2,
            color: Colors.blue,
          ),
          onChanged: (String? value) {
            setState(() {
              designation = value!;
              print ('Designation Selected: $designation');
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

  Future<void> _showDialog(BuildContext context, String id, TextEditingController nameController, TextEditingController emailController, TextEditingController phoneNumController, String role, String designation) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text('Update User?'),
        actions: [
          TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel')),
          TextButton(onPressed: ()async{
            try {
              await _updateUser(id, nameController, emailController, phoneNumController, role, designation);// Await the API call for clarity
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User Updated')),
              );
              Navigator.pop(context);
              Navigator.pop(context); // Navigate back to view lists screen
              setState(() {
               UserLists;
              });
            } catch (error) {
              // Handle errors gracefully, e.g., display an error message
              print(error); // Log the error for debugging
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Update failed. Please try again.')),
              );
            }
            }, child: Text('Confirm')),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, UserList userData) async {

    String users_id= userData.usersId.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text('Delete User?'),
        actions: [
          TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel')),
          TextButton(onPressed: ()async{
            try {
              await _deleteUser(users_id);// Await the API call for clarity
              prefs.clear(); // Clear shared preferences after successful registration
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User Deleted')),
              );
              Navigator.pop(context); // Navigate back after registration
              setState(() {
                UserLists;
              });
            } catch (error) {
              // Handle errors gracefully, e.g., display an error message
              print(error); // Log the error for debugging
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to Delete. Please try again.')),
              );
            }
          }, child: Text('Confirm')),
        ],
      ),
    );
  }

  Future<UserData> getUserDataAPI(String selectedId) async {
    final body = {
      'users_id': selectedId,
    };
    Uri url = Uri.parse('$urlProd/get_user_data_api');
    var response = await http.post(
        url,
        body: body
    );
    if (response.statusCode == 200) {
      // print(response.body);
      setState(() {
        print("response in user: ${response.body}");
        userData = UserData.fromJson(jsonDecode(response.body));
        if (userData.status == 'success'){
        } else {
          Future.error(userData.status);
        }
        // print('userdata: $userData');
      });
    } else {
      Future.error("cannot retrieve data");
    }
    return userData;
  }

  Future<String> _updateUser(String id, TextEditingController nameController, TextEditingController emailController, TextEditingController phoneNumController, String role, String designation) async {
    final body = {
      'users_id': id,
      'name': nameController.text,
      'email': emailController.text,
      'phoneNum': phoneNumController.text,
      'role': role,
      'designation': designation,
    };
    print("response update user: ${body}");
    Uri url = Uri.parse('$urlProd/update_user');
    var response = await http.post(url, body: body);
    print("response updated the user data: ${response.body}");
    if (response.statusCode == 200) {
      // return Future.error('error');
      return 'Success';
    } else {
      print(response.body);
      return Future.error('error');
    }
  }

  Future<String> _deleteUser(String users_id) async {
    final body = {
      'users_id': users_id,
    };
    print("response delete user: ${body}");
    Uri url = Uri.parse('$urlProd/delete_user');
    var response = await http.post(url, body: body);
    print("response deleted the user data: ${response.body}");
    if (response.statusCode == 200) {
      // return Future.error('error');
      return 'Success';
    } else {
      print(response.body);
      return Future.error('error');
    }
  }

}