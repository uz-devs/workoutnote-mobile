import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/providers/user%20management%20%20provider.dart';

import 'package:workoutnote/ui/verification%20screen.dart';
import 'package:workoutnote/utils/strings.dart';

import 'nav controller.dart';

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
    var height  = MediaQuery.of(context).size.height;

    return Scaffold(

      body: SafeArea(
        child: Consumer<UserManagement>(
          builder: (context, user, child) {
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: height*0.1),
                      child: Text(
                        "${signUpText[configProvider.activeLanguage()]}",
                        style: TextStyle(fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(102, 51, 204, 1)),
                      ),
                    ),
                    Container(child: Text("이메일 주소로 회원가입합니다", style: TextStyle(fontSize: 18.0),),),
                    SizedBox(height: height*0.1),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: TextFormField(
                        autofocus: true,
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: "NAME",
                          hintStyle: TextStyle(color: Colors.grey),
                          suffixIcon: IconButton(onPressed: (){},  icon: Icon(Icons.close),  color: Color.fromRGBO(102, 51, 204, 1),),
                          contentPadding: EdgeInsets.all(10),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    width: 1.5,
                                    color: Color.fromRGBO(102, 51, 204, 1)
                                )
                            ),
                          border: OutlineInputBorder(


                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(onPressed: (){},  icon: Icon(Icons.close),  color: Color.fromRGBO(102, 51, 204, 1),),
                          hintText: "E-MAIL/PHONE NUMBER",
                          hintStyle: TextStyle(color: Colors.grey),


                          contentPadding: EdgeInsets.all(10),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: 1.5,
                                  color: Color.fromRGBO(102, 51, 204, 1)
                              )
                          ),
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
                          suffixIcon: IconButton(onPressed: (){},  icon: Icon(Icons.close),  color: Color.fromRGBO(102, 51, 204, 1),),

                          hintStyle: TextStyle(color: Colors.grey),

                          hintText: "PASSWORD",
                          contentPadding: EdgeInsets.all(10),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: 1.5,
                                  color: Color.fromRGBO(102, 51, 204, 1)
                              )
                          ),
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
                          color:  Color.fromRGBO(102, 51, 204, 1),
                          borderRadius: const BorderRadius.all(Radius.circular(120)),
                          child: Text("${signUpText['한국어']}"),
                          onPressed: () {
                            user.sendVerificationCode(_emailController.text,  _nameController.text,  _passwordController.text).then((value) {
                              if(value){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => VerificationScreen()));
                              }
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context) => VerificationScreen()));

                          }),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only( left: 10, right: 10.0, top: 30),
                      child: CupertinoButton(
                          color: Color.fromRGBO(102, 51, 204, 1),
                          borderRadius: const BorderRadius.all(Radius.circular(120)),
                          child: Text("${loginText["한국어"]}"),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                    SizedBox(height: height*0.1,),
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
      )


    );
  }
}
