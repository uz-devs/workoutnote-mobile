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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                       margin: EdgeInsets.only(top: height*0.1),
                        child: Text(
                          "${loginText[configProvider.activeLanguage()]}",
                          style: TextStyle(fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(102, 51, 204, 1)),
                        ),
                      ),
                    Container(child: Text("로그인합니다", style: TextStyle(fontSize: 18.0),),),
                    SizedBox(height: height*0.1),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                 width: 1.5,
                                  color: Color.fromRGBO(102, 51, 204, 1)
                              )
                          ),
                          hintText: "E-MAIL/PHONE NUMBER",
                          hintStyle: TextStyle(color: Colors.grey),
                          suffixIcon: IconButton(onPressed: (){},  icon: Icon(Icons.close),  color: Color.fromRGBO(102, 51, 204, 1),),
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(onPressed: (){},  icon: Icon(Icons.close), color: Color.fromRGBO(102, 51, 204, 1)),

                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: 1.5,

                                  color: Color.fromRGBO(102, 51, 204, 1)
                              )
                          ),
                          hintText: "PASSWORD",
                          hintStyle: TextStyle(color: Colors.grey),

                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10, right: 10.0),
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
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10, right: 10.0, top: 15.0),
                      child: CupertinoButton(
                          color: Color.fromRGBO(102, 51, 204, 1),
                          borderRadius: const BorderRadius.all(Radius.circular(120)),
                          child: Text("${signUpText['한국어']}"),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                          }),
                    ),
                    SizedBox(height: height*0.15),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      alignment: Alignment.center,
                      child: Text(

                      "계속 진행함으로써 이용약관 및 개인정보 취급방침 이용약관에 동의합니다",  textAlign: TextAlign.center,),)

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
