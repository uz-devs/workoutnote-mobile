import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/ui/language%20%20change%20screen.dart';
import 'package:workoutnote/ui/nav%20controller.dart';
import 'package:workoutnote/utils/strings.dart';

import 'language set screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen();

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  var _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Consumer<ConfigProvider>(
          builder: (context, user, child) {
            return Container(
              child: SingleChildScrollView(
                child: Container(
                 height: height,
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.all(10.0),
                          alignment: Alignment.centerLeft,
                          child: IconButton(onPressed: (){
                            Navigator.pop(context);

                          }, icon: Icon(Icons.arrow_back_ios,  color: Color.fromRGBO(102, 51, 204, 1),))),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.1),
                        child: Text(
                          "VERIFICATION",
                          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: height*0.1),
                        child: Text(
                          "입력한 번호로 인증을 해주세요",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                        child: TextFormField(
                          autofocus: true,
                          controller: _codeController,
                          decoration: InputDecoration(
                            hintText: "인증번호를 입력해주세요",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 13.0),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _codeController.clear();
                              },
                              icon: Icon(Icons.close),
                              color: Color.fromRGBO(102, 51, 204, 1),
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color:Color.fromRGBO(102, 51, 204, 1),
                              ),
                            ),
                            contentPadding: EdgeInsets.only(left: 20.0),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide(width: 1.5, color: Color.fromRGBO(102, 51, 204, 1))),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 15, right: 15.0,),
                        child: CupertinoButton(
                            color: Color.fromRGBO(102, 51, 204, 1),
                            borderRadius: const BorderRadius.all(Radius.circular(120)),
                            child: Text("${verificationText["한국어"]}"),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => LanguageSetScreen()));

                              user.verifyUser(_codeController.text).then((value) {
                                if (value) {
                                }
                              });


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
