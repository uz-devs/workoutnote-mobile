import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';
import 'package:workoutnote/utils/Strings.dart';
import 'package:workoutnote/utils/Utils.dart';

import 'IntroScreen.dart';

class LanguageSetScreen extends StatefulWidget {
  const LanguageSetScreen();

  @override
  _LanguageSetScreenState createState() => _LanguageSetScreenState();
}

class _LanguageSetScreenState extends State<LanguageSetScreen> {
  List<String> languages = [korean, english];
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
                      Container(
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.only(left: 10.0),
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                              onTap: () {
                                if (Navigator.canPop(context)) Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Navigator.canPop(context) ? Color.fromRGBO(102, 51, 204, 1) : Colors.transparent,
                              ))),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.1),
                        child: Text(
                          'LANGUAGE',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromRGBO(102, 51, 204, 1)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: height * 0.1),
                        child: Text(
                          '${chooseLang[configProvider.activeLanguage()]}',
                          style: TextStyle(fontSize: 16.0),
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
                                return DropdownMenuItem<String>(value: e, child: Text('$e'));
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
                            child: Text('${languageConfirm[configProvider.activeLanguage()]}', style: TextStyle(fontSize: 16)),
                            onPressed: () {
                              configProvider.changeLanguage(languageCode).then((value) async {
                                await userPreferences!.setBool('langSetDone', true);
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyIntroductionScreen()));
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
