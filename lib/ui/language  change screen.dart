import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/models/language%20model.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/utils/strings.dart';

class LanguageChangeScreen extends StatefulWidget {
  const LanguageChangeScreen();

  @override
  _LanguageChangeScreenState createState() => _LanguageChangeScreenState();
}

class _LanguageChangeScreenState extends State<LanguageChangeScreen> {
  String item = english;
  List<Language> languages = [Language(english, 1), Language(korean, 2)];

  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.deepPurpleAccent,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text(
            "${languagesettingsscreenTitle[configProvider.activeLanguage()]}",
            style: TextStyle(color: Color.fromRGBO(102, 51, 204, 1)),
          ),
        ),
        body: Consumer<ConfigProvider>(builder: (context, config, widget) {
          return ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    configProvider.changeLanguage(languages[index].index ?? 1);
                  },
                  child: ListTile(
                    leading: Text("${languages[index].name}"),
                    trailing:   Icon(Icons.check, color: configProvider.activeLanguage() == languages[index].name? Color.fromRGBO(102, 51, 204, 1): Colors.transparent),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                    return Divider(height: 1, thickness: 1);
              },
              itemCount: languages.length);
        }));
  }
}

