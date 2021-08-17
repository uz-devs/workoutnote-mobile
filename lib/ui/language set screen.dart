import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/ui/intro%20screen.dart';
import 'package:workoutnote/ui/nav%20controller.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class LanguageSetScreen extends StatefulWidget {
  const LanguageSetScreen();

  @override
  _LanguageSetScreenState createState() => _LanguageSetScreenState();
}

class _LanguageSetScreenState extends State<LanguageSetScreen> {
  List<String> languages = [english, korean];
  String selectedVal = korean;
  int languageCode = 2;

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
                      // Container(
                      //     padding: EdgeInsets.all(10.0),
                      //     alignment: Alignment.centerLeft,
                      //     child: IconButton(
                      //         onPressed: () {
                      //           Navigator.pop(context);
                      //         },
                      //         icon: Icon(
                      //           Icons.arrow_back_ios,
                      //           color: Color.fromRGBO(102, 51, 204, 1),
                      //         ))),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.1),
                        child: Text(
                          "LANGUAGE",
                          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: height * 0.1),
                        child: Text(
                          "사용할 언어를 선택해주세요",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
                            contentPadding: EdgeInsets.only(left: 20.0, right: 10.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedVal,
                              onChanged: (val) {
                                selectedVal = val!;
                                switch (val) {
                                  case english:
                                    languageCode = 1;
                                    break;
                                  case korean:
                                    languageCode = 2;
                                    break;
                                }

                                configProvider.changeLanguage(languageCode).then((value) {});
                              },
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromRGBO(102, 51, 204, 1),
                              ),
                              items: languages.map((e) {
                                return DropdownMenuItem<String>(value: e, child: Text("$e"));
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                          left: 15,
                          right: 15.0,
                        ),
                        child: CupertinoButton(
                            color: Color.fromRGBO(102, 51, 204, 1),
                            borderRadius: const BorderRadius.all(Radius.circular(120)),
                            child: Text("${languageConfirm[configProvider.activeLanguage()]}"),
                            onPressed: () {
                              configProvider.changeLanguage(languageCode).then((value) {Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyIntroductionScreen()));});
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
