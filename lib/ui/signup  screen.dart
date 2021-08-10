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

    return Scaffold(

      body: SafeArea(
        child: Consumer<UserManagement>(
          builder: (context, user, child) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "${signUpText[configProvider.activeLanguage()]}",
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: "Name",
                          suffixIcon: IconButton(onPressed: (){},  icon: Icon(Icons.close)),
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
                        controller: _emailController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(onPressed: (){},  icon: Icon(Icons.close)),
                          hintText: "Email/Phone number",
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
                          suffixIcon: IconButton(onPressed: (){},  icon: Icon(Icons.close)),

                          hintText: "Password",
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
                          color: Colors.deepPurpleAccent,
                          borderRadius: const BorderRadius.all(Radius.circular(120)),
                          child: Text("${signUpText[configProvider.activeLanguage()]}"),
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
                      margin: EdgeInsets.only(left: 10, right: 10.0, top: 10),
                      child: CupertinoButton(
                          color: Colors.deepPurpleAccent,
                          borderRadius: const BorderRadius.all(Radius.circular(120)),
                          child: Text("${loginText[configProvider.activeLanguage()]}"),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),


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
