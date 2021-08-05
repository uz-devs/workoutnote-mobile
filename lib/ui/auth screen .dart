import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business%20logic/user%20management%20%20provider.dart';
import 'package:workoutnote/ui/nav%20controller.dart';

class AuthScreen extends StatelessWidget {
  static String route = "auth";
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                        "Log In",
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
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
                          child: Text("login"),
                          onPressed: () {
                            user.login(_emailController.text, _passwordController.text).then((value) {
                              if (value) {
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => NavController()), (Route<dynamic> route) => false);
                              }
                            });
                          }),
                    )
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
