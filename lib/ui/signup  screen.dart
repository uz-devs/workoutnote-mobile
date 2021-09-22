import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/providers/config%20provider.dart';

import 'package:workoutnote/ui/verification%20screen.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen();

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context, listen: true);
    var height = MediaQuery.of(context).size.height;

    return Scaffold(body: SafeArea(
      child: Consumer<ConfigProvider>(
        builder: (context, user, child) {
          return Container(
            child: SingleChildScrollView(
              child: Container(
                height: height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Container(
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.only(left: 10.0),
                        alignment: Alignment.centerLeft,
                        child: GestureDetector (
                            onTap: () {
                              if(Navigator.canPop(context))
                              Navigator.pop(context);
                            },
                            child : Icon(
                              Icons.arrow_back_ios,
                              color: Navigator.canPop(context) ?Color.fromRGBO(102, 51, 204, 1):Colors.transparent,
                            ))),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.1),
                      child: Text(
                        '${signUpText[english]}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1)),
                      ),
                    ),
                    Container(
                      child: Text(
                        '이메일 주소로 회원가입합니다',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    SizedBox(height: height * 0.1),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                      child: TextFormField(
                        autofocus: true,
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'NAME',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
                          contentPadding: EdgeInsets.only(left: 20.0),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _nameController.clear();
                            },
                            icon: Icon(Icons.close),
                            color: Color.fromRGBO(102, 51, 204, 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(102, 51, 204, 1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide(width: 1.5, color: Color.fromRGBO(102, 51, 204, 1))),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 14.0),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              _emailController.clear();
                            },
                            icon: Icon(Icons.close),
                            color: Color.fromRGBO(102, 51, 204, 1),
                          ),
                          hintText: 'E-MAIL/PHONE NUMBER',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
                          contentPadding: EdgeInsets.only(left: 20.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(102, 51, 204, 1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(width: 1.5, color: Color.fromRGBO(102, 51, 204, 1))),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                      child: TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              _passwordController.clear();
                            },
                            icon: Icon(Icons.close),
                            color: Color.fromRGBO(102, 51, 204, 1),
                          ),
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(102, 51, 204, 1),
                            ),
                          ),
                          hintText: 'PASSWORD',
                          contentPadding: EdgeInsets.only(left: 20.0),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(width: 1.5, color: Color.fromRGBO(102, 51, 204, 1))),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 15, right: 15.0),
                      child: CupertinoButton(
                          color: Color.fromRGBO(102, 51, 204, 1),
                          borderRadius: const BorderRadius.all(Radius.circular(120)),
                          child: Text('${signUpText['한국어']}',  style:  TextStyle(fontSize: 16)),
                          onPressed: ()  {
                            if (_emailController.text.isNotEmpty && _nameController.text.isNotEmpty && _passwordController.text.isNotEmpty)
                              user.sendVerificationCode(_emailController.text, _nameController.text, _passwordController.text).then((value) async {
                                if (value) {
                                 await  userPreferences!.setBool('signUpDone',  true);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => VerificationScreen()));
                                } else {
                                  showToast('${signUpError[configProvider.activeLanguage()]}');
                                }
                              });
                            else {
                             // Navigator.push(context, MaterialPageRoute(builder: (context) => VerificationScreen()));

                              showToast('${authEmptyFields[configProvider.activeLanguage()]}');
                            }
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => VerificationScreen()));
                          }),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 15, right: 15.0, top: 30),
                      child: CupertinoButton(
                          color: Color.fromRGBO(102, 51, 204, 1),
                          borderRadius: const BorderRadius.all(Radius.circular(120)),
                          child: Text('${loginText['한국어']}', style:  TextStyle(fontSize: 16),),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
}
