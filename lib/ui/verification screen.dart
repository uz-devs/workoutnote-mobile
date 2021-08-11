import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/providers/user%20management%20%20provider.dart';
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
    var height = MediaQuery.of(context).size.height;
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
                      margin: EdgeInsets.only(top: height * 0.1),
                      child: Text(
                        "VERIFICATION",
                        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1)),
                      ),
                    ),
                    Container(
                      child: Text(
                        "입력한 번호로 인증을 해주세요",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.1,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: TextFormField(
                        autofocus: true,
                        controller: _codeController,
                        decoration: InputDecoration(
                          hintText: "인증번호를 입력해주세요",
                          suffixIcon: IconButton(
                            onPressed: () {
                              _codeController.clear();
                            },
                            icon: Icon(Icons.close),
                            color: Color.fromRGBO(102, 51, 204, 1),
                          ),
                          contentPadding: EdgeInsets.all(10),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(width: 1.5, color: Color.fromRGBO(102, 51, 204, 1))),
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
                          child: Text("${verificationText["한국어"]}"),
                          onPressed: () {
                            user.verifyUser(_codeController.text).then((value) {
                              if (value) {
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => NavController()), (Route<dynamic> route) => false);
                              }
                            });


                          }),
                    ),
                    SizedBox(
                      height: height * 0.38,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "계속 진행함으로써 이용약관 및 개인정보 취급방침 이용약관에 동의합니다",
                        textAlign: TextAlign.center,
                      ),
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
