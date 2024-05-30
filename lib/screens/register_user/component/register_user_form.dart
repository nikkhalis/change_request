import 'dart:convert';

import 'package:admin/models/designation_name_list.dart';
// import 'package:admin/models/unregistered_user_model.dart';
import 'package:admin/routes.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../../models/user_role_model.dart';
// import '../../../models/user_type_model.dart';


class RegisterUserForm extends StatefulWidget {
  final navigatorKey;
  const RegisterUserForm({Key? key, required this.navigatorKey}) : super(key: key);

  @override
  State<RegisterUserForm> createState() => _RegisterUserFormState();
}

class _RegisterUserFormState extends State<RegisterUserForm> {
  bool isLoaded = false;
  int userId = 0;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  late int userDesignationValue;
  late int userRoleValue;
  UserRole? userRoleList;
  UserDesignation? userDesignationList;
  bool approveAccess = false;
  bool mobileAccess = false;
  bool webAccess = false;
  int selectedUserType = 0;
  late BuildContext dialogContext;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    getData();
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded ? Container(
      padding: EdgeInsets.all(defaultPadding),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: secondaryColor/*secondaryColorLight*/,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New User Registration', style: TextStyle(fontWeight: FontWeight.bold),),
            Text('Name: ', style: TextStyle(fontWeight: FontWeight.bold),),
            TextFormField(
                style: TextStyle(color: textColor),
                enableInteractiveSelection: false,
                focusNode: AlwaysDisabledFocusNode(),
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cannot be blank';
                  }
                  return null;
                },
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
            Text('Email: ', style: TextStyle(fontWeight: FontWeight.bold),),
            TextFormField(
                style: TextStyle(color: textColor),
                // enabled: false,
                enableInteractiveSelection: false,
                focusNode: AlwaysDisabledFocusNode(),
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email cannot be blank';
                  }
                  return null;
                },
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
            Text('Phone Number', style: TextStyle(fontWeight: FontWeight.w300),),
            TextFormField(
                style: TextStyle(color: textColor),
                controller: phoneNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Cannot be left empty';
                  } else if (RegExp(r"\D").hasMatch(value)){
                    return 'Only numbers allowed';
                  }
                  return null;
                },
                minLines: 1,
                maxLines: null,
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
            Text('User Role', style: TextStyle(fontWeight: FontWeight.w300),),
            DropdownButton<int>(
                isExpanded: true,
                value: userRoleValue,
                icon: const Icon(Icons.arrow_downward, color: textColor, size: 18,),
                elevation: 16,
                style: const TextStyle(color: textColor),
                underline: SizedBox(),
                onChanged: (int? value) {
                  // This is called when the user selects an item.
                  if (value != null){
                    setState(() {
                      userRoleValue = value;
                    });
                  }
                },
                items: userRoleList!.userRoleList.map<DropdownMenuItem<int>>((UserRoleList value) {
                  return DropdownMenuItem<int>(
                      value: value.id,
                      child: Row(children: [
                        Text(value.role)
                      ],)
                  );
                }).toList()
            ),
            SizedBox(height: 10,),
            Text('User Designation', style: TextStyle(fontWeight: FontWeight.w300),),
            DropdownButton<int>(
                isExpanded: true,
                value: userDesignationValue,
                icon: const Icon(Icons.arrow_downward, color: textColor, size: 18,),
                elevation: 16,
                style: const TextStyle(color: textColor),
                underline: SizedBox(),
                onChanged: (int? value) {
                  // This is called when the user selects an item.
                  if (value != null){
                    setState(() {
                      userDesignationValue = value;
                    });
                  }
                },
                items: userDesignationList!.designationNameList.map<DropdownMenuItem<int>>((DesignationNameList value) {
                  return DropdownMenuItem<int>(
                      value: value.id,
                      child: Row(children: [
                        Text(value.designationName)
                      ],)
                  );
                }).toList()
            ),
            Divider(),
            // SizedBox(height: 10,),
            SizedBox(height: 10,),
            TextButton(
                onPressed: (){
                  if (_formKey.currentState!.validate()) {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        dialogContext = context;
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          child: Lottie.asset(
                            'assets/lottie/loading.json',
                            width: 350,
                            height: 270,
                            fit: BoxFit.fill,
                          ),);
                      },
                    );
                    userRegistrationApi()
                        .then((value) {
                      sendMail(nameController.text)
                          .then((value) {
                        if (value['status'].contains('Mail sent successfully')) {
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('User Registered')),
                          );
                        }
                        else {
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error to send mail please proceed to login', style: TextStyle(color: Colors.white),), backgroundColor: Colors.black87,),
                          );
                        }
                      })
                          .onError((error, stackTrace) {
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error', style: TextStyle(color: Colors.white),), backgroundColor: Colors.red,),
                        );
                      });
                      // Navigator.pop(context);
                      widget.navigatorKey.currentState!.pushNamed(routeRegisterUser);
                      // Navigator.pushNamed(context, routeDashboard);
                    })
                        .onError((error, stackTrace) {
                      print(error);
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to register'), backgroundColor: Colors.redAccent,),
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Missing Field/s')),
                    );
                  }
                },
                style: TextButton.styleFrom(backgroundColor: buttonColor/*primaryColorLight*/, fixedSize: Size(double.infinity, 40)),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Register', style: TextStyle(color: textButtonColor),),
                ],)
            )
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

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? tempId = prefs.getInt('user_type_id');

      // print(value.userList);
      userTypeApi()
          .then((value) {
        userDesignationApi()
            .then((value2) {
          setState(() {
            userId = tempId ?? 0;
            userRoleList = value;
            userDesignationList = value2;
            userDesignationValue = userDesignationList!.designationNameList.first.id;
            isLoaded = true;
          });
        })
            .onError((error, stackTrace) => null);
      })
        .onError((error, stackTrace) {
      print(error);
    });
  }

  Future<UserRole> userTypeApi() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      "Access-Control-Allow-Origin": "*"
    };
    Uri testUrl = Uri.parse('$urlProd/get_user_role_list');
    var response = await http.get(testUrl, headers: headers);
    if (response.statusCode == 200) {
      var result = UserRole.fromJson(jsonDecode(response.body));
      return result;
    } else {
      return Future.error('error');
    }
  }

  Future<UserDesignation> userDesignationApi() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      "Access-Control-Allow-Origin": "*"
    };
    Uri testUrl = Uri.parse('$urlProd/get_designation_name_list');
    var response = await http.get(testUrl, headers: headers);
    if (response.statusCode == 200) {
      var result = UserDesignation.fromJson(jsonDecode(response.body));
      return result;
    } else {
      return Future.error('error');
    }
  }

  Future<String> userRegistrationApi() async {
    final body = {
      'name': nameController.text,
      'email': emailController.text,
      'phoneNumber': phoneNumberController.text,
      'userRole': selectedUserType.toString(),
      'userDesignation': userDesignationValue.toString(),
    };
    print(body);
    Uri url = Uri.parse('$urlProd/register_user');

    var response = await http.post(url, body: body);
    if (response.statusCode == 200) {
      // return Future.error('error');
      return 'Success';
    } else {
      print(response.body);
      return Future.error('error');
    }
  }

  Future sendMail(String email) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      "Access-Control-Allow-Origin": "*"
    };
    Uri url = Uri.parse('$urlProd/sendMail_registerUser?email=$email');
    print(url);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return data;
    } else {
      return Future.error("cannot send email");
    }
    return response.body;
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
