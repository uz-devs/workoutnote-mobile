import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';

import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

import 'LanguageSetScreen.dart';
import 'SignupScreen.dart';

class LoginScreen extends StatelessWidget {
  static String route = 'auth';
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var configProvider = Provider.of<ConfigProvider>(context);

    return Scaffold(
      body: SafeArea(
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
                          alignment: Alignment.centerLeft,
                          child: GestureDetector (

                              child : Icon(
                                Icons.arrow_back_ios,
                                color: Colors.transparent,
                              ))),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.1),
                        child: Text(
                          '${loginText[english]}',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: height * 0.1),
                        child: Text(
                          '로그인합니다',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                        child: TextFormField(
                          controller: _emailController,
                          cursorColor: Color.fromRGBO(102, 51, 204, 1),
                          decoration: InputDecoration(

                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide(width: 1.5, color: Color.fromRGBO(102, 51, 204, 1))),
                            hintText: 'E-MAIL/PHONE NUMBER',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _emailController.clear();
                              },
                              icon: Icon(Icons.close),
                              color: Color.fromRGBO(102, 51, 204, 1),
                            ),
                            contentPadding: EdgeInsets.only(left: 20.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Color.fromRGBO(102, 51, 204, 1),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                        child: TextFormField(
                          cursorColor: Color.fromRGBO(102, 51, 204, 1),

                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  _passwordController.clear();
                                },
                                icon: Icon(Icons.close),
                                color: Color.fromRGBO(102, 51, 204, 1)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Color.fromRGBO(102, 51, 204, 1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide(width: 1.5, color: Color.fromRGBO(102, 51, 204, 1))),
                            hintText: 'PASSWORD',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
                            contentPadding: EdgeInsets.only(left: 20.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color.fromRGBO(102, 51, 204, 1), width: 2.0),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: CupertinoButton(
                            color: Color.fromRGBO(102, 51, 204, 1),
                            borderRadius: const BorderRadius.all(Radius.circular(120)),
                            child: Text('${loginText['한국어']}',  style:  TextStyle(fontSize: 16)),
                            onPressed: () {
                              if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {






                                showLoadingDialog(context);
                                user.login(user.trimField(_emailController.text), user.trimField(_passwordController.text)).then((value) {
                                  Navigator.pop(context);
                                  if (value) {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LanguageSetScreen()));
                                  } else {
                                    showSnackBar('${authErrorMesage[configProvider.activeLanguage()]}', context, Colors.red, Colors.white);
                                  }
                                });
                              } else
                                showSnackBar('${authEmptyFields[configProvider.activeLanguage()]}', context, Colors.red, Colors.white);
                            }),
                      ),
                      Container(

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  if (_emailController.text.isNotEmpty)
                                    user.passwordReset(_emailController.text).then((value) {
                                      print('value $value');
                                      if (value) {
                                        showSnackBar('${sendEmailForReset[configProvider.activeLanguage()]}', context, Colors.green, Colors.white);
                                       // showToast('${sendEmailForReset[configProvider.activeLanguage()]}');
                                      }
                                      else {
                                        showSnackBar('${authErrorMesage[configProvider.activeLanguage()]}', context, Colors.red, Colors.white);
                                       // showToast('${authErrorMesage[configProvider.activeLanguage()]}');
                                      }
                                    });
                                  else {
                                    showSnackBar('${emptyEmail[configProvider.activeLanguage()]}', context, Colors.red, Colors.white);

                                   // showToast('${emptyEmail[configProvider.activeLanguage()]}');
                                  }
                                },
                                child: Text(
                                  '비밀번호 찾기',
                                  style: TextStyle(color: Colors.grey, fontSize: 12.0),
                                ),
                              ),


                            ],
                          )),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                        child: CupertinoButton(
                            color: Color.fromRGBO(102, 51, 204, 1),
                            borderRadius: const BorderRadius.all(Radius.circular(120)),
                            child: Text('${signUpText['한국어']}', style:  TextStyle(fontSize: 16)),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
