import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../view_user_screen.dart';
import 'dropdown.dart';

class AddUser extends StatefulWidget {
  const AddUser({
    Key? key,
  }) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {

  final GlobalKey _navigatorKey = GlobalKey<NavigatorState>();
  int userCounter = 0;
  bool isEditing = false;
  late BuildContext dialogContext;
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController designationController = TextEditingController();

  String? dropdownRoleValue;
  String? dropdownDesignationValue;

  @override
  void initState(){
    super.initState();
    // getData();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        SizedBox(height: defaultPadding),
        TextButton(
          onPressed: () => _showAddUserDialog(context),
          style: TextButton.styleFrom(backgroundColor: greenColor,
              fixedSize: Size(170, 40)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: textButtonColor, size: 24.0,),
              SizedBox(width: 10,),
              Text('Add New User', style: TextStyle(color: textButtonColor),),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddUserDialog(BuildContext context) {
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
                    Text('ADD NEW USER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
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
                      maxLength: 9,
                      controller: phoneNumController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Cannot be left empty';
                        } else if (!RegExp(r"^\d{1,9}$").hasMatch(value)){
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
                    Dropdown(
                      callback: (roleValue, designationValue){
                        setState(() {
                          dropdownRoleValue = roleValue;
                          dropdownDesignationValue = designationValue;
                        });
                      },
                    ),
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
                    // Navigator.of(context).pop(); // Close dialog after creation

                    if (_formKey.currentState!.validate() && dropdownRoleValue != '-' && dropdownDesignationValue != '-') {

                      print ('Role Selected: $dropdownRoleValue');
                      print ('Designation Selected: $dropdownDesignationValue');
                      _showDialog(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Missing Field/s')),
                        );
                      }
                    },

                  child: Text('Add User'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<String> userRegistrationApi() async {
    final body = {
      'name': nameController.text,
      'email': emailController.text,
      'phoneNum': phoneNumController.text,
      'role' : dropdownRoleValue.toString(),
      'designation' : dropdownDesignationValue.toString(),
    };
    print("response view register user: ${body}");
    Uri url = Uri.parse('$urlProd/register_user');
    var response = await http.post(url, body: body);
    print("response view new user data: ${response.body}");
    if (response.statusCode == 200) {
      // return Future.error('error');
      return 'Success';
    } else {
      print(response.body);
      return Future.error('error');
   }
  }

  Future<void> _showDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text('Add New User?'),
        actions: [
          TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel')),
          TextButton(onPressed: ()async{
            try {
              await userRegistrationApi(); // Await the API call for clarity
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User Registered')),
              );
              Navigator.pop(context);
              Navigator.pop(context); // Navigate back to form registration
            } catch (error) {
              // Handle errors gracefully, e.g., display an error message
              print(error); // Log the error for debugging
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registration failed. Please try again.')),
              );
            }
            }, child: Text('Confirm')),
        ],
      ),
    );
  }
}