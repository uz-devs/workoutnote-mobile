import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business%20logic/config%20provider.dart';
import 'package:workoutnote/business%20logic/user%20management%20%20provider.dart';
import 'package:workoutnote/ui/nav%20controller.dart';
import 'package:workoutnote/utils/strings.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen();

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  var _codeController = TextEditingController();
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
                        "${verificationText[configProvider.activeLanguage()]}",
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: TextFormField(
                        autofocus: true,
                        controller: _codeController,
                        decoration: InputDecoration(
                          hintText: "Verification code",
                          suffixIcon: IconButton(onPressed: (){},  icon: Icon(Icons.close)),
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
                          child: Text("${verificationText[configProvider.activeLanguage()]}"),
                          onPressed: () {
                            user.verifyUser(_codeController.text).then((value) {
                              if(value) {
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                    NavController()), (Route<dynamic> route) => false);
                              }
                            });
                          }),
                    ),



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
