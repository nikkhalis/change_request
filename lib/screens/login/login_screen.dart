import 'dart:convert';

import 'package:admin/models/user_data_model.dart';
import 'package:admin/routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../controllers/MenuAppController.dart';
import '../main/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoaded = false;
  bool isEditing = false;
  late UserData userData;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hideText = true;
  bool verifyHideText = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    _checkSession();
    // checkUserAuthentication('rais.saleh@ssdu.com.my', 'ssdu@aw5');
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                Color(0xFFECE9E6),
                Color(0xFFFFFFFF),
                Color(0xFFECE9E6),
                Color(0xFFFFFFFF),
              ],
            )
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formKey,
            child: Center(
              child: SafeArea(
                child: Container(
                  width: 400,
                  child: SingleChildScrollView(
                    primary: false,
                    padding: EdgeInsets.all(defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: isLoaded ? [
                        Image.asset('assets/images/system_logo.png'),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('Login to Your Account', style: TextStyle(color: textColor,fontWeight: FontWeight.bold, fontSize: 28),)),
                        TextFormField(
                          style: TextStyle(color: textColor),
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            } else if (!isEditing && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@ssdu.com.my+").hasMatch(value)){
                              return 'not SSDU email';
                            }
                            return null;
                          },
                          onChanged: (value){
                            setState(() {
                              isEditing = true;
                              if (_formKey.currentState!.validate()) {}
                            });
                          },
                          onEditingComplete: () {
                            setState((){
                              isEditing = false;
                              if (_formKey.currentState!.validate()) {}
                            });
                          },
                          decoration: InputDecoration(
                              hintText: 'Email',
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
                          ),
                        ),
                        SizedBox(height: 5,),
                        TextFormField(
                          style: TextStyle(color: textColor),
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            } else if (!isEditing && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                              return 'password must include special character';
                            }
                            return null;
                          },
                          onChanged: (value){
                            setState(() {
                              isEditing = true;
                              if (_formKey.currentState!.validate()) {}
                            });
                          },
                          onEditingComplete: () {
                            setState((){
                              if (_formKey.currentState!.validate()) {}
                              isEditing = false;
                            });
                          },
                          obscureText: hideText,
                          obscuringCharacter: "*",
                          decoration: InputDecoration(
                              hintText: 'Password',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.blueGrey
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.blue
                                  )
                              ),
                              suffix: InkWell(onTap: (){ //add Icon button at end of TextField
                                setState(() { //refresh UI
                                  if(hideText){ //if passenable == true, make it false
                                    hideText = false;
                                  }else{
                                    hideText = true; //if passenable == false, make it true
                                  }
                                });
                              }, child: Icon(hideText == true?Icons.remove_red_eye:Icons.password))
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextButton(onPressed: (){
                          if (_formKey.currentState!.validate()) {
                            _dialogBuilder(context);
                            getUserDataAPI(emailController.text, passwordController.text).then((value) async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              print("user data: ${value}");
                              if (value.user.isNotEmpty) {
                                prefs = await SharedPreferences.getInstance();
                                await prefs.setInt('users_id', value.user[0].usersId);
                                await prefs.setString('name', value.user[0].name);
                                await prefs.setString('email', value.user[0].email);
                                await prefs.setString('phoneNum', value.user[0].phoneNum);
                                await prefs.setString('role', value.user[0].role);
                                await prefs.setString('designation', value.user[0].designation);

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Success to login...')),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                        create: (context) => MenuAppController(),
                                      ),
                                    ],
                                    child: MainScreen(),
                                  )),
                                );
                              } else if (value.status == 'User not found') {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('User not found')),
                                );
                              }
                              else {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Incorrect credentials')),
                                );
                                print('No data found');
                              }
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Missing Field/s')),
                            );
                          }
                        },
                            style: TextButton.styleFrom(backgroundColor: buttonColor,padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15)),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Login', style: TextStyle(color: textButtonColor, fontSize: 16),)])
                        ),
                      ] : [Lottie.asset(
                        'assets/lottie/loading.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.fill,
                      )],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<UserData> getUserDataAPI(String email, String password) async {
    final body = {
      'email': email,
      'password': password,//'ssdu@aw5',
    };
    Uri url = Uri.parse('$urlProd/get_user_data');
    var response = await http.post(
        url,
        body: body
    );
    if (response.statusCode == 200) {
      // print(response.body);
      setState(() {
        print("Login response: ${response.body}");
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

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
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
  }

  void _checkSession () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('users_id')!=null && prefs.getString('name')!=null && prefs.getString('email')!=null && prefs.getInt('phoneNum')!=null && prefs.getInt('role')!=null && prefs.getInt('designation')!=null) {
      print('session is stored');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Page is refreshed...')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => MenuAppController(),
            ),
          ],
          child: MainScreen(),
        )),
      );
      // setState(() {
      //   isLoaded = true;
      // });
    } else {
      print('session is not stored');
      setState(() {
        isLoaded = true;
      });
    }

  }
}
