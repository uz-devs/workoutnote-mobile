import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

import 'LanguageSetScreen.dart';

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
                          margin:EdgeInsets.only(left: 10.0),
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(onTap: (){
                            if(Navigator.canPop(context))
                            Navigator.pop(context);

                          }, child : Icon(Icons.arrow_back_ios,  color: Navigator.canPop(context)? Color.fromRGBO(102, 51, 204, 1):Colors.transparent,))),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.1),
                        child: Text(
                          'VERIFICATION',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: height*0.1),
                        child: Text(
                          '입력한 번호로 인증을 해주세요',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                        child: TextFormField(
                          autofocus: true,
                          controller: _codeController,
                          decoration: InputDecoration(
                            hintText: '인증번호를 입력해주세요',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
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
                            child: Text('완료', style:  TextStyle(fontSize: 16)),
                            onPressed: () {
                              showLoadingDialog(context);

                              user.verifyUser(_codeController.text).then((value) {

                                if (value) {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LanguageSetScreen()));
                                }
                                else{
                                  showSnackBar('${verificationError[configProvider.activeLanguage()]}',  context, Colors.red, Colors.white);
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
