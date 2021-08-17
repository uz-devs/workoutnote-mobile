
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/models/language%20model.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class LanguageChangeScreen extends StatefulWidget {
  const LanguageChangeScreen() ;

  @override
  _LanguageChangeScreenState createState() => _LanguageChangeScreenState();
}

class _LanguageChangeScreenState extends State<LanguageChangeScreen> {
  int value = 1;
  String item = english;
  List<Language> languages = [Language(english, 1), Language(korean, 2)];

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context, listen: true );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.deepPurpleAccent,


          onPressed: (){
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text("${languagesettingsscreenTitle[configProvider.activeLanguage()]}",  style: TextStyle(color:  Color.fromRGBO(102, 51, 204, 1)),),
      ),

      body: Consumer<ConfigProvider>(builder: (context, config, widget) {
        return ListView(
          children: languages.map((e)
          => RadioListTile<int?>(
              title: Text("${e.name}"),
              value:e.index, groupValue: config.value(), onChanged: (val) {
                config.changeLanguage(val!).then((value) {
                  setState(() {
                  });
                });

              })).toList(),
        );
      }));



  }
}


