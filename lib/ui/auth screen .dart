import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/providers/config%20provider.dart';

import 'package:workoutnote/ui/nav%20controller.dart';
import 'package:workoutnote/ui/signup%20%20screen.dart';
import 'package:workoutnote/utils/strings.dart';

class AuthScreen extends StatelessWidget {
  static String route = "auth";
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height  = MediaQuery.of(context).size.height;
    var configProvider = Provider.of<ConfigProvider>(context, listen: true);

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
                      ),
                      Container(
                         margin: EdgeInsets.only(top: height*0.1),
                          child: Text(
                            "${loginText[configProvider.activeLanguage()]}",
                            style: TextStyle(fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(102, 51, 204, 1)),
                          ),
                        ),
                      Container(
                        margin: EdgeInsets.only(bottom: height*0.1),
                        child: Text("로그인합니다", style: TextStyle(fontSize: 18.0),),),

                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                   width: 1.5,
                                    color: Color.fromRGBO(102, 51, 204, 1)
                                )
                            ),
                            hintText: "E-MAIL/PHONE NUMBER",
                            hintStyle: TextStyle(color: Colors.grey,  fontSize: 13.0),
                            suffixIcon: IconButton(onPressed: (){},  icon: Icon(Icons.close),  color: Color.fromRGBO(102, 51, 204, 1),),
                            contentPadding: EdgeInsets.only(left: 20.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color:Color.fromRGBO(102, 51, 204, 1),
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
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(onPressed: (){},  icon: Icon(Icons.close), color: Color.fromRGBO(102, 51, 204, 1)),


                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color:Color.fromRGBO(102, 51, 204, 1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                    width: 1.5,
                                    color: Color.fromRGBO(102, 51, 204, 1)
                                )
                            ),
                            hintText: "PASSWORD",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 13.0),

                            contentPadding: EdgeInsets.only(left: 20.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(102, 51, 204, 1),
                                width: 2.0
                              ),
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
                            child: Text("${loginText['한국어']}"),
                            onPressed: () {
                              user.login(_emailController.text, _passwordController.text).then((value) {
                                if (value) {
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => NavController()), (Route<dynamic> route) => false);
                                }
                              });
                            }),
                      ),
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: Text(
                          "비밀번호 찾기 | 아이디 찾기",
                          style: TextStyle(color: Colors.grey, fontSize: 12.0),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 15, right: 15.0, top: 15.0),
                        child: CupertinoButton(
                            color: Color.fromRGBO(102, 51, 204, 1),
                            borderRadius: const BorderRadius.all(Radius.circular(120)),
                            child: Text("${signUpText['한국어']}"),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                            }),
                      ),
                      // Spacer(),
                      // Expanded(
                      //   child: Container(
                      //     margin: EdgeInsets.only(left: 15, right: 15, bottom: 10.0),
                      //     alignment: Alignment.center,
                      //     child: Text(
                      //       "계속 진행함으로써 이용약관 및 개인정보 취급방침 이용약관에 동의합니다",  textAlign: TextAlign.center,),),
                      // )

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
